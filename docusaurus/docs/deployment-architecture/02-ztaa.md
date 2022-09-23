---
title: ZTAA
---

import Share42Md from './share/_share42.mdx';
import Share15Md from './share/_share15.mdx';
import Share43Md from './share/_share43.mdx';
import Share23Md from './share/_share23.mdx';
import Share13Md from './share/_share13.mdx';

# ZTAA

This article describes the various edge deployments of ZiTi App Access. In all cases, the Controller and at least 2 Public Edge Routers are to be deployed for redundency. The Ziti Fabric connections are established between all Edge Routers but not Clients/SDKs. The Public Edge Routers would provide connection between Private Edge Routers and/or Clients/SDKs.

&nbsp;

:::info Note

- *Recommended configuration deployment of Public Edge Routers is to have only Ziti Edge enabled and of Private Edge Routers is to have Ziti Edge enabled with Tunnel option being required for cases where the Zero Trust domain ends at the private edge router.*

- *Acronyms used in this article:*
    - *ZDE - Ziti Desktop Edge*
    - *ZME - Ziti Mobile Edge*
    - *ZET - Ziti Edge Tunnel*
    
:::

&nbsp;

1. **Application to Application A Deployment**
    &nbsp;

    ![image](images/1.4.png)

    :::info Details
    - Client is SDK integrated.
    - Application is SDK integrated.
    :::

    &nbsp;

    :::tip Advantages
    - Application to Application Encryption 
    - No additional routing needed
    - No additional DNS entries needed
    :::

    &nbsp;

    :::caution Things to consider while deciding
    - SDK and Application source code availability
    :::

    &nbsp;

    ---
1. **Application to Application B Deployment**
    &nbsp;

    ![image](images/4.1.png)

    :::info Details
    - Client is SDK integrated
    - Application is SDK integrated
    :::

    &nbsp;

    :::tip Advantages
    - Application to Application Encryption 
    - No additional routing needed
    - No additional DNS entries needed
    :::

    &nbsp;

    :::caution Things to consider while deciding
    - SDK and Application source code availability
    :::

    &nbsp;

    ---
1. **Application to Application C Deployment**
    &nbsp;
    
    ![image](images/2.2.png)

    :::info Details
    - Client is SDK integrated
    - Application is SDK integrated.
    :::

    &nbsp;
    
    :::tip Advantages
    - No need to deploy private edge routers
    - Application to Application Encryption 
    - No additional routing needed
    - No additional DNS entries needed
    :::

    &nbsp;
        
    :::caution Things to consider while deciding
    - Fabric is not extended into application network
    - SDK and Application source code availability
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
 
    ---    
1. **Application to Router A Deployment**
    &nbsp;

    <Share15Md />

    &nbsp;

    --- 
1. **Application to Router B Deployment**
    &nbsp;

    <Share43Md />

