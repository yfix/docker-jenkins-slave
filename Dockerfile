# This Dockerfile is used to build an image containing basic stuff 
# to be used as a Jenkins slave build node.

FROM yfix/baseimage

MAINTAINER Yuri Vysotskiy (yfix) <yfix.dev@gmail.com>

RUN locale-gen en_US.UTF-8 && \
    apt-get -q update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends \
		openssh-server \
		git && \
    apt-get -q autoremove && \
    apt-get -q clean -y && \
	rm -rf /var/lib/apt/lists/* && \
	rm -f /var/cache/apt/*.bin && \
	\
    sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd && \
    mkdir -p /var/run/sshd

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN apt-get -q update && \
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends \
		openjdk-7-jre-headless && \
    apt-get -q clean -y && \
	rm -rf /var/lib/apt/lists/* && \
	rm -f /var/cache/apt/*.bin

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins && \
    echo "jenkins:jenkins" | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
