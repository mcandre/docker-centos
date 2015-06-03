IMAGE=mcandre/docker-centos:4.9
ROOTFS=rootfs.tar.gz
define GENERATE
yum install -y wget tar && \
mkdir -p /chroot/var/lib/rpm && \
rpm --root /chroot --initdb && \
wget http://vault.centos.org/4.9/updates/x86_64/RPMS/centos-release-4-9.1.x86_64.rpm && \
rpm --root /chroot -ivh --nodeps centos-release*rpm && \
cp -r /mnt/yum.repos.d /chroot/etc && \
mkdir /chroot/proc && \
mkdir /chroot/sys && \
mkdir /chroot/dev && \
mount -t proc /proc /chroot/proc && \
mount -t sysfs /sys /chroot/sys && \
mount -t tmpfs /dev /chroot/dev && \
yum -y --nogpgcheck --installroot=/chroot --exclude=kernel groupinstall Base && \
umount /chroot/proc && \
umount /chroot/sys && \
umount /chroot/dev && \
cd /chroot && \
tar czvf /mnt/rootfs.tar.gz .
endef

all: run

$(ROOTFS):
	docker run --rm --privileged --cap-add=SYS_ADMIN,AUDIT_WRITE -v $$(pwd):/mnt -t centos:5 sh -c '$(GENERATE)'

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
