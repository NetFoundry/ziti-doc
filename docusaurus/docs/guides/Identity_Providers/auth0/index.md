---
title: Auth0 for BrowZer
sidebar_label: Auth0
slug: /identity-providers-for-browZer-auth0
---

<head>
  <title>Auth0 for OpenZiti BrowZer</title>
  <meta
    name="description"
    content="How to configure Auth0 for OpenZiti BrowZer."
  />
</head>

<img src="/icons/logo-auth0.svg" alt="How to configure Auth0 for OpenZiti BrowZer" width="20%"/>

### Get an Auth0 Account

If you don't already have an account you can sign up for a free account at https://auth0.com/signup

### Add a new Application

Once you have an Auth0 account, click on "Applications" in the left navbar:

<p align="center">

![Auth0 Applications](/img/auth0-apps.jpg)

</p>
<br/>

Then click on the "Create Application":

<p align="center">

![Auth0 Create Application](/img/auth0-apps-create.jpg)

</p>
<br/>

Then Create a "Single Page Web Application":

<p align="center">

![Auth0 Create SPA](/img/auth0-spa.jpg)

</p>

### Add Callback & Logout URL

BrowZer software will perform an OIDC/PKCE exchange with your Auth0 identity provider when your users authenticate onto your Ziti network. For this to succeed, you need to add your [wildcard domain](/docs/learn/quickstarts/browzer/example/#get-a-wildcard-certificate) to both the `Allowed Callback URLs` setting, and the `Allowed Logout URLs` setting for your Aut0 application:

<p align="center">

![Auth0 callbacks](/img/auth0-callbacks.jpg)

</p>
<br/>
For example:
<p align="center">

![Auth0 callbacks](/img/auth0-callbacks-2.jpg)

</p>
<br/>

Failure to properly configure the above two settings will result in the following Auth0 error page when your users visit your 
[BrowZer URL](/docs/learn/quickstarts/browzer/example/#get-a-wildcard-certificate):

<p align="center">

![Auth0 callbacks](/img/auth0-callbacks-error.jpg)

</p>
<br/>

### Gather IdP Information

Your OpenZiti network must be configured to become aware of your Auth0 identity provider.  OpenZiti refers to the identity provider as an `External JWT Signer`.  Before you can set up the new JWT signer, you must gather some information from the new Auth0 Application that you just created:
- the `clientId`
- the `issuer`
- the `jwks_uri`
<br/>
<br/>

#### Gather `clientId`

The `clientID` value can be found in the `Settings` tab of the SPA you created above:

<p align="center">

![Auth0 clientId](/img/auth0-clientId.jpg)

</p>
<br/>

#### Gather `issuer`

The `issuer` can be found via the openid-configuration endpoint that all OIDC-compliant identity providers expose.  The openid-configuration endpoint URL for Auth0 looks like this:

<p align="center">

`https://<AUTH0_DOMAIN>/.well-known/openid-configuration`

</p>

where the value for `<AUTH0_DOMAIN>` can be found in the `Settings` tab of the SPA you created above:

<p align="center">

![Auth0 Domain](/img/auth0-domain.jpg)

</p>

When you enter the openid-configuration endpoint URL (`https://<AUTH0_DOMAIN>/.well-known/openid-configuration`) into a browser, you will receive a response resembling the following:

<p align="center">

![Auth0 OIDC config](/img/auth0-oidc-config.jpg)

</p>
<br/>

Take note of the `issuer` value.
<br/>


#### Gather `jwks_uri`
Take note of the `jwks_uri` value returned from the above openid-configuration endpoint URL.
<br/>

### Create External JWT Signer
Using the values described above, use the `ziti` CLI to configure an external JWT signer that represents your Auth0 identity provider.  You can find details on how to do this in the [BrowZer Quickstart documentation](/docs/learn/quickstarts/browzer/)

