IMAGE=mcandre/docker-centos:3.1
ROOTFS=rootfs.tar.gz
define GENERATE
cp -r /mnt/yum.conf /etc && \
cp -r /mnt/centos-release-3 /usr/share/doc && \
rpm --import /usr/share/doc/centos-release-3/RPM-GPG-KEY && \
rpm --import /usr/share/doc/centos-release-3/RPM-GPG-KEY-CentOS-3 && \
yum -y install wget && \
mkdir -p /chroot/var/lib/rpm && \
mkdir -p /chroot/var/lock/rpm && \
rpm --root /chroot --initdb && \
wget http://vault.centos.org/3.1/os/x86_64/RedHat/RPMS/centos-release-3.1-1.x86_64.rpm && \
rpm --root /chroot -ivh --nodeps centos-release*rpm && \
rpm --root /chroot --import /usr/share/doc/centos-release-3/RPM-GPG-KEY && \
rpm --root /chroot --import /usr/share/doc/centos-release-3/RPM-GPG-KEY-CentOS-3 && \
mkdir /chroot/proc && \
mkdir /chroot/sys && \
mkdir /chroot/dev && \
mount -t proc /proc /chroot/proc && \
mount -t sysfs /sys /chroot/sys && \
mount -o rw -t tmpfs /dev /chroot/dev && \
cp /mnt/yum.conf /etc && \
yum -y --installroot=/chroot --exclude=kernel install yum bash && \
wget http://vault.centos.org/3.1/os/x86_64/RedHat/RPMS/db4-utils-4.1.25-8.x86_64.rpm && \
rpm --root /chroot --nodeps -ivh db4-utils-4.1.25-8.x86_64.rpm && \
cp /mnt/yum.conf /chroot/etc && \
yum -y --installroot=/chroot install compat-db findutils && \
cp /mnt/repair-rpm.sh /chroot/repair-rpm.sh && \
cp /mnt/yum.conf /etc && \
chroot /chroot /repair-rpm.sh && \
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
