# docker-centos - Docker base images for CentOS

# ABOUT

docker-centos is a collection of [chroot](http://man.cx/chroot) + [rpm](http://man.cx/rpm)-generated CentOS base images.

# DOCKER HUB

https://registry.hub.docker.com/u/mcandre/docker-centos/

# EXAMPLE

```
$ make
docker run --rm mcandre/docker-centos:7.0.1406 sh -c 'cat /etc/*release*'
CentOS Linux release 7.0.1406 (Core)
NAME="CentOS Linux"
VERSION="7 (Core)"
ID="centos"
ID_LIKE="rhel fedora"
VERSION_ID="7"
PRETTY_NAME="CentOS Linux 7 (Core)"
ANSI_COLOR="0;31"
CPE_NAME="cpe:/o:centos:centos:7"
HOME_URL="https://www.centos.org/"
BUG_REPORT_URL="https://bugs.centos.org/"

CentOS Linux release 7.0.1406 (Core)
CentOS Linux release 7.0.1406 (Core)
cpe:/o:centos:centos:7
```

# REQUIREMENTS

* [Docker](https://www.docker.com/)

## Optional

* [make](http://www.gnu.org/software/make/)

## Debian/Ubuntu

```
$ sudo apt-get install docker.io build-essential
```

## RedHat/Fedora/CentOS

```
$ sudo yum install docker-io
```

## non-Linux

* [VirtualBox](https://www.virtualbox.org/)
* [Vagrant](https://www.vagrantup.com/)
* [boot2docker](http://boot2docker.io/) with devicemapper

### Mac OS X

* [Xcode](http://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12)
* [Homebrew](http://brew.sh/)
* [brew-cask](http://caskroom.io/)

```
$ brew cask install virtualbox vagrant
$ brew install boot2docker
```

### Windows

* [Chocolatey](https://chocolatey.org/)

```
> chocolatey install docker make
```

### Enable Device Mapper

```
$ boot2docker ssh
docker@boot2docker:~$ echo "EXTRA_ARGS='--storage-driver=devicemapper'" | sudo tee -a /var/lib/boot2docker/profile
docker@boot2docker:~$ sudo /etc/init.d/docker restart
```
