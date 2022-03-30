# Base container for Holberton School
#
# Allow SSH connection to the container

FROM ubuntu:14.04
LABEL maintainer="Guillaume Salva <guillaume@holbertonschool.com>"

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends -y \
        curl wget git vim emacs \
        openssh-server \
        build-essential software-properties-common gcc-4.8 \
        man manpages-dev manpages-posix-dev
RUN rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd \
    && sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/^#PasswordAuthentication/PasswordAuthentication/' /etc/ssh/sshd_config \
    && sed -ri 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN git clone https://github.com/holbertonschool/Betty.git /tmp/Betty \
        && cd /tmp/Betty \
        && ./install.sh \
        && cd - \
        && rm -rf /tmp/Betty

ADD run.sh /etc/sandbox_run.sh
RUN chmod u+x /etc/sandbox_run.sh

# start run!
CMD ["./etc/sandbox_run.sh"]
