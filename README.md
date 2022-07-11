# Building this Project

## Prerequisite

* [docfx](https://dotnet.github.io/docfx/) needs to be on your path
    * mac/linux requires mono which is easily installed by following [these install steps](https://dotnet.github.io/docfx/tutorial/docfx_getting_started.html)
    * an alias can be made to make docfx use easier `DOCFX_EXE=~/tools/docfx/current/docfx.exe mono $DOCFX_EXE` (or whatever you prefer)
* Linux - Documentation is run routinely by our CI
* Windows - Developed with [Windows Subsytem for Linux (WSL)](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* Doxygen - [Doxygen](http://www.doxygen.nl/) is used to generate the api documentation for the C SDK and is
  necessary to be on the path
* awscli - the swift sdk documentation is currently housed in aws and requires aws access to embed the swift doc.
  the gendoc.sh may fail or the documentation may be incomplete if the swift doc is not obtained

## Building the Doc

Github offers [github pages](https://pages.github.com/) which this project uses to host the output of building the
static content. Github has a few options for where you can put your doc at this time, the main branch, a folder on the
main branch named 'docs' or a special branch that still works named "gh-pages". This project is currently configured
to use the main branch and docs folder.

The best/easiest thing to do in order to build these docs is to have Windows Subsytem for Linux installed or any shell
which can execute a `.sh` script. As of 2020 there's a multitude of ways to get a bash/shell interpreter in windows.
It's not feasible to test all these shells to make sure this script works so it's encouraged that you use a linux-based
flavor of bash. If the script doesn't funtion - open an [issue](./issues) and someone will look into it.

After cloning this repository open the bash shell and execute the [gendoc.sh](https://raw.githubusercontent.com/openziti/ziti-doc/main/gendoc.sh) script. The script has a few
flags to pass that mostly controls the cleanup of what the script does. In general, it's recommended you use the -w flag
so that warngings are treated as errors. 

Expected gendoc.sh usage: `./gendoc.sh -w`

You can then run `docfx serve docs` to serve the html and view it in a browser.

## Sparse Checkout
If you want only the bits required for build, you can do the following

    echo 'path/to/important/dir' >> .git/modules/docfx_project/<SUBPROJECT>/info/sparse-checkout
    cd docfx_project/<SUBPROJECT>/
    git config core.sparseCheckout true
    git checkout


For example

    echo '/quickstart' >> .git/modules/docfx_project/ziti-cmd/info/sparse-checkout
    cd docfx_project/ziti-cmd
    git config core.sparseCheckout true
    git checkout 


## Running CI equivalent locally
CI uses Docker and a bunch of env vars to run. Set the accordingly then issue:

    docker run --rm -it -v $(pwd):/doc \
      -e AWS_ACCESS_KEY_ID=$aws_access_key_id \
      -e AWS_SECRET_ACCESS_KEY=$aws_secret_access_key \
      -e AWS_DEFAULT_REGION=us-east-1 \
      -e GIT_BRANCH=$GIT_BRANCH \
      -e gh_ci_key=$gh_ci_key \
      openziti/doc:latest /bin/sh -c "/doc/publish.sh"


