FROM centos

ENV DOCTL_VERSION 1.8.3

WORKDIR /root

RUN curl -L -o doctl.tgz https://github.com/digitalocean/doctl/releases/download/v${DOCTL_VERSION}/doctl-${DOCTL_VERSION}-linux-amd64.tar.gz && \
    tar xf doctl.tgz && rm -f doctl.tgz && chown root:root doctl && mv doctl /bin/

RUN yum update -y && yum install -y tmux openssh-clients

COPY validate.sh .

CMD ./validate.sh