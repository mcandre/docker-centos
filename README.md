# docker-centos - Docker base images for CentOS

# ABOUT

docker-centos is a collection of [chroot](http://man.cx/chroot) + [rpm](http://man.cx/rpm)-generated CentOS base images.

# DOCKER HUB

https://registry.hub.docker.com/u/mcandre/docker-centos/

# EXAMPLE

```
$ make
Failed:
  initscripts.x86_64 0:9.49.24-1.el7                                                         iputils.x86_64 0:20121221-6.el7                                                         systemd.x86_64 0:208-20.el7_1.3

Complete!
make: *** [rootfs.tar.gz] Error 1
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
* [boot2docker](http://boot2docker.io/)

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
