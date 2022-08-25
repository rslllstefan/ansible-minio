FROM centos:7

ENV container=docker \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  TERM=xterm

RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; \
  do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
  rm -f /lib/systemd/system/multi-user.target.wants/*;\
  rm -f /etc/systemd/system/*.wants/*;\
  rm -f /lib/systemd/system/local-fs.target.wants/*; \
  rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
  rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
  rm -f /lib/systemd/system/basic.target.wants/*;\
  rm -f /lib/systemd/system/anaconda.target.wants/*;

# Dependencies for Ansible
RUN yum makecache fast && \
  yum install -y epel-release && \
  yum install -y python python-pip sudo bash iproute yum-plugin-ovl util-linux systemd-sysv initscripts && \
  sed -i 's/plugins=0/plugins=1/g' /etc/yum.conf && \
  yum clean all && rm -rf /var/cache/yum && \
  touch /etc/sysconfig/network && \
  localedef -f UTF-8 -i en_US en_US.UTF-8 && \
  python -m pip install --upgrade --no-cache-dir pip==20.3.4

RUN cp /bin/true /sbin/agetty

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]

CMD ["/sbin/init"]
