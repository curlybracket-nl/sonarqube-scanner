FROM alpine:3.13.5
MAINTAINER Peter van Gulik <peter@curlybracket.nl>

# args
ARG SONASCANNER_VERSION=4.6.2.2472
ARG SONASCANNER_ZIP_URL=https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-${SONASCANNER_VERSION}-linux.zip

# Add packages
RUN apk --no-cache add \ 
    bash \
    unzip \
    git \
    openjdk11 \
    nodejs \
    curl \ 
    nss \
    nodejs \
    npm \
    wget

# Download Sonarscanner
RUN curl -SL ${SONASCANNER_ZIP_URL} -o sonar.zip \
    && unzip sonar.zip \
    && mv sonar-scanner-${SONASCANNER_VERSION}-linux sonar-scanner \
	&& rm -rf /sonar-scanner/jre \
	&& ln -sf /usr/lib/jvm/default-jvm /sonar-scanner/jre \
    && ln -sf /sonar-scanner/bin/sonar-scanner /usr/bin/sonar-scanner \
    && ln -sf /sonar-scanner/bin/sonar-scanner-debug /usr/bin/sonar-scanner-debug \
    && rm -rf sonar.zip

# Set java home
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
RUN chmod a+rw /usr/lib/jvm/default-jvm/jre/lib/security/cacerts

# Setup entry point to use umask 0000 and run bash
COPY docker-entrypoint.sh /entrypoint.sh
RUN chmod ugo+x /entrypoint.sh && chmod a+rw /
ENTRYPOINT ["/entrypoint.sh"]

# EOF
