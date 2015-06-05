IMAGE=mcandre/docker-centos:2.1
ROOTFS=rootfs.tar.gz
define GENERATE
cp /mnt/yum.conf /etc && \
cp /mnt/arch.sh /bin/arch && \
cp /mnt/uname.sh /bin/uname && \
yum -y install wget && \
mkdir -p /chroot/var/lib/rpm && \
mkdir -p /chroot/var/lock/rpm && \
rpm --root /chroot --initdb && \
wget http://vault.centos.org/2.1/final/i386/CentOS/RPMS/centos-release-as-2.1AS-4.noarch.rpm && \
rpm --root /chroot -ivh --nodeps centos-release*rpm && \
mkdir /chroot/proc && \
mkdir /chroot/sys && \
mkdir /chroot/dev && \
mount -t proc /proc /chroot/proc && \
mount -t sysfs /sys /chroot/sys && \
mount -o rw -t tmpfs /dev /chroot/dev && \
cp /mnt/yum.conf /etc && \
yum -y --installroot=/chroot --exclude=kernel install yum bash && \
cp /mnt/yum.conf /chroot/etc && \
umount /chroot/proc && \
umount /chroot/sys && \
rm -rf /chroot/var/log/* && \
cd /chroot && \
tar --exclude=dev -czvf /mnt/rootfs.tar.gz .
endef

all: run

$(ROOTFS):
	docker run --rm --privileged --cap-add=SYS_ADMIN -v $$(pwd):/mnt -t meri/centos3 sh -c '$(GENERATE)'

build: Dockerfile $(ROOTFS)
	docker build -t $(IMAGE) .

run: clean-containers build
	docker run --rm $(IMAGE) sh -c 'find /etc -type f -name "*release*" | xargs cat'
	docker run --rm $(IMAGE) sh -c 'yum -y install ruby && ruby -v'

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
