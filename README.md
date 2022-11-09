# grid3_mastodon

get Mastodon up and running in on grid3 VM

## what in this image

- [Mastodon](https://mastodon.social/explore) on Ubuntu 20.04
- include preinstalled openssh-client, openssh-server, curl, wget, docker and docker-compose.
- ufw with restricted rules applied.
- zinit process manager which is configured with these services:
  - sshd: starting OpenSSH server daemon
  - contained: starting containerd daemon, which manages the complete docker containers lifecycle.
  - dockerd: starting the Docker daemon.
  - mastodon: Define different mastodon services/containers, and spin everything up.
  - sshd-init: Add the user SSH key to authorized_keys, so he can log in remotely to the host which running this image.
  - ufw-init: define restricted firewall/iptables rules.
  - ufw: apply the pre-defined firewall rules.
  - config: To set all requirements inside an .env file such as a required to deploy instance from mastodon.

## Build & Run

in the grid3_mastodon directory

`docker build -t {user|org}/grid3_mastodon_docker:latest .`
`docker run -v /var/lib/docker --rm -ti --name mastodon --privileged {user|org}/grid3_mastodon_docker:<tag>`

## Deploying on grid 3

### convert the docker image to Zero-OS flist

Easiest way to convert the docker image to Flist is using [Docker Hub Converter tool](https://hub.grid.tf/docker-convert), make sure you already built and pushed the docker image to docker hub before using this tool.

### Deploying

Easiest way to deploy a VM using the flist is to head to to our [playground](https://play.grid.tf) and deploy a Virtual Machine by providing this flist URL.

- make sure to provide the correct entrypoint, and required env vars.
- another important perquisite is to have a disk mounted on `/var/lib/docker`. make sure its size is big enough to fit both the images for mastodon, and the volumes which will store all the db and the media files, etc.

or use the dedicated Mastodon weblet if available, which will deploy an instance that satisfies the above perquisites.

another way you could use is using our terraform plugin [docs](https://github.com/threefoldtech/terraform-provider-grid)

here you can find a full terraform file example to deploy this flist on grid3 [link](https://github.com/threefoldtech/terraform-provider-grid/blob/development/examples/resources/mastodon/main.tf)

## Flist

### URL

TODO: should be updated to official repo.

```
https://hub.grid.tf/samehabouelsaad.3bot/abouelsaad-grid3_mastodon_docker-latest.flist
```

### Entrypoint

- `/sbin/zinit init`

### Required Env Vars

- `SSH_KEY`: User SSH public key.
- `LOCAL_DOMAIN`: the domain name, eg: grid3mastodon.gent01.dev.grid.tf

#### smtp server settings

caution: configure smtp settings bellow **only If** you have an working smtp service and you know what you’re doing.
otherwise don't set thoses or leave these settings empty. set wrong smtp settings will cause **issues/server errors in mastodon**.

- `SMTP_SERVER`: eg, "smtp.gmail.com".
- `SMTP_PORT`: eg, smtp server port.
- `SMTP_AUTH_METHOD`: The SMTP authentication method, eg, plain or none.
- `SMTP_LOGIN`: The email that mastodon can use to login.
- `SMTP_PASSWORD`: The password of the email.
- `SMTP_FROM_ADDRESS`: Same of `SMTP_LOGIN`.
- `SMTP_AUTH_METHOD`: The authantication method e.g. `plain`.

