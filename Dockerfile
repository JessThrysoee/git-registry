FROM alpine:3.17.3

RUN apk add --no-cache git openssh bash shadow borgbackup \
  && adduser -D -u 10001 -s /usr/bin/git-shell git \
  && usermod -p '*' git \
  && mkdir -p /git-registry/etc/ssh \
  && mkdir /home/git/src \
  && chown git:git /home/git/src 

COPY src/config/sshd_config /etc/ssh/
COPY src/scripts/add-public-key.sh /
COPY --chown="git:git" src/config/gitconfig /home/git/.gitconfig
COPY --chown="git:git" src/git-shell-commands /home/git/git-shell-commands

EXPOSE 22
VOLUME ["/git-registry"]
VOLUME ["/home/git/src"]

CMD ["/usr/sbin/sshd", "-D"]

