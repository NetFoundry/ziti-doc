---
title: Change Password
---

import CliLogin from '../../../../_cli-login.md'
import CliChangeUpdb from '../../../../_cli-change-password.md'

Follow these instructions to change your quickstart admin's password. A random password was generated for you when you ran `expressInstall` and saved in your *.env file as `ZITI_PWD`. After changing the password, also change the value of `ZITI_PWD` in `~/.ziti/quickstart/$(hostname -s)/$(hostname -s).env` to match. This variable is used by the `zitiLogin` function.

## Use the `ziti` CLI {#ziti-cli}

1. Get logged in
    <CliLogin/>
1. <CliChangeUpdb/>

## Use the Ziti Console {#ziti-console}

If you installed the Ziti Console (ZAC) in your quickstart network then you can [login with your current password](../../../quickstarts/zac/index.md#login-and-use-zac) and change it.

Click on the person icon on the lower left and then select "Edit Profile" as shown to change your password.

![change password screenshot](../../../quickstarts/zac/zac_change_pwd.png)
