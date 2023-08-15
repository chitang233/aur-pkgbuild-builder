FROM archlinux:latest

COPY entrypoint.sh /entrypoint.sh
COPY build.sh /build.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]