# docker-centos - Docker base images for CentOS

# ABOUT

docker-centos is a collection of [chroot](http://man.cx/chroot) + [rpm](http://man.cx/rpm)-generated CentOS base images.

# DOCKER HUB

https://registry.hub.docker.com/u/mcandre/docker-centos/

# EXAMPLE

```
$ make
...
docker run --rm mcandre/docker-centos:2.1 sh -c 'yum -y install ruby && ruby -v'
rpmdb: /var/lib/rpm/Packages: unsupported hash version: 8
error: cannot open Packages index using db3 - Invalid argument (22)
Traceback (innermost last):
  File "/usr/bin/yum", line 44, in ?
    yummain.main(sys.argv[1:])
  File "yummain.py", line 101, in main
  File "yummain.py", line 58, in parseCmdArgs
  File "config.py", line 120, in __init__
  File "config.py", line 169, in _getsysver
  File "clientStuff.py", line 164, in openrpmdb
NameError: RpmError
make: *** [run] Error 1
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
