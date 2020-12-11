FROM alpine:3.12.2
MAINTAINER Peter van Gulik <peter@curlybracket.nl>

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
RUN curl -SL https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-4.3.0.2102-linux.zip -o sonar.zip \
    && unzip sonar.zip \
    && mv sonar-scanner-4.3.0.2102-linux sonar-scanner \
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
