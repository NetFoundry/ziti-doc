---
sidebar_position: 50
sidebar_label: Services
title: Services
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# 3.0 Ziti services
## 3.1 Introduction
In this guide, we will demonstrate ziti services with three examples:
- connection between two identities running ziti-edge-tunnel ([Network Diagram 1](#311-network-diagram-1))
- connection between ziti-edge-tunnel and a ziti-router (with tunnel enabled)([Network Diagram 2](#312-network-diagram-2))
- connection from a non-OpenZiti endpoint using router as GW([Network Diagram 2](#312-network-diagram-2))

### 3.1.1 Network Diagram 1
![Diagram](/img/public_cloud/Services01.jpg)

### 3.1.2 Network Diagram 2
![Diagram](/img/public_cloud/Services02.jpg)

This guide provides both CLI and GUI (ZAC) instructions. To use ZAC, make sure ZAC is installed. If you have not installed ZAC, and would like to use it in this section, please follow the [ZAC Setup Guide](Controller#13-setup-ziti-administration-console-zac) before continue.

## 3.2 Setup VMs for ziti network
### 3.2.1 Controller
#### 3.2.1.1 ZAC
Please make sure you can login to your network and see the welcome screen before continue.

![Diagram](/img/public_cloud/ZAC4.jpg)

#### 3.2.1.2 CLI
You will need to login to controller to provision identities and service. Please make sure you are performing the action on the right node.

On the controller, before performing the CLI command, you will need to login first:
```bash
zitiLogin
```

The login token expires after a period of time. If the token expired, you will need to login again via the same command. You will see error message like this when the CLI logs out:
```
error: error listing https://161.35.108.218:8441/edge/management/v1/config-types?filter=id%3D%22host.v1%22 in Ziti Edge Controller. Status code: 401 Unauthorized, Server returned: {
    "error": {
        "code": "UNAUTHORIZED",
        "message": "The request could not be completed. The session is not authorized or the credentials are invalid",
        "requestId": "7zxWCy7Vx"
    },
    "meta": {
        "apiEnrollmentVersion": "0.0.1",
        "apiVersion": "0.0.1"
    }
}
```

### 3.2.2 Router
We need two routers to complete our example in this guide.

- Public Edge Router (**pub-er**) was setup in the [Router setup section](Router#23-create-and-setup-router-directly-on-router-vm), this router provides fabric and edge connection. It does not have tunneler functionality.
- Local Edge Router (**local-er**). Please follow the [Router guide](Router/) to setup a [Router with edge listener and tunneler](Router/#2343-create-the-router-with-edge-listener-and-tunneler).

#### 3.2.2.1 ZAC
On the ZAC **ROUTERS** screen, you can check your router and make sure it is created correctly. You can also check the identity associated with the router by clicked on **IDENTITIES**

On the **ROUTERS** screen, you will see two routers we created.

![Diagram](/img/public_cloud/Services03-router.jpg)

On the **IDENTITIES** screen, you will see an identity match "local-er" router name. If you perform the provisioning correctly, you should **not** see an identity name "pub-er".

![Diagram](/img/public_cloud/Services04-router.jpg)

#### 3.2.2.2 CLI
You can also check the provisioning on the **controller**.

You should see two routers named **pub-er** and **local-er**
```
# ziti edge list edge-routers
╭────────────┬─────────────────────────────┬────────┬───────────────┬──────┬────────────╮
│ ID         │ NAME                        │ ONLINE │ ALLOW TRANSIT │ COST │ ATTRIBUTES │
├────────────┼─────────────────────────────┼────────┼───────────────┼──────┼────────────┤
│ MvQnOZj4au │ Public-Cloud-NC-edge-router │ true   │ true          │    0 │ public     │
│ k06PffZjT  │ pub-er                      │ true   │ true          │    0 │            │
│ nIaTfUZjT  │ local-er                    │ true   │ true          │    0 │            │
╰────────────┴─────────────────────────────┴────────┴───────────────┴──────┴────────────╯
results: 1-3 of 3
```
You should also see an identity named **local-er**
```
# ziti edge list identities
╭────────────┬─────────────────────────────┬────────┬────────────┬─────────────╮
│ ID         │ NAME                        │ TYPE   │ ATTRIBUTES │ AUTH-POLICY │
├────────────┼─────────────────────────────┼────────┼────────────┼─────────────┤
│ MvQnOZj4au │ Public-Cloud-NC-edge-router │ Router │            │ default     │
│ nIaTfUZjT  │ local-er                    │ Router │            │ default     │
│ oJCCNs6Xo  │ Default Admin               │ User   │            │ default     │
╰────────────┴─────────────────────────────┴────────┴────────────┴─────────────╯
results: 1-3 of 3
```
Since the **pub-er** is also a link listener, you should also check the link listener function is correctly setup. Check the router on fabric to make sure it has LISTENERS (tls:\*\*\*\*) displayed for the **pub-er**. 
```
# ziti fabric list routers
╭────────────┬─────────────────────────────┬────────┬──────┬──────────────┬──────────┬────────────────────────┬────────────────────────────╮
│ ID         │ NAME                        │ ONLINE │ COST │ NO TRAVERSAL │ DISABLED │ VERSION                │ LISTENERS                  │
├────────────┼─────────────────────────────┼────────┼──────┼──────────────┼──────────┼────────────────────────┼────────────────────────────┤
│ MvQnOZj4au │ Public-Cloud-NC-edge-router │ true   │    0 │ false        │ false    │ v0.27.9 on linux/amd64 │ 1: tls:68.183.52.206:10080 │
│ k06PffZjT  │ pub-er                      │ true   │    0 │ false        │ false    │ v0.27.9 on linux/amd64 │ 1: tls:159.203.175.189:80  │
│ nIaTfUZjT  │ local-er                    │ true   │    0 │ false        │ false    │ v0.27.9 on linux/amd64 │                            │
╰────────────┴─────────────────────────────┴────────┴──────┴──────────────┴──────────┴────────────────────────┴────────────────────────────╯
results: 1-3 of 3
```

### 3.2.3 Tunnelers/Identities
We need two tunnelers for our testing. Please follow **[Create a VM section](Controller/#11-create-a-vm-to-be-used-as-the-controller)** of the Controller Guide to create two VMs running Ubuntu 22.04.

#### 3.2.3.1 Create Identity with ZAC
To create Identities on ZAC, go to the Identities screen, and press **+** icon. On the **CREATE IDENTITY** widget, enter the **NAME** of the identity (Required and has to be unique). Leave the **IDENTITY TYPE** as "Device". Leave the **ENROLLMENT TYPE** as "One Time Token". Fill in other optional fields and press **SAVE**.

Create two identities:
- ingress-tunnel
- egress-tunnel

![Diagram](/img/public_cloud/Services05-CreateService.jpg)

Once the identities are created, you can check the identities and download the **JWT** from the **MANAGE IDENTITIES** screen

![Diagram](/img/public_cloud/Services06-CreateService.jpg)


#### 3.2.3.2 Create Identity with CLI
Create two identities (ingress-tunnel, egress-tunnel) on the **controller**:
```bash
ziti edge create identity user ingress-tunnel -o ingress-tunnel.jwt
ziti edge create identity user egress-tunnel -o egress-tunnel.jwt
```

#### 3.2.3.3 Register Identities
Login to your VMs created earlier, follow [Install Linux Package](/docs/reference/tunnelers/linux/) **Ubuntu Jammy 22.04** section to install and register your ziti-edge-tunnel.

After the tunnel is registered, check the status and make sure it is running
```
# systemctl status ziti-edge-tunnel
● ziti-edge-tunnel.service - Ziti Edge Tunnel
     Loaded: loaded (/etc/systemd/system/ziti-edge-tunnel.service; enabled; vendor preset: enabled)
     Active: active (running) since Wed 2023-04-05 20:57:04 UTC; 1min 41s ago
    Process: 2640 ExecStartPre=/opt/openziti/bin/ziti-edge-tunnel.sh (code=exited, status=0/SUCCESS)
   Main PID: 2641 (ziti-edge-tunne)
      Tasks: 5 (limit: 2323)
     Memory: 6.5M
        CPU: 752ms
     CGroup: /system.slice/ziti-edge-tunnel.service
             └─2641 /opt/openziti/bin/ziti-edge-tunnel run --verbose=2 --dns-ip-range=100.64.0.1/10 --identity-dir=/opt/openziti/etc/identities
```

## 3.3 Create Edge Router Policy
By default, the system created an edge router policy to bind all identities to any routers tag with **#public** attribute. So, we need to add #public to our router (pub-er). 

### 3.3.1 ZAC

From the **ROUTERS** screen, you can choose **Router Policies** to display the edge router policies. As you can see, the default policy is already in place.

![Diagram](/img/public_cloud/Services07-router-policy.jpg)

To add attribute "public" to the router, choose your router from the **ROUTERS** screen, click on **...** and choose **Edit**

![Diagram](/img/public_cloud/Services08-router-update.jpg)

On the **EDIT EDGE ROUTER** screen, you can add **public** attribute and then press **SAVE**

![Diagram](/img/public_cloud/Services09-router-update.jpg)

### 3.3.2 CLI
On the **controller**:

Check the edge router policy. Make sure "allEdgeRouters" policy is present.
```
# ziti edge list edge-router-policies
╭────────────────────────┬───────────────────────────────┬──────────────────────────────┬──────────────────────────────╮
│ ID                     │ NAME                          │ EDGE ROUTER ROLES            │ IDENTITY ROLES               │
├────────────────────────┼───────────────────────────────┼──────────────────────────────┼──────────────────────────────┤
│ 2YkzdKlvqraTF3VX6r9pJk │ allEdgeRouters                │ #public                      │ #all                         │
│ MvQnOZj4au             │ edge-router-MvQnOZj4au-system │ @Public-Cloud-NC-edge-router │ @Public-Cloud-NC-edge-router │
│ nIaTfUZjT              │ edge-router-nIaTfUZjT-system  │ @local-er                    │ @local-er                    │
╰────────────────────────┴───────────────────────────────┴──────────────────────────────┴──────────────────────────────╯
results: 1-3 of 3
```

check the edge router attribute
```
# ziti edge list edge-routers
╭────────────┬─────────────────────────────┬────────┬───────────────┬──────┬────────────╮
│ ID         │ NAME                        │ ONLINE │ ALLOW TRANSIT │ COST │ ATTRIBUTES │
├────────────┼─────────────────────────────┼────────┼───────────────┼──────┼────────────┤
│ MvQnOZj4au │ Public-Cloud-NC-edge-router │ true   │ true          │    0 │ public     │
│ k06PffZjT  │ pub-er                      │ true   │ true          │    0 │            │
│ nIaTfUZjT  │ local-er                    │ true   │ true          │    0 │            │
╰────────────┴─────────────────────────────┴────────┴───────────────┴──────┴────────────╯
results: 1-3 of 3
```

Add "public" attribute to "pub-er" router:
```
# ziti edge update edge-router pub-er -a "public"
# ziti edge list edge-routers
╭────────────┬─────────────────────────────┬────────┬───────────────┬──────┬────────────╮
│ ID         │ NAME                        │ ONLINE │ ALLOW TRANSIT │ COST │ ATTRIBUTES │
├────────────┼─────────────────────────────┼────────┼───────────────┼──────┼────────────┤
│ MvQnOZj4au │ Public-Cloud-NC-edge-router │ true   │ true          │    0 │ public     │
│ k06PffZjT  │ pub-er                      │ true   │ true          │    0 │ public     │
│ nIaTfUZjT  │ local-er                    │ true   │ true          │    0 │            │
╰────────────┴─────────────────────────────┴────────┴───────────────┴──────┴────────────╯
results: 1-3 of 3
```

## 3.4 Setup Tunnel to Tunnel ssh connection

In this section, we will be showing how to configure ziti to establish ssh service via our network. We will be using a pseudo dns name (t2tssh.ziti) to establish this connection.  The intercept side (ingress) will be ingress-tunnel, the server side (egress) will be egress-tunnel.

For CLI procedures, all commands are done on the **controller**

### 3.4.1 Create a host.v1 config

This config is used instruct the server-side tunneler how to offload the traffic from the overlay, back to the underlay. We are dropping the traffic off our loopback interface, so we use the address "127.0.0.1“

#### 3.4.1.1 ZAC
Create the configuration from **MANAGE CONFIGURATIONS** screen.

![Diagram](/img/public_cloud/Services10.png)

#### 3.4.1.2 CLI
```bash
ziti edge create config t2thostconf host.v1 '{"protocol":"tcp", "address":"127.0.0.1", "port":22}'
```
### 3.4.2 Create an intercept.v1 config 
This config is used to instruct the intercept-side tunneler how to correctly intercept the targeted traffic and put it onto the overlay. We are setting up intercept on dns name "t2tssh.ziti"

#### 3.4.2.1 ZAC
![Diagram](/img/public_cloud/Services11.png)

Check the provisioned configs on the configuration screen:

![Diagram](/img/public_cloud/Services12.png)

#### 3.4.2.2 CLI
```bash
ziti edge create config t2tintconf intercept.v1 '{"protocols": ["tcp"], "addresses": ["t2tssh.ziti"], "portRanges": [{"low": 22, "high": 22}]}'
```
If the command finished successfully, you will see two configs:
```
# ziti edge list configs
╭────────────────────────┬─────────────┬──────────────╮
│ ID                     │ NAME        │ CONFIG TYPE  │
├────────────────────────┼─────────────┼──────────────┤
│ 1R9iDpU7OvREH6LNxQapPO │ t2tintconf  │ intercept.v1 │
│ gIeZ1KgilGXzkY4RxDF2f  │ t2thostconf │ host.v1      │
╰────────────────────────┴─────────────┴──────────────╯
results: 1-2 of 2
```
### 3.4.3 Create Service
Now we need to put these two configs into a service. We going to name the service "t2tssh":

#### 3.4.3.1 ZAC
Create service from **Services** menu from **MANAGE EDGE SERVICES** screen.

![Diagram](/img/public_cloud/Services13.png)

#### 3.4.3.2 CLI
```bash
ziti edge create service t2tssh -c t2tintconf,t2thostconf
```

**Check Service**
```
# ziti edge list services
╭───────────────────────┬────────┬────────────┬─────────────────────┬────────────╮
│ ID                    │ NAME   │ ENCRYPTION │ TERMINATOR STRATEGY │ ATTRIBUTES │
│                       │        │  REQUIRED  │                     │            │
├───────────────────────┼────────┼────────────┼─────────────────────┼────────────┤
│ CZJi5tDxTk8C8XymCbu7f │ t2tssh │ true       │ smartrouting        │            │
╰───────────────────────┴────────┴────────────┴─────────────────────┴────────────╯
results: 1-1 of 1
```
Please note, the **Encryption = true** and **smartrouting** are default setting.

### 3.4.4 Create Bind Service policy
Now we need to specify which tunneler (in our case, **egress-tunnel**)is going to host the service by setting up a bind service policy

#### 3.4.4.1 ZAC

Create a **service policy** from **MANAGE SERVICE POLICIES** screen:

![Diagram](/img/public_cloud/Services15-Bind.jpg)

#### 3.4.4.2 CLI
```bash
ziti edge create service-policy t2tssh.bind Bind --service-roles '@t2tssh' --identity-roles "@egress-tunnel"
```
### 3.4.5 Create Dial Service policy
Now we need to specify the intercept side tunneler (**ingress-tunnel**) for the service by setting up a dial service policy

#### 3.4.5.1 ZAC

![Diagram](/img/public_cloud/Services16-Dial.jpg)

We should have two service policies created. The services name should match on two policies.  One policy is Bind and the other ons is Dial.  They should be set to different identities.

![Diagram](/img/public_cloud/Services17.jpg)
#### 3.4.5.2 CLI
```bash
ziti edge create service-policy t2tssh.dial Dial --service-roles '@t2tssh' --identity-roles "@ingress-tunnel"
```
Make sure both policies are setup correctly：
```
# ziti edge list service-policies
╭────────────────────────┬─────────────┬──────────┬───────────────┬─────────────────┬─────────────────────╮
│ ID                     │ NAME        │ SEMANTIC │ SERVICE ROLES │ IDENTITY ROLES  │ POSTURE CHECK ROLES │
├────────────────────────┼─────────────┼──────────┼───────────────┼─────────────────┼─────────────────────┤
│ 3wATDMvDv1LBRlNrYgsrjf │ t2tssh.bind │ AllOf    │ @t2tssh       │ @egress-tunnel  │                     │
│ VKIyQz9ZWf0euSDRikNh0  │ t2tssh.dial │ AllOf    │ @t2tssh       │ @ingress-tunnel │                     │
╰────────────────────────┴─────────────┴──────────┴───────────────┴─────────────────┴─────────────────────╯
results: 1-2 of 2
```
You should also make sure the policy advisor display correctly:
```
# ziti edge policy-advisor services |grep t2tssh
OKAY : egress-tunnel (2) -> t2tssh (2) Common Routers: (2/2) Dial: N Bind: Y
OKAY : ingress-tunnel (2) -> t2tssh (2) Common Routers: (2/2) Dial: Y Bind: N
```
Make sure there is a "Dial" line and a "Bind" line. They are both "OKAY" and has at least 1 Common Routers.

### 3.4.6 Verify the connection
Login to the intercept side tunneler (**ingress-tunnel**) node, you should be able to ssh to the server (**egress-tunnel**) by using dns name "t2tssh.ziti"
```
root@ingress-tunnel:~# ssh t2tssh.ziti
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-67-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon May 15 19:30:46 UTC 2023

  System load:  0.0               Users logged in:       1
  Usage of /:   3.3% of 48.27GB   IPv4 address for eth0: 104.131.9.28
  Memory usage: 11%               IPv4 address for eth0: 10.17.0.7
  Swap usage:   0%                IPv4 address for eth1: 10.108.0.4
  Processes:    93                IPv4 address for tun0: 100.64.0.1

 * Introducing Expanded Security Maintenance for Applications.
   Receive updates to over 25,000 software packages with your
   Ubuntu Pro subscription. Free for personal use.

     https://ubuntu.com/pro

Expanded Security Maintenance for Applications is not enabled.

17 updates can be applied immediately.
13 of these updates are standard security updates.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Mon May 15 19:08:51 2023 from 45.17.199.35
root@egress-tunnel:~# <ctrl-d>
logout
Connection to t2tssh.ziti closed.
root@ingress-tunnel:~#
```

## 3.5 Setup Tunnel to ERT http connection
Edge Router Tunnel (ERT) has combine router and tunneler function. In this section, we will demonstrate a connection between a Ziti-Edge-Tunnel (egress-tunnel) to a ERT (local-er)

The procedure is similar to tunnel to tunnel service, so please refer to that section for detail explanation of each step.

Please refer to [Network Diagram 2](#312-network-diagram-2) for our test setup.

### 3.5.1 Create a host.v1 config
#### 3.5.1.1 ZAC
![Diagram](/img/public_cloud/Services20.png)
#### 3.5.1.2 CLI
```bash
ziti edge create config t2ehostconf host.v1 '{"protocol":"tcp", "address":"127.0.0.1", "port":8080}'
```
### 3.5.2 Create an intercept.v1 config 
Use ip (10.124.0.2) as intercept address
#### 3.5.2.1 ZAC
![Diagram](/img/public_cloud/Services21.png)

And you should have two configs:

![Diagram](/img/public_cloud/Services22.png)
#### 3.5.2.2 CLI
```bash
ziti edge create config t2eintconf intercept.v1 '{"protocols": ["tcp"], "addresses": ["10.124.0.2"], "portRanges": [{"low": 80, "high": 80}]}'
```
```
# ziti edge list configs |grep t2e
│ IlgnlM2srnU7s8C3hiLJA  │ t2eintconf  │ intercept.v1 │
│ uJUtyXI5XH1wSsSCiCARp  │ t2ehostconf │ host.v1      │
```
### 3.5.3 Create Service
Now we need to put these two configs into a service. We going to name the service "t2ehttp":
#### 3.5.3.1 ZAC
![Diagram](/img/public_cloud/Services23.png)
#### 3.5.3.2 CLI
```
ziti edge create service t2ehttp -c t2eintconf,t2ehostconf
```
**Check Service**
```
# ziti edge list services |grep t2e
│ 5FI8Aw0IQ7xaUMgH2rKvps │ t2ehttp │ true       │ smartrouting        │            │
```
### 3.5.4 Create Bind Service policy
#### 3.5.4.1 ZAC
![Diagram](/img/public_cloud/Services25-Bind.jpg)
#### 3.5.4.2 CLI
```bash
ziti edge create service-policy t2ehttp.bind Bind --service-roles '@t2ehttp' --identity-roles "@local-er"
```
### 3.5.5 Create Dial Service policy
Now we need to specify the intercept side tunneler (**egress-tunnel**) for the service by setting up a dial service policy
#### 3.5.5.1 ZAC
![Diagram](/img/public_cloud/Services26-Dial.jpg)

Check two service polices:

![Diagram](/img/public_cloud/Services27.jpg)
#### 3.5.5.2 CLI
```bash
ziti edge create service-policy t2ehttp.dial Dial --service-roles '@t2ehttp' --identity-roles "@egress-tunnel"
```
Make sure both policies are setup correctly：
```
# ziti edge list service-policies |grep t2e
│ 4XpyRyE6vKo2Rd2gb2x6il │ t2ehttp.dial │ AllOf    │ @t2ehttp      │ @egress-tunnel  │                     │
│ 6bGra4CxFtpe0GmTeACLy  │ t2ehttp.bind │ AllOf    │ @t2ehttp      │ @local-er       │                     │
```
You should also make sure the policy advisor display correctly:
```
# ziti edge policy-advisor services |grep t2ehttp
OKAY : egress-tunnel (2) -> t2ehttp (3) Common Routers: (2/2) Dial: Y Bind: N
OKAY : local-er (3) -> t2ehttp (3) Common Routers: (3/3) Dial: N Bind: Y
```
Make sure there is a "Dial" line and a "Bind" line. They are both "OKAY" and has at least 1 Common Routers.
### 3.5.6 Verify the connection
Login to the router (**local-er**), setup a file to send via http.
```
root@local-er:~# cat >hello.txt
                    ___ ___                  .___
                   /   |   \  ______  _  ____| _/__.__.
  ______   ______ /    ~    \/  _ \ \/ \/ / __ <   |  |  ______   ______
 /_____/  /_____/ \    Y    (  <_> )     / /_/ |\___  | /_____/  /_____/
                   \___|_  / \____/ \/\_/\____ |/ ____|
                         \/                   \/\/

This is hello from local-er.
root@local-er:~# python3 -m http.server 8080
Serving HTTP on 0.0.0.0 port 8080 (http://0.0.0.0:8080/) ...
```

Login to the intercept side tunneler (**egress-tunnel**) node.
```
root@egress-tunnel:~# curl http://10.124.0.2/hello.txt
                    ___ ___                  .___
                   /   |   \  ______  _  ____| _/__.__.
  ______   ______ /    ~    \/  _ \ \/ \/ / __ <   |  |  ______   ______
 /_____/  /_____/ \    Y    (  <_> )     / /_/ |\___  | /_____/  /_____/
                   \___|_  / \____/ \/\_/\____ |/ ____|
                         \/                   \/\/

This is hello from local-er.
root@egress-tunnel:~#
```

### 3.5.7 Conclusion
In this section, we demonstrated intercepting http (port 80) request to an IP address and forward the request to a remote http server listening to port 8080 via ziti network.


## 3.6 Setup Connection from a non-OpenZiti client

### 3.6.1 Introduction
In this section, we will demonstrate how to setup non-OpenZiti client to use the ziti service. Please refer to [Network Diagram 2](#312-network-diagram-2) for our test setup.

**You need to create a VM (Non-OpenZiti-Client) in the same data center as "local-er" for this test.**

The following conditions need to be met in order for this connection to work correctly:
- The non-OpenZiti client has to be in the same data center as the edge router. 
- The edge router is created with tunneler enabled.

We are also need to do the following to successfully demonstrate the connection:
- Create host and intercept config
- Create service
- Create dial and bind policy
- Setup route on the non-OpenZiti client

We will create an intercept at **11.11.11.11:80** and **e2thttp.ziti**, and drop off at loopback address (127.0.0.1) of **egress-tunnel** port (80).

### 3.6.2 Create a host.v1 config
Used address **127.0.0.1** as host side destination, and port **80** as destination port.
#### 3.6.2.1 ZAC
![Diagram](/img/public_cloud/Services30.jpg)
#### 3.6.2.2 CLI
```bash
ziti edge create config e2thostconf host.v1 '{"protocol":"tcp", "address":"127.0.0.1", "port":80}'
```
### 3.6.3 Create an intercept.v1 config 
Use a pseudo ip (11.11.11.11) and DNS name (e2thttp.ziti) as intercept address
#### 3.6.3.1 ZAC
![Diagram](/img/public_cloud/Services31.jpg)

And you should have two configs:

![Diagram](/img/public_cloud/Services32.jpg)
#### 3.6.3.2 CLI
```bash
ziti edge create config e2tintconf intercept.v1 '{"protocols": ["tcp"], "addresses": ["11.11.11.11","e2thttp.ziti"], "portRanges": [{"low": 80, "high": 80}]}'
```
```
# ziti edge list configs |grep e2t
│ 1ANNy88ovJL6vAW6AwNbiM │ e2thostconf │ host.v1      │
│ 5kXnoEoMrfReOou8lty9zj │ e2tintconf  │ intercept.v1 │
```
### 3.6.4 Create Service
Now we need to put these two configs into a service. We going to name the service "t2ehttp":
#### 3.6.4.1 ZAC
![Diagram](/img/public_cloud/Services33.jpg)
#### 3.6.4.2 CLI
```
ziti edge create service e2thttp -c e2thostconf,e2tintconf
```
**Check Service**
```
# ziti edge list services  |grep e2t
│ 2uphDaBfIo7ubj6GhV8r93 │ e2thttp │ true       │ smartrouting        │            │
```
### 3.6.5 Create Bind Service policy
#### 3.6.5.1 ZAC
![Diagram](/img/public_cloud/Services34-Bind.jpg)
#### 3.6.5.2 CLI
```bash
ziti edge create service-policy e2thttp.bind Bind --service-roles '@e2thttp' --identity-roles "@egress-tunnel"
```
### 3.6.6 Create Dial Service policy
Now we need to specify the intercept side tunneler (**local-er**) for the service by setting up a dial service policy
#### 3.6.6.1 ZAC
![Diagram](/img/public_cloud/Services35-Dial.jpg)

Check two service polices:

![Diagram](/img/public_cloud/Services36.jpg)
#### 3.6.6.2 CLI
```bash
ziti edge create service-policy e2thttp.dial Dial --service-roles '@e2thttp' --identity-roles "@local-er"
```
Make sure both policies are setup correctly：
```
# ziti edge list service-policies |grep e2t
│ 305novDIduhXPEmA8gawpM │ e2thttp.dial │ AllOf    │ @e2thttp      │ @local-er       │                     │
│ 5zfoMaXKNDe3uIih8YHEWa │ e2thttp.bind │ AllOf    │ @e2thttp      │ @egress-tunnel  │                     │
```
You should also make sure the policy advisor display correctly:
```
# ziti edge policy-advisor services |grep e2thttp
OKAY : egress-tunnel (2) -> e2thttp (3) Common Routers: (2/2) Dial: N Bind: Y
OKAY : local-er (3) -> e2thttp (3) Common Routers: (3/3) Dial: Y Bind: N
```
Make sure there is a "Dial" line and a "Bind" line. They are both "OKAY" and has at least 1 Common Routers.
### 3.6.7 Verify the connection
Login to the Client (**egress-tunnel**), setup a file to send via http.
```
root@egress-tunnel:~# cat >hello.txt
              _   _      _ _
             | | | | ___| | | ___
  _____ _____| |_| |/ _ \ | |/ _ \ _____ _____
 |_____|_____|  _  |  __/ | | (_) |_____|_____|
             |_| |_|\___|_|_|\___/


You have reached the "egress-tunnel".
<CTRL-D>
root@egress-tunnel:~# python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
```


Login to the non-OpenZiti client machine (**Non-OpenZiti-Client**).

#### 3.6.7.1 Test IP intercept
**setup the route first**. The route is via our ER in the same DC (10.124.0.2)
```
root@Non-OpenZiti-Client:~# ip route add 11.11.11.11/32 via 10.124.0.2
```

Now test the connection
```
root@Non-OpenZiti-Client:~# curl http://11.11.11.11/hello.txt
              _   _      _ _
             | | | | ___| | | ___
  _____ _____| |_| |/ _ \ | |/ _ \ _____ _____
 |_____|_____|  _  |  __/ | | (_) |_____|_____|
             |_| |_|\___|_|_|\___/


You have reached the "egress-tunnel".
Bye.
root@Non-OpenZiti-Client:~#
```

#### 3.6.7.2 Modify the resolver
The **Non-OpenZiti-Client**'s resolver has to point to the local-er.  So it can resolve the DNS name from local-er.

<Tabs
  defaultValue="DigitalOcean"
  values={[
      { label: 'Digital Ocean', value: 'DigitalOcean', },
      { label: 'Azure', value: 'Azure', },
      { label: 'Google Cloud', value: 'GCP', },
  ]}
>
<TabItem value="DigitalOcean">

Modify "/etc/systemd/resolved.conf.d/DigitalOcean.conf" to point to the local IP of the "local-er".
```
root@Non-OpenZiti-Client:~# cat /etc/systemd/resolved.conf.d/DigitalOcean.conf
[Resolve]
DNS=144.126.220.15
```

Restart the systemd-resolved service 
```bash
systemctl restart systemd-resolved.service
```

</TabItem>
<TabItem value="Azure">

**Coming Soon**
</TabItem>
<TabItem value="GCP">

**Coming Soon**
</TabItem>
</Tabs>

#### 3.6.7.3 Test DNS intercept
**setup the route first**. The route is via our ER in the same DC (10.124.0.2). The DNS is going to resolve to 100.64.0.0/10 address.
```
root@Non-OpenZiti-Client:~# ip route add 100.64.0.0/10 via 10.124.0.2
```

Now test the connection
```
root@Non-OpenZiti-Client:~# curl http://e2thttp.ziti/hello.txt
              _   _      _ _
             | | | | ___| | | ___
  _____ _____| |_| |/ _ \ | |/ _ \ _____ _____
 |_____|_____|  _  |  __/ | | (_) |_____|_____|
             |_| |_|\___|_|_|\___/


You have reached the "egress-tunnel".
Bye.
root@Non-OpenZiti-Client:~# 
```

