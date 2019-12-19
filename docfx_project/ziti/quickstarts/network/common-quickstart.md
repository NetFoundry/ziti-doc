### Obtain and Change the Default Password

When first launched - the instace will deposit a file into the file system at
~/.config/ziti/ziti-controller/credentials.json.

> [!NOTE]
> Since this is your first Ziti deployment this system is expected to be transient. If the IP address or DNS entry
> changes (such as a system reboot) the image needs to be reconfigured becuase the certificates will no longer be valid.
> This file is used to reconfigure the system in this event and it happens automatically on startup.

Now, ssh to the newly created machine. Once there you can obtain the username and password for your
Ziti Controller by issuing this command:

    jq . ~/.config/ziti/ziti-controller/credentials.json

You can choose to keep this username and password or change it to something easier to remember. If you change the password, please remember to use a strong password which is not easy to guess.

> [!TIP]
> If you change the server password update the credentials.json file with the updated password. This ensures the 
> system can automatically update the certificates in the event of a new IP address or domain name.

# [Change via UI](#tab/change-pwd-ui)

These AMIs will be provided with a self-signed certificate generated during securely during the bootup process. See
[changing pki](~/ziti/manage/pki.md) for more information.

1. Log into the UI using the username (defaults to "admin") and the password obtained in the prior step at https://{ZEDE VM public IPv4}
1. In the lower left corner, click the icon that looks like a person and choose "Edit Profile" <br/>
![image](~/images/changepwd_ui.png) <br/>

1. Enter the current password along with a new/confirmed password and click "Save" <br/>
![image](~/images/changepwd_manageprofile.png) <br/>

# [Change via CLI](#tab/change-pwd-cli)

To change the administrator password using the CLI simply issue these commands:

> [!NOTE]
> You will need to login one time in order to use the ziti cli:

[!include[](~/ziti/cli-snippets/login.md)]
    
    #update the admin user. This command will prompt you to enter the password
    ziti edge controller update authenticator updb -s
    
***

## Create an Identity

All connections to Ziti are mutually authenticated TLS connections. Identites map a given certificate to an identity
within the Ziti Controller. Read more about Identities [here](~/ziti/identities/overview.md) Creating an identity via the UI or CLI is easy:

# [New Identity via UI](#tab/create-identity-ui)

1. On the left side click "Edge Identities"
1. In the top right corner of the screen click the "plus" image to add a new identity
1. Enter the name of the identity you would like to create
1. Choose the type: Device, Service, User (choose User for now)
1. Leave the enrollment type as "One Time Token"
1. Click save

# [New Identity via CLI](#tab/create-identity-cli)

To create a new identity using the CLI simply issue these commands:

[!include[](~/ziti/identities/create-identity-cli.md)]

***

### Enroll the New Identity

Identities are not truly enabled until they are enrolled. Enrollment is a complex process. NetFoundy has created a tool
specifically for this task to ensure safe and secure enrollment of identities.  

1. Download the enroller for your operating system.

[!include[](~/ziti/downloads/enroller.md)]

1. Download the [jwt](https://jwt.io/introduction/) from the UI by clicking the icon that looks like a certificate (save
   the file as NewUser.jwt) or if you used the CLI from the output location specified when creating the user.
1. In a command line editor, change to the folder containing the jwt. Enroll the identity by running `ziti-enroller --jwt NewUser.jwt`

The ziti-enroller will output a new json file named `NewUser.json`. This file is precious and must be protected as it
contains the identity of the given user.

## Create a Service

With an identity created it's now time to create a service. Read more about Services [here](~/ziti/services/overview.md).  For this
example we are going to choose a simple website that is [available on the open internet](http://eth0.me). This site will
return the IP address you are coming from. Click this link now and discover what the your external IP is.

# [New Service via UI](#tab/create-service-ui)

1. On the left side nav bar, click "Edge Services"
1. In the top right corner of the screen click the "plus" image to add a new service
1. Choose a name for the serivce. Enter "ethzero-ui"
1. Enter a host name for the service. Enter "ethzero.ziti.ui"
1. Enter port 80
1. Choose Router "ziti-gw01"
1. For Endpoint Service choose:
    * protocol = tcp
    * host = eth0.me
    * port = 80
1. Select "demo-c01" for the cluster
1. Leave Hosting Identities as is
1. Click save

# [New Service via CLI](#tab/create-service-cli)

To create a new service using the CLI simply issue these two commands:

    #load the default cluster id into an environment variable
    cluster=$(ziti edge controller list clusters | tr -s ' ' | cut -d ' ' -f4)

    #load the edge router id into an environment variable
    edgeRouter=$(ziti edge controller list gateways | cut -d ' ' -f2)

    #update the admin user. This command will prompt you to enter the password
    ziti edge controller create service ethzero-cli "ethzero.ziti.cli" "80" "$edgeRouter" "tcp:eth0.me:80" -c "$cluster"

***

## Create an AppWAN

AppWANs are used to to authorize identities to services and allow you to choose the terminating node for traffic
destined to your service. [Read more about AppWAN here](~/ziti/appwans.md)

# [New AppWAN via UI](#tab/create-appwan-ui)

1. On the left side nav bar, click "AppWANs"
1. In the top right corner of the screen click the "plus" image to add a new AppWAN
1. Choose a name for the AppWAN. Enter "my-first-appwan"
1. Choose the service(s) you want to add to the AppWAN. Make sure you pick ethzero-ui
1. Choose the identity you created before (NewUser)
1. Click save

# [New AppWAN via CLI](#tab/create-appwan-cli)

[To create an AppWAN using the CLI issue the following commands:

    #load the identity's id into an environment variable
    identity=$(ziti edge controller list identities | grep NewUser | cut -d " " -f2)

    #load the service id into an environment variable
    service=$(ziti edge controller list services | grep ethzero-cli | cut -d " " -f2)

    #update the admin user. This command will prompt you to enter the password
    ziti edge controller create app-wan my-first-cli-appwan -i $identity -s $service]

***

## Test It

Ok, you're almost ready to test your Ziti setup! Now you need to acquire a pre-built client from NetFoundry. The
simplest way to test your setup is to get the [ziti-tunnel](~/ziti/clients/tunneler.md) for your OS.

[!include[](~/ziti/downloads/tunneler.md)]

The
ziti-tunnel has a mode which acts as a proxy into the Ziti overlay network.  You will need the enrolled identity json
file created in the previous step and this will require running a command. Here are the steps to verify your Ziti
network and configuration are all working properly:

* Open a command prompt
* ensure ziti-tunnel and NewUser.json are in the same directory and cd to this directory
* run the ziti-tunnel in proxy mode:
  * `ziti-tunnel proxy -i NewUser.json ethzero-ui:1111`
  * `ziti-tunnel proxy -i NewUser.json ethzero-cli:2222`
* navigate your web browser to (or use curl) to obtain your IP address by going to http://localhost:1111/

At this point you should see the external IP address of your instance. Delivered to your machine safely and
securely over your Ziti network.
