IMAGE=mcandre/docker-centos:4.7
ROOTFS=rootfs.tar.gz
define GENERATE
setenforce 0; true && \
cp -r /mnt/yum.repos.d /etc && \
yum install -y wget tar && \
mkdir -p /chroot/var/lib/rpm && \
mkdir -p /chroot/var/lock/rpm && \
rpm --root /chroot --initdb && \
wget http://vault.centos.org/4.7/os/x86_64/CentOS/RPMS/centos-release-4-7.x86_64.rpm && \
rpm --root /chroot -ivh --nodeps centos-release*rpm && \
cp -r /mnt/yum.repos.d /chroot/etc && \
mkdir /chroot/proc && \
mkdir /chroot/sys && \
mkdir /chroot/dev && \
mount -t proc /proc /chroot/proc && \
mount -t sysfs /sys /chroot/sys && \
mount -o rw -t tmpfs /dev /chroot/dev && \
yum -y --installroot=/chroot --exclude=kernel --disablerepo=update groupinstall Base && \
umount /chroot/proc && \
umount /chroot/sys && \
cd /chroot && \
tar --exclude=dev -czvf /mnt/rootfs.tar.gz .
endef

all: run

$(ROOTFS):
	docker run --rm --privileged --cap-add=SYS_ADMIN -v $$(pwd):/mnt -t fatherlinux/centos4-base sh -c '$(GENERATE)'

build: Dockerfile $(ROOTFS)
	docker build -t $(IMAGE) .

run: clean-containers build
	docker run --rm $(IMAGE) sh -c 'find /etc -type f -name "*release*" | xargs cat'
	docker run --rm $(IMAGE) sh -c 'yum install -y ruby && ruby -v'

clean-containers:
	-docker ps -a | grep -v IMAGE | awk '{ print $$1 }' | xargs docker rm -f

clean-images:
	-docker images | grep -v IMAGE | grep $(IMAGE) | awk '{ print $$3 }' | xargs docker rmi -f

clean-layers:
	-docker images | grep -v IMAGE | grep none | awk '{ print $$3 }' | xargs docker rmi -f

clean-rootfs:
	-rm $(ROOTFS)

clean: clean-containers clean-images clean-layers clean-rootfs

publish:
	docker push $(IMAGE)
