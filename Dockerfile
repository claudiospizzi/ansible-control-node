FROM alpine:3.14.2


##
## PowerShell 7.2.4
## https://docs.microsoft.com/en-us/powershell/scripting/install/install-alpine?view=powershell-7.2
##

ENV PWSH_PATH /opt/microsoft/powershell/7
ENV PWSH_VERSION 7.2.4

# Install the PowerShell 7.2.4 dependencies
RUN apk add --no-cache \
    ca-certificates \
    less \
    ncurses-terminfo-base \
    krb5-libs \
    libgcc \
    libintl \
    libssl1.1 \
    libstdc++ \
    tzdata \
    userspace-rcu \
    zlib \
    icu-libs \
    curl
RUN apk -X https://dl-cdn.alpinelinux.org/alpine/edge/main add --no-cache \
    lttng-ust

# Download and install (extract) PowerShell 7.2.4
RUN mkdir -p $PWSH_PATH \
    && curl -L https://github.com/PowerShell/PowerShell/releases/download/v$PWSH_VERSION/powershell-$PWSH_VERSION-linux-alpine-x64.tar.gz -o /tmp/powershell.tar.gz \
    && tar zxf /tmp/powershell.tar.gz -C $PWSH_PATH \
    && rm /tmp/powershell.tar.gz

# Include PowerShell in the path as executable
RUN chmod +x $PWSH_PATH/pwsh
RUN ln -s $PWSH_PATH/pwsh /usr/bin/pwsh


##
## Ansible 5.7.1
## https://github.com/jmal98/ansiblecm/blob/master/Dockerfile
##

# Ansible dependencies based on the jmal98 repo
RUN apk add --no-cache \
    bzip2 \
    file \
    gzip \
    libffi \
    libffi-dev \
    krb5 \
    krb5-dev \
    krb5-libs \
    musl-dev \
    openssh \
    openssl-dev \
    python3-dev=3.9.5-r2 \
    py3-cffi \
    py3-cryptography=3.3.2-r1 \
    py3-setuptools=52.0.0-r3 \
    sshpass \
    tar

# Dependencies for the build process, removed later
RUN apk add --no-cache --virtual build-dependencies \
    gcc \
    make

# Bootstrapping for the pip installer
RUN python3 -m ensurepip --upgrade

# Install ansible and all required python modules
RUN pip3 install \
    ansible==5.7.1 \
    botocore==1.23.1 \
    boto==2.49.0 \
    PyYAML==5.4.1 \
    boto3==1.20.0 \
    awscli==1.22.1 \
    pywinrm[kerberos]==0.4.2

# Cleanup
RUN apk del build-dependencies \
    && rm -rf /root/.cache

# Ansible working directory
RUN mkdir /ansible
WORKDIR /ansible
VOLUME [ "/ansible" ]


##
## SSH Setup
##

# Add OpenSSH and the dos2unix (convert Windows line endings to linux line
# endings for the ssh key files)
RUN apk add --no-cache \
    openssh \
    dos2unix

# Volume for the SSH key mount, will be copied to ~/.ssh by the entrypoint
# script, because the permissions must be fixed if mounted on a Windows hosts.
VOLUME [ "/tmp/.ssh" ]


##
## Ansible Customization
##

ENV ANSIBLE_LIBRARY /ansible/library


##
## Startup and Shell
##

# Install the bash shell
RUN apk add --no-cache \
    bash

# Customize bash prompt
ENV PS1="[$(whoami)@$(hostname) $(pwd)]# "

# Ensure the bash history and ssh known hosts files exists for mounting
RUN touch ~/.bash_history

# Embedd and set the entrypoint script
COPY scripts/docker-entrypoint.sh /bin/docker-entrypoint.sh
RUN chmod +x /bin/docker-entrypoint.sh

ENTRYPOINT ["/bin/docker-entrypoint.sh", "bash"]
