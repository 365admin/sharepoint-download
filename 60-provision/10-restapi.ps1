<#---
title: Rest API deploy to production
tag: restapideployproduction
api: post
---

#>
if ((Split-Path -Leaf (Split-Path  -Parent -Path $PSScriptRoot)) -eq "sessions") {
  $path = join-path $PSScriptRoot ".." ".."
}
else {
  $path = join-path $PSScriptRoot ".." ".koksmat/"

}

$koksmatDir = Resolve-Path $path

$inputFile = join-path  $koksmatDir "koksmat.json"

if (!(Test-Path -Path $inputFile) ) {
  Throw "Cannot find file at expected path: $inputFile"
} 
$json = Get-Content -Path $inputFile | ConvertFrom-Json
$version = "v$($json.version.major).$($json.version.minor).$($json.version.patch).$($json.version.build)"
$port = "8336"
$appname = $json.appname
$imagename = $json.imagename
$dnsname = $json.apidnsprod

$envs = @()
function env($name, $value ) {
  if ($null -eq $value) {
    throw "Environment value for $name is not set"
  }
  return @{name = $name; value = $value }
}



$envs += env "PNPAPPID" $env:PNPAPPID
$envs += env "PNPTENANTID" $env:PNPTENANTID
$envs += env "PNPCERTIFICATE" $env:PNPCERTIFICATE
$envs += env "PNPSITE" $env:PNPSITE
$envs += env "NATS" "nats://nats:4222"
$envs += env "KITCHENROOT" "/kitchens"
$configEnv = ""
foreach ($item in $envs) {

  $configEnv += @"
        - name: $($item.name)
          value: $($item.value)

"@
}

$image = "$($imagename)-app:$($version)"

$config = @"
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-$appname-api
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  storageClassName: azurefile
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: $appname-api
spec:
  selector:
    matchLabels:
      app: $appname-api
  replicas: 1
  template:
    metadata:
      labels:
        app: $appname-api
    spec: 
      containers:
      - name: $appname-api
        image: $image
        ports:
          - containerPort: $port
        command: [$appname]
        args: ["serve"]               
  
        env:
        - name: KEY
          value: VALUE3
        - name: DATAPATH
          value: /data          
$configEnv                           
        volumeMounts:
        - mountPath: /data
          name: data          
          
      volumes:
      - name: data
        persistentVolumeClaim:
          claimName: pvc-$appname-api
---
apiVersion: v1
kind: Service
metadata:
  name: $appname-api
  labels:
    app: $appname-api
    service: $appname-api
spec:
  ports:
  - name: http
    port: 5301
    targetPort: $port
  selector:
    app: $appname-api
---    
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: $appname-api
spec:
  rules:
  - host: $dnsname
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: $appname-api
            port:
              number: 5301
    

"@

write-host "Applying config" -ForegroundColor Green

write-host $config -ForegroundColor Gray

$config |  kubectl apply -f -