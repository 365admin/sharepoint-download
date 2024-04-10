FROM mcr.microsoft.com/powershell

RUN pwsh -c "Install-Module -Name PnP.PowerShell -Force -AllowPrerelease -Scope AllUsers;" 

RUN apt update -y
RUN apt upgrade -y
RUN apt install golang-1.21 -y
ENV GOBIN="/usr/local/bin"
ENV PATH="/usr/lib/go-1.21/bin:${PATH}"

ENV KITCHEN_HOME="/kitchens"
RUN go install github.com/koksmat-com/koksmat@v2.1.1.15
RUN koksmat context init sharepoint
WORKDIR /kitchens
COPY ./.koksmat/kitchenroot .
WORKDIR /kitchens/nexi-infocast
COPY . .  
WORKDIR /kitchens/nexi-infocast/.koksmat/app

RUN go install




CMD [ "sleep","infinity"]