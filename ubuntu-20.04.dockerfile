FROM ubuntu:20.04

ENV container=docker \
  LANGUAGE=en_US.UTF-8 \
  LANG=en_US.UTF-8 \
  LC_ALL=en_US.UTF-8 \
  TERM=xterm \
  DEBIAN_FRONTEND="noninteractive"

ARG PKGS_LIST="apt-utils \
  bash \
  ca-certificates \
  dbus \
  dbus-user-session \
  gnupg \
  iproute2 \
  libsystemd-dev \
  locales \
  python3 \
  python3-pip \
  python3-setuptools \
  rsyslog \
  sudo \
  systemd \
  systemd-cron"

# Enable all repositories
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

RUN apt-get update && \
  apt-get install -y --no-install-recommends ${PKGS_LIST} && \
  apt-get autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  locale-gen en_US.UTF-8 && \
  pip3 install --upgrade --no-cache-dir pip

RUN rm -Rf /var/lib/apt/lists/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && rm -f /lib/systemd/system/multi-user.target.wants/* \
  && rm -f /etc/systemd/system/*.wants/* \
  && rm -f /lib/systemd/system/local-fs.target.wants/* \
  && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
  && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
  && rm -f /lib/systemd/system/basic.target.wants/* \
  && rm -f /lib/systemd/system/anaconda.target.wants/* \
  && rm -f /lib/systemd/system/plymouth* \
  && rm -f /lib/systemd/system/systemd-update-utmp* \
  && rm -f /lib/systemd/system/systemd*udev* \
  && rm -f /lib/systemd/system/getty.target

RUN cp /bin/true /sbin/agetty

STOPSIGNAL SIGRTMIN+3

VOLUME ["/sys/fs/cgroup"]

CMD ["/sbin/init"]
