<#---
title: Setup

---


https://devblogs.microsoft.com/microsoft365dev/controlling-app-access-on-specific-sharepoint-site-collections/
# Controlling app access on a specific SharePoint site collections is now available in Microsoft Graph

![](https://devblogs.microsoft.com/microsoft365dev/wp-content/uploads/sites/73/2021/08/sharepoint_48x1.svg)

SharePoint team

February 11th, 2021 [2](https://devblogs.microsoft.com/microsoft365dev/wp-login.php?redirect_to=https%3A%2F%2Fdevblogs.microsoft.com%2Fmicrosoft365dev%2Fcontrolling-app-access-on-specific-sharepoint-site-collections%2F)

One very frequent request we’ve heard over the last couple years is to allow for more granular permissions when it comes to accessing SharePoint with an application.  Historically we’ve allowed you to select several levels of access but all at the tenant scope.

We are extremely excited to introduce the first step in providing more flexibility in how you control the access that your Microsoft Graph applications can have when working with SharePoint.  This is part of an overall longer-term effort to create a complete feature set that supports different needs for different customers.  We believe in solutions that will ultimately unify access management for applications across Microsoft 365.

This first step targets a specific scenario that we have gotten feedback on, namely, enabling Enterprise built applications to access specific known site collections rather than all site collections. This solution is very developer focused and requires engagement from both the application developer and an administrative team comfortable with using the Microsoft Graph API for management.

The feature itself is straightforward. A new permission is available for applications under the Microsoft Graph Sites set of permissions named **_Sites.Selected_**. Choosing this permission for your application instead of one of the other permissions will, by default, result in your application not having access to any SharePoint site collections.

[![Sites.selected permission in Azure AD](https://devblogs.microsoft.com/microsoft365dev/wp-content/uploads/sites/73/2021/02/jeremy-graph-permissions.png)](https://devblogs.microsoft.com/microsoft365dev/wp-content/uploads/sites/73/2021/02/jeremy-graph-permissions.png)

To grant permission for the application to a given site collection, the administrator will make use of the newly introduced site permissions endpoint. Using this endpoint, the administrator can grant Read, Write, or Read and Write permissions to an application.  Along with **_Sites.Selected_** this will result in only those sites that have had permission granted being accessible.

For example, if I wanted to grant the Foo application write permission to a single site collection, I would make this call:

Copy

```
POST https://graph.microsoft.com/v1.0/sites/{siteId}/permissions

Content-Type: application/json

{

&nbsp; "roles": ["write"],

&nbsp; "grantedToIdentities": [{

&nbsp;&nbsp;&nbsp; "application": {

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "id": "89ea5c94-7736-4e25-95ad-3fa95f62b66e",

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; "displayName": "Foo App"

&nbsp;&nbsp;&nbsp; }

&nbsp; }]

}
```

For more detailed information about using the API please see the [Microsoft Graph documentation](https://docs.microsoft.com/graph/api/site-get-permission?view=graph-rest-1.0).

See also following demo by [Jeremy Kelley](https://twitter.com/Fizzlenik) (Microsoft) from a recent Microsoft Graph community call for the additional details.

<iframe title="SharePoint Site Collection Level Permissions" width="640" height="360" src="https://www.youtube.com/embed/wcJRQDsXMQ8?feature=oembed" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen=""></iframe>

Over time we will continue to work with the Azure and Microsoft Graph teams to add additional capabilities and support more scenarios.

_“Sharing is caring”_

___

_SharePoint Team, Microsoft – 11th of February 2021_

#>
param (
    $ApplicationName = "NordicTerminalEstateManagement Automation",
    $Tenant = "christianiabpos.onmicrosoft.com"
    
)
Register-PnPAzureADApp -Interactive  -ApplicationName $ApplicationName -Tenant $Tenant