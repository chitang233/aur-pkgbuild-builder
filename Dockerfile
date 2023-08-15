FROM archlinux:latest

ENV SSH_PRIVATE_KEY ${deploy_key}
ENV PKGNAME ${package_name}

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]