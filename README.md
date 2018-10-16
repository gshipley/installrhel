Install RedHat OKD 3.11 on your development box.

This repository is a set of scripts that will allow you easily install the latest version (3.11) of OKD in a single node fashion.  What that means is that all of the services required for OKD to function (master, node, etcd, etc.) will all be installed on a single host.  The script supports a custom hostname which you can provide using the interactive mode.

## Installation

1. Create a VM as explained in https://www.youtube.com/watch?v=ZkFIozGY0IA (this video) by Grant Shipley

2. Clone this repo

```
git clone https://github.com/gshipley/installcentos.git
```

3. Execute the installation script

```
cd installcentos
./install-openshift.sh
```

## Automation
1. Define mandatory variables for the installation process

```
# Domain name to access the cluster
$ export DOMAIN=<public ip address>.nip.io

# User created after installation
$ export USERNAME=<current user name>

# Password for the user
$ export PASSWORD=password
```

2. Define optional variables for the installation process

```
# Instead of using loopback, setup DeviceMapper on this disk.
# !! All data on the disk will be wiped out !!
$ export DISK="/dev/sda"
```

3. Run the automagic installation script as root with the environment variable in place:

```
curl https://raw.githubusercontent.com/gshipley/installcentos/master/install-openshift.sh | INTERACTIVE=false /bin/bash
```

## Development

For development it's possible to switch the script repo

```
# Change location of source repository
$ export SCRIPT_REPO="https://raw.githubusercontent.com/gshipley/installcentos/master"
$ curl $SCRIPT_REPO/install-openshift.sh | /bin/bash
```

## Testing

The script is tested using the included container and the `validate.sh` script. The SSH key passed to the container needs to be imported into DigitalOcean
as `installcentos` or the `SSH_KEY_NAME` variable needs to be set.

```
make

docker run -ti -e DIGITALOCEAN_ACCESS_TOKEN="<TOKEN>" \
	-v <private key file path>:/root/.ssh/<private key file name> -v <private key file path>.pub:/root/.ssh/<private key file name>.pub \
	quay.io/osevg/installcentos-validate
```
