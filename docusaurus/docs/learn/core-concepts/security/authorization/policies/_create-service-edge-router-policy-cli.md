import CliLoginMd from '../../../../../_cli-login.md'

To create a Service Edge Router Policy using the CLI issue the following commands.

1. ensure you are logged in with the CLI.

    <CliLoginMd/>

1. Create a service edge router policy which allows all services to use all routers.

    ```bash
    ziti edge create service-edger-router-policy 'my-policy' --service-roles '#all' --edge-router-roles '#all'
    ```