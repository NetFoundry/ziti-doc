---
sidebar_position: 20
sidebar_label: Controller
title: Controller Config 
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';

# 1.0 Configure the controller
## 1.1 Create a VM to be used as the Controller

<Tabs
  defaultValue="Azure"
  values={[
      { label: 'Azure', value: 'Azure', },
      { label: 'AWS', value: 'AWS', },
      { label: 'Google', value: 'GCP', },
      { label: 'Digital Ocean', value: 'DigitalOcean', },
      { label: 'Oracle', value: 'OCI', },
      { label: 'IBM', value: 'IBM', },
  ]}
>
<TabItem value="Azure">

- It is easier to use **resource group** to organize and manage all your resources for this demo.
- Create a **resource group** and change into that resource group.
- Use **+ Create** button to create a resource.
- Azure will take you to the **Marketplace** screen. In the search bar, type in **Ubuntu Server**.
- Choose "**Ubuntu Server 22.04 LTS**".

![Diagram](/img/public_cloud/Create-Azure1.jpg)

On the **Create a virtual machine** screen.
- The **Subscription** and **Resource group** should already be filled. 
- In the **Instance details** section, enter the **VM name**.
- Select the **Region** to host your VM.
- Leave default **Availability options** and **Security type**(Standard).
- Leave the selected image **Ubuntu Server 22.04 LTS x64 Gen2**.
- For the Size, choose the appropriate size for your application.  For this demo, **Standard_B2s(2CPU,4 GB)** size was used.

![Diagram](/img/public_cloud/Create-Azure2.jpg)

- Next, choose **Authentication type** to login to the VM. (We highly **discourage** login to the VM using Password). 
- Enter an username (**remember the username, you will need it to login to the VM**), or leave the default user **azureuser**
- Choose your ssh key
- For **inbound ports**, select the ssh. You can add extra port based on your OpenZiti setup. 
- You can leave everything default.
Press **Review + create**
![Diagram](/img/public_cloud/Create-Azure4.jpg)

- After the Validation passed. Press **Create** to create VM.
![Diagram](/img/public_cloud/Create-Azure5.jpg)

- **Important:** If you are creating the network controller, you need to associate an DNS name to the public IP of your VM.
- You can do this from "Virtual machine" page.
![Diagram](/img/public_cloud/Create-Azure6.jpg)

</TabItem>
<TabItem value="AWS">

- login to the **AWS console**. 
- go to the **EC2 dashboard**. 
- Click on the **Instances**. 
- **Launch the instances**

![Diagram](/img/public_cloud/Create-AWS1.jpg)

- Fill the **Name** of your instance.
![Diagram](/img/public_cloud/Create-AWS2.jpg)

- On the Quick start select **Ubuntu**. 
- Select the **Ubuntu Server 22.04 LTS**.
- Leave the Architecture as **64-bit (x86)**
- Select the instance type **t2.medium**

![Diagram](/img/public_cloud/Create-AWS3.jpg)

- In the **Key pair (login.)** section, choose the key name which you already created.
- In the **Network settings** section, choose the VPC for your VM.
- Select the subnet.
- Select **Enable** for **Auto assign public IP**

![Diagram](/img/public_cloud/Create-AWS4.jpg)

- Click on ** Create security group** to allow traffic into your VM.
- Name the security group.
- Create the Firewall rule based on controller and ER. 
- For controller. allow the TCP port 8440-8443 (default ports from quickstart) along with SSH. 
- For ER we have to allow TCP port 80, 443 and SSH,

**SG For the controller.**
![Diagram](/img/public_cloud/Firewall-AWS-Controller.jpg)

**SG for the ER**
![Diagram](/img/public_cloud/Firewall-AWS-ER.jpg)

- Under **Configure storage** section, choose at least **20** GiB storage space.

Now click on **Launch instance**

</TabItem>
<TabItem value="GCP">

- Login to the GCP console. 
- Go to **COMPUTE ENGINE** dashboard. 
- Click on **CREATE INSTANCE**.
![Diagram](/img/public_cloud/Create-GCP1.jpg)

- Configure the VM as follow:
- **Name** of the VM
- **Region** and **Zone**
- Choose **e2-medium** for **Machine type** 
![Diagram](/img/public_cloud/Create-GCP4.jpg)

- Hit **CHANGE** at the "Boot disk** section to change the OS image.
- On the "Boot disk" page, Choose **PUBLIC IMAGES**
- Choose **Ubuntu** as the Operating system
- Select **Ubuntu 22.04 LTS, x86** Version. 
- Hit **SELECT** to complete the selection.
![Diagram](/img/public_cloud/Create-GCP5.jpg)

- Open **Advanced Options**, and then open **Networking**
- **Highly recommended:** assign a Network tags.  This will help you configuring the firewalls later.
- **For local GW VM**, **Enable** IP forwarding at this time. You will not be able to change this setting from the console after the VM is created.
![Diagram](/img/public_cloud/Create-GCP6.jpg)

- **Optional** you can reserve static external IP ADDRESS under **Networking/Network interfaces** section. Reserving static IP is useful for the Network controller in case you have to shut down the VM.
![Diagram](/img/public_cloud/Create-GCP7.jpg)

- Now click on **CREATE** to create the virtual machine.

</TabItem>
<TabItem value="DigitalOcean">

- Login to the Digital Ocean console, create a **Droplets** from the dropdown menu on the upper right hand side.

![Diagram](/img/public_cloud/Create1.jpg)

- On the "Create Droplets" screen, Choose "**Ubuntu**", version "**22.04**".
- For the Size, choose the appropriate size for your application.  For this guide, a smaller size was used.
![Diagram](/img/public_cloud/Create2.jpg)

- Next, choose a ssh-key to login to the VM. (We highly discourage login to the VM using Password),
- then **Create Droplet**
![Diagram](/img/public_cloud/Create3.jpg)

</TabItem>
<TabItem value="OCI">

- Login to the **ORACLE Cloud** console. 
- Go to Home dashboard.
- Click on **Instances** (Under **Compute** category). 
- Create an instance.
- Name the instance. 
- Choose the compartment.
- Select the Availability domain under Placement.
- Leave the security disabled

![Diagram](/img/public_cloud/Create-OCI1.jpg)

- Under the "Image and shape selection", click **Change image** icon.
- Select the **Ubuntu** icon. 
- Select the **Canonical Ubuntu 22.04**. 
- Select any image build. And press **Select image**
- Under the "Shape" selection, Choose **Change shape**. 
- Change to **2** OCUPs and **4** GB memory.

![Diagram](/img/public_cloud/Create-OCI2.jpg)

- On the networking section.
- Select your **Primary network** and **Subnet**.
- For **Public IPv4 address**, check **Assign a public IPv4 address**.

![Diagram](/img/public_cloud/Create-OCI3.jpg)

- In the **Add SSH keys** section, choose how you want your ssh keys generated. **We strongly discourage use password to login to the VM**.
- Leave default boot volume.
- Now click on **Create**.

![Diagram](/img/public_cloud/Create-OCI4.jpg)

</TabItem>
<TabItem value="IBM">

- Login to the IBM cloud.
- Go to dashboard.
- Click on **Create resource  +** on the top right
- Filter on "Compute" on the Category (on the left)
- Choose **Virtual Server for Classic**.

![Diagram](/img/public_cloud/Create-IBM1.jpg)

- Leave the "Type of virtual server" as **Public**. 
- Give it your **Hostname**.

![Diagram](/img/public_cloud/Create-IBM2.jpg)

- Select the location. 
- Select the profile, the size of **B1.2x4** is adequate for our exercise.
- Choose the SSH key.
- On the "Operating system" select the **Ubuntu**. Select the version **22.04**

![Diagram](/img/public_cloud/Create-IBM3.jpg)


- Leave everything else default except **Add-ons**, turn the **Firewall** features on.

![Diagram](/img/public_cloud/Create-IBM4.jpg)

- Alternative, you can select **allow_all** under the "Public security group", and leave the Add-on Firewall feature off.  **This is not recommended as it opens your VM for attacks**.
- Press **Create** on the right side menu to create the VM.

</TabItem>
</Tabs>

## 1.2 Firewall

<Tabs
  defaultValue="Azure"
  values={[
      { label: 'Azure', value: 'Azure', },
      { label: 'AWS', value: 'AWS', },      
      { label: 'Google', value: 'GCP', },
      { label: 'Digital Ocean', value: 'DigitalOcean', },
      { label: 'Oracle', value: 'OCI', },
      { label: 'IBM', value: 'IBM', },
  ]}
>
<TabItem value="Azure">

- Azure's firewall is blocking all incoming access to the VM. You will need to open ports you specified for controller and ZAC (if you plan to use ZAC). Here is a example of the firewall ports if you used the default ports (TCP 8440-8443).
![Diagram](/img/public_cloud/Controller-Firewall-Azure.jpg)

</TabItem>
<TabItem value="AWS">

- The steps in the create VM section already specified the ports need to be opened on the AWS firewall.
- You can double check if the required ports are open. Here is a example of the firewall ports if you used the default ports(TCP 8440-8443).
![Diagram](/img/public_cloud/Firewall-AWS-Controller.jpg)

</TabItem>

<TabItem value="GCP">

- GCP’s default firewall is blocking all incoming access to the VM. You will need to open ports you specified for controller and ZAC (if you plan to use ZAC). Here is a example of the firewall ports if you used the default ports.
- Go to your VM screen, click on the **Network interfaces** name (i.e. nic0)
- Click on **Firewall** menu on the left side to bring up the firewall screen
- On the firewall screen, click on **+ CREATE FIREWALL RULE** to create new rules
- Give a meaningful **name** to your firewall rule
- Choose your **Network**
- Leave Direction of traffic as **Ingress**
- Action **Allow**
- Targets, you can use "All instances in the network" (if you did not specify "Network tags" for your VM). In this example, we are using **Specified target tags** option.
- Enter **Target tags** for your VM. In this example, our tag is **nc**
- Enter Source IPv4 ranges: **0.0.0.0/0**
- For the controller we have to allow the **TCP** port **8440-8443** along with SSH port (**22**).
Hit **CREAETE** to create rules.
![Diagram](/img/public_cloud/Controller-Firewall-GCP.jpg)

- The firewall rule also shows up on your "Network interface details" screen.
- From your VM screen, click on the **Network interfaces** name (i.e. nic0)
![Diagram](/img/public_cloud/Controller-Firewall-GCP2.jpg)

</TabItem>
<TabItem value="DigitalOcean">

DigitalOcean by default does not setup firewall for the VM.
</TabItem>
<TabItem value="OCI">

---

Oracle cloud by default blocks all incoming traffic to the VM. You will need to open ports you specified for controller and ZAC (if you plan to use ZAC). 

- First, we need to **Create security group**
- From the **Networking** category, select the **Virtual cloud networks**. 
- Select the VCN your VM is in.
- On the left side menu, select the **Network Security Group**.
- Select **Create Network Security Group**.
- Name the security group and select the next.
- Now create rules for ingress traffic. 
- Port 22/TCP for SSH
- OpenZiti ports: 8440-8443/TCP (default ports from quickstart)
- Also create a rule to allow all traffic outbound (**Egress**).

Following is the example of the Security Group for the controller

![Diagram](/img/public_cloud/Firewall-OCI1.jpg)

- After the security group is created, attach it to the instance.
- From the "Instance details" screen, select **Edit** under the **Network security groups** section.
- Select the security group from the drop down and press **Save changes**.

![Diagram](/img/public_cloud/Firewall-OCI2.jpg)


---
**NOTE 1**
```
Oracle Cloud also uses Security Lists (on the subnet) to marshal the traffic, 
please make sure the setting under Security Lists is not conflicting
with your security group rules.
```

---
**NOTE 2**
```
It is possible that after the security group configuration, the ufw does not
work correctly on the VM.
```

You should **Turn on ufw** and **restart the VM** after the security group configuration.

- ufw must be turned on for traffic to get to the VM.
- after ufw is enabled, setup **allow** traffic for OpenZiti ports:

```
sudo ufw enable
sudo ufw allow 8440:8443/tcp
sudo shutdown -r 0
```


</TabItem>
<TabItem value="IBM">

If you turn on the firewall feature, you will need to config firewall rules. 

- Open the Instance detail screen
- Find the **Firewall details** at the bottom right. Open it.

Add the following rules.
- ssh: port 22/TCP
- OpenZiti ports: 8440-8443/TCP (default ports from quickstart)
- Deny rules to deny all other traffic

Make sure the firewall is active, it should display **Processing all rules** if it is active.

![Diagram](/img/public_cloud/Firewall-IBM-controller.jpg)

</TabItem>
</Tabs>

## 1.3 Login and Setup Controller
<Tabs
  defaultValue="Azure"
  values={[
      { label: 'Azure', value: 'Azure', },
      { label: 'AWS', value: 'AWS', },
      { label: 'Google', value: 'GCP', },
      { label: 'Digital Ocean', value: 'DigitalOcean', },
      { label: 'Oracle', value: 'OCI', },
      { label: 'IBM', value: 'IBM', },
  ]}
>
<TabItem value="Azure">

- Once the VM is created, we can get the IP address (and the DNS name) of the VM from the Virtual machine screen.
- Login to the VM by using defined user "username" (default username is azureuser) and the private sshkey:
```
ssh -i <private_key> <username>@<ip>
or
ssh -i <private_key> <username>@<dns-name>
```

Use the DNS name to setup the controller with [Host OpenZiti Anywhere](/docs/learn/quickstarts/network/hosted/). 

</TabItem>
<TabItem value="AWS">

- Once the VM is created, we can get the IP address (and the DNS name) of the VM from the Instance detail screen.
- **NOTE:** DNS name is only available if you enabled **DNS Hostnames** under VPC.
- Login to the VM by using user name "ubuntu":
```
ssh -i <private_key> ubuntu@<ip>
or
ssh -i <private_key> ubuntu@<dns-name>
```
- export the DNS record 
```
export EXTERNAL_DNS=$(dig +short -x $(curl -s icanhazip.com) | sed "s/.$//")
```
Then follow the [Host OpenZiti Anywhere](/docs/learn/quickstarts/network/hosted/#express-install) guide to setup the controller.

</TabItem>
<TabItem value="GCP">

- Once the VM is created, we can login through **SSH** button on the VM instances screen.
![Diagram](/img/public_cloud/GCP-login1.jpg)

- export the DNS record 
```
export EXTERNAL_DNS=$(dig +short -x $(curl -s icanhazip.com) | sed "s/.$//")
```
Then follow the [Host OpenZiti Anywhere](/docs/learn/quickstarts/network/hosted/#express-install) guide to setup the controller.

</TabItem>
<TabItem value="DigitalOcean">

- Once the VM is created, we can get the IP address of the droplet from the Resources screen.
- Login to the VM by using user "root" and IP address:
```
ssh root@<ip>
```
Then follow the [Host OpenZiti Anywhere](/docs/learn/quickstarts/network/hosted/) to setup the controller. You must replace the EXTERNAL_DNS with the following command before running the quickstart.

- **export EXTERNAL_DNS="$(curl -s eth0.me)"**

This ensures the Controller setup by the quickstart is advertising the external IP address of the VM.
</TabItem>
<TabItem value="OCI">

- Once the VM is created, we can get the IP address of the VM from the instance details screen.
- Login to the VM by using user name "ubuntu" and the IP address:
```
ssh -i <private_key> ubuntu@<ip>
```

Then follow the [Host OpenZiti Anywhere](/docs/learn/quickstarts/network/hosted/) to setup the controller. You must replace the EXTERNAL_DNS with the following command before running the quickstart.

- **export EXTERNAL_DNS="$(curl -s eth0.me)"**

This ensures the Controller setup by the quickstart is advertising the external IP address of the VM.
</TabItem>
<TabItem value="IBM">

- Once the VM is created, we can get the IP address of the VM from the Devices screen.
- Login to the VM by using user name "ubuntu" and the IP address:
```
ssh -i <private_key> ubuntu@<ip>
```

- export the DNS record 
```
export EXTERNAL_DNS=$(dig +short -x $(curl -s icanhazip.com) | sed "s/.$//")
```
Then follow the [Host OpenZiti Anywhere](/docs/learn/quickstarts/network/hosted/#express-install) guide to setup the controller.

</TabItem>
</Tabs>

## 1.4 Setup Ziti Administration Console (ZAC) 
**Optional**

ZAC provides GUI for managing the OpenZiti network. If you prefer UI over CLI to manage network, please following the [ZAC Setup Guide](/docs/learn/quickstarts/zac/) to setup ZAC before going to the next section.

**Quickfix:**

---

To setup npm executables, you can follow [install Node.js guide](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-ubuntu-22-04).

For example, this is how to install the version of node needed for ZAC.

Setup the repo:
```
cd ~
curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh
sudo bash nodesource_setup.sh
```

Install nodejs:
```
sudo apt install nodejs
```

After the nodejs is installed, following the rest of [ZAC Setup Guide](/docs/learn/quickstarts/zac/#cloning-from-github) to setup ZAC.

---

## 1.5 Helpers

Following helpers are needed to complete the guides for router and services.

### 1.5.1 Add Environment Variables Back to the Shell
Source the environment variables when you log back in the shell
```
source ~/.ziti/quickstart/$(hostname -s)/$(hostname -s).env
```

If the environment variables are sourced correctly, you can do the following to check:
```
echo $ZITI_HOME
```
**Output:**
```
/root/.ziti/quickstart/OMSINER
```
 
### 1.5.2 Change Ziti edge admin password
Find the Current admin edge login password of controller (if you forget the password):
```
grep "export ZITI_PWD" ~/.ziti/quickstart/$(hostname -s)/$(hostname -s).env
```
Or if you have environment variable setup correctly:
```
echo $ZITI_PWD
```
To update the passwd
```
ziti edge update authenticator updb -s
```
**Important:** if you change the password, you must update the passwd (ZITI_PWD) in the "~/.ziti/quickstart/$(hostname -s)/$(hostname -s).env" file. 

### 1.5.3 Some useful command for the Router
** login the CLI**
```
zitiLogin
```

**Verify ER status**
```
ziti edge list edge-routers
```

**Delete the ER**
```
ziti edge delete edge-routers $ROUTER_NAME
ziti edge delete edge-routers $ROUTER_ID
```

**Update the ER**
```
ziti edge update edge-router $ROUTER_NAME [flags]
ziti edge update edge-router $ROUTER_ID [flags]
```
example to update attributes: 
```
ziti edge update edge-router $ROUTER_NAME -a private
```
