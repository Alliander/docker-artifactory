FROM openjdk:8u121-alpine

LABEL maintainer "Alliander - Sander Schoot Uiterkamp"

ENV ARTIFACTORY_UID=3824
ENV ARTIFACTORY_GID=3824
ENV ARTIFACTORY_VERSION=5.2.1

RUN apk upgrade --update && \
	apk add --update unzip wget curl bash libressl && \
	wget https://bintray.com/jfrog/artifactory/download_file?file_path=jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip -O /tmp/jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip && \
	echo "downloaded /tmp/frog-artifactory-oss-${ARTIFACTORY_VERSION}.zip from https://bintray.com/jfrog/artifactory/download_file?file_path=jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip" && \
	mkdir /var/opt/jfrog/  && \
    unzip /tmp/jfrog-artifactory-oss-${ARTIFACTORY_VERSION}.zip -d /var/opt/jfrog && \
	ln -s /var/opt/jfrog/artifactory-oss-${ARTIFACTORY_VERSION} /var/opt/jfrog/artifactory && \
	apk del wget unzip curl && \
	rm -rf /tmp/* /var/tmp/* /var/cache/apk/* && \
	addgroup -g ${ARTIFACTORY_GID} artifactory && \
	adduser -D -G artifactory -s /bin/bash -u ${ARTIFACTORY_UID} artifactory && \
	chown -R artifactory:artifactory /var/opt/jfrog

USER artifactory

WORKDIR /var/opt/jfrog/artifactory

EXPOSE 8081

ENTRYPOINT ["/var/opt/jfrog/artifactory/bin/artifactory.sh"]