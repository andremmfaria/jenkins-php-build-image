FROM nexus.kantaros.net:4431/jenkins-dind-build-image:master
MAINTAINER Andre Faria <andremarcalfaria@gmail.com>

#ENV Sonar-Scanner
ENV SONAR_RUNNER_HOME=/opt/sonar-scanner
ENV PATH $PATH:/opt/sonar-scanner/bin

# Update system
RUN apk update && \
    apk add --no-cache unzip nodejs ansible

#Install Sonar-Scanner
RUN mkdir /tmp/tempdownload && \
    curl --insecure -o /tmp/tempdownload/scanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-linux.zip && \
    unzip /tmp/tempdownload/scanner.zip -d /tmp/tempdownload && \
    mv /tmp/tempdownload/$(ls /tmp/tempdownload | grep sonar-scanner) /opt/sonar-scanner && \
    rm -rf /tmp/tempdownload
