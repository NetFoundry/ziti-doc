---
id: features
title: Features
---

# Features 
Ziti has many features

* The Ziti fabric provides a scalable, pluggable, networking mesh with built in smart routing
* The Ziti edge components provide a secure, Zero Trust entry point into your network
* The Ziti SDKs allow you to integrate Ziti directly into your applications
* The Ziti tunnelers and proxies allow existing applications and networks to take advantage of a Ziti deployment


## Security Features
* Zero Trust and Application Segmentation
* Dark Services and Routers
* End to end encryption

## Performance and Reliability
* A scalable mesh fabric with smart routing
* Support for load balancing services for both horizontal scale and failover setups 

## Developer Focus
* [Open source code, available with the Apache 2.0 license](https://github.com/openziti)
* Fully programable REST management APIs
* [SDKs for a variety of programming languages](./clients/sdks)
* [Application specific configuration store allowing centralized management of configuration allowing you to add structured configuration specific to your application](config-store/overview)
* An extensible fabric, allowing you to add your own 
    * load balancing algorithms
    * interconnect protocols
    * ingress and egress protocols
    * metrics collections frameworks
    * control and management plane messaging and semantics   

## Easy Management
* [A flexible and expressive policy model for managing access to services and edge routers](./security/authorization/policies/overview)
* A web based admin console
* [Pre-built tunnelers and proxies for a variety of operating systems, including mobile](./clients/tunnelers)

## Understanding buzzwords

### Zero Trust/Application Segmentation
Many networking security solutions act like a wall around an internal network. Once you are through the wall, you have access to everything inside. Zero trust solutions enforce not just access to a network, but access to individual applications within that network. 

Every client in a Ziti system must have an identity with provisioned certificates. The certificates are used to establish secure communications channels as well as for authentication and authorization of the associated identity. Whenever the client attempts to access a network application, Ziti will first ensure that the identity has access to the application. If access is revoked, open network connections will be closed.

This model enables Ziti systems to provide access to multiple applications while ensuring that clients only get access to those applications to which they have been granted access.    

In addition to requiring cert based authentication for clients, Ziti uses certificates to authorize communication between Ziti components. 

### Dark Services and Routers
There are various levels of accessibility a network application/service can have.

1. Many network services are available to the world. The service then relies on authentication and authorization policies to prevent unwanted access. 
1. Firewalls can be used to limit access to specific IP or ranges. This increases security at the cost of flexibility. Adding users can be complicated and users may not be able to easily switch devices or access the service remotely.
1. Services can be put behind a VPN or made only accessible to an internal network, but there are some downsides to this approach.
    1. If you can access the VPN or internal network for any reason, all services in that VPN become more vulnerable to you.
    1. VPNs are not usually appropriate for external customers or users.
    1. For end users, VPNs add an extra step that needs to be done each time they want to access the service.
1. Services can be made dark, meaning they do not have any ports open for anyone to even try and connect to. 

Making something dark can be done in a few ways, but the way it's generally handled in Ziti is that services reach out and establish one or more connections to the Ziti network fabric. Clients coming into the fabric can then reach the service through these connections after being authenticated and authorized. 

Ziti routers, which make up the fabric, can also be dark. Routers locoated in private networks will usually be made dark. These routers will reach out of the private network to talk to the controller and to make connections to join the network fabric mesh. This allows the services and routers in your private networks to make only outbound connections, so no holes have to be opened for inbound traffic.

Services can be completely dark if they are implemented with a Ziti SDK. If this is not possible a Ziti tunneler or proxy can be colocated with the service. The service then only needs to allow connections from the local machine or network, depending on how close you colocate the proxy to the service.   

### End to End Encryption
If you take advantage of Ziti's developer SDKs and embed Ziti in your client and server applications, your traffic can be configured to be seamlessly encrypted from the client application to server application. If you prefer to use tunnelers or proxy applications, the traffic can be encrypted for you from machine to machine or private network to private network. Various combinations of the above are also supported.

End-to-end encryption means that even if systems between the client and server are compromised, your traffic cannot be decrypted or tampered with.
