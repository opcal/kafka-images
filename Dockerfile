FROM ghcr.io/opcal/ubuntu:noble AS kafka_dist

ARG scala_version
ARG kafka_version

ARG kafka_distro_base_url=https://dlcdn.apache.org/kafka

ENV kafka_distro=kafka_${scala_version}-${kafka_version}.tgz
ENV kafka_distro_asc=${kafka_distro}.asc

RUN set -eux; \
    DEBIAN_FRONTEND=noninteractive ; \
    apt-get update ; \
    apt-get install -y --no-install-recommends \
        gnupg \
    ;

WORKDIR /var/tmp

RUN curl -sLO ${kafka_distro_base_url}/${kafka_version}/${kafka_distro} ;\
    curl -sLO ${kafka_distro_base_url}/${kafka_version}/${kafka_distro_asc} ;\
    curl -sLO ${kafka_distro_base_url}/KEYS ;\
    ls -la ./ ;\
    gpg --import KEYS ;\
    gpg --verify ${kafka_distro_asc} ${kafka_distro} ; \
    tar -xzf ${kafka_distro};  \
    rm -r kafka_${scala_version}-${kafka_version}/bin/windows ; \
    chmod a+x kafka_${scala_version}-${kafka_version}/bin/*.sh

FROM ghcr.io/opcal/eclipse-temurin:21-jre

LABEL org.opencontainers.image.authors="opcal@outlook.com"

ARG scala_version
ARG kafka_version

ENV KAFKA_VERSION=${kafka_version} \
    SCALA_VERSION=${scala_version} \
    KAFKA_HOME=/opt/kafka

ENV PATH=${PATH}:${KAFKA_HOME}/bin

WORKDIR ${KAFKA_HOME}

COPY --from=kafka_dist /var/tmp/kafka_${scala_version}-${kafka_version} ${KAFKA_HOME}

CMD ["kafka-server-start.sh"]