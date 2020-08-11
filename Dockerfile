FROM alpine:latest

ARG username=user

# add openssh and rsync then clean up
RUN apk add --update openssh && \
    apk add --update rsync && \
    rm -rf /tmp/* /var/cache/apk/*

# Copy generate host keys, setup ssh
COPY ./etc/ /etc
RUN mkdir -p /var/run/sshd

# Add user and fix password
RUN adduser -D $username && \
    sed -i -e "s/$username:!:/$username:*:/g" /etc/shadow

# Disable root login, only allow key access
RUN echo "PermitRootLogin no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

# copy in public key
COPY key.pub /home/$username/.ssh/authorized_keys
RUN chmod 644 /home/$username/.ssh/authorized_keys && \
    chown $username /home/$username/.ssh/authorized_keys

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]
