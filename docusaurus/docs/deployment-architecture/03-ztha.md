---
title: ZTHA
---

import Share42Md from './share/_share42.mdx';
import Share23Md from './share/_share23.mdx';
import Share13Md from './share/_share13.mdx';
import Share12Md from './share/_share12.mdx';
import Share31Md from './share/_share31.mdx';

# ZTHA

This article describes the various edge deployments of ZiTi Host Access. In all cases, the Controller and at least 2 Public Edge Routers are to be deployed for redundency. The Ziti Fabric connections are established between all Edge Routers but not Clients/SDKs. The Public Edge Routers would provide connection between Private Edge Routers and/or Clients/SDKs.

&nbsp;

:::info Note

- *Recommended configuration deployment of Public Edge Routers is to have only Ziti Edge enabled and of Private Edge Routers is to have Ziti Edge enabled with Tunnel option being required for cases where the Zero Trust domain ends at the private edge router.*

- *Acronyms used in this article:*
    - *ZDE - Ziti Desktop Edge*
    - *ZME - Ziti Mobile Edge*
    - *ZET - Ziti Edge Tunnel*
    
:::

&nbsp;

    ---
1. **Application to Host A Deployment**
    &nbsp;

    <Share13Md />

    &nbsp;

    ---
1. **Application to Host B Deployment**
    &nbsp;

    <Share42Md />

    &nbsp;

    ---
1. **Application to Host C Deployment**
    &nbsp;
    
    <Share23Md />

    &nbsp;

1. **Client to Host A Deployment**
    &nbsp;

    ![image](images/1.1.png)

    :::info Details
    - Client is ZDE/ZME enabled
    - Application host has a client software (ZET) deployed
    :::

    &nbsp;

    :::tip Advantages
    - Client to Host Encryption 
    - No additional routing needed
    - No additional DNS entries needed
    :::

    &nbsp;

    :::caution Things to consider while deciding
    - Software must be deployed to desktops/mobile
    - Software must be deployed to application servers
    :::

    &nbsp;

    ---    
1. **Client to Host B Deployment**
    &nbsp;

    ![image](images/2.1.png)

    :::info Details
    - Client is ZDE/ZME enabled
    - Application host has a client software (ZET) deployed
    :::
    
    :::tip Advantages
    - Client to Host Encryption 
    - No additional routing needed
    - No additional DNS entries needed
    - No need to deploy private edge routers
    :::

    &nbsp;
        
    :::caution Things to consider while deciding
    - Software must be deployed to desktops/mobile
    - Software must be deployed to application servers
    - Fabric is not extended into application server network
    
    :::

    &nbsp;

    ---    
1. **Client to Router Deployment**
    &nbsp;
    
    <Share12Md />
   
    &nbsp;

1. **Router to Host Deployment**
    &nbsp;
    
    <Share31Md />