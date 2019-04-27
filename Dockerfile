FROM alpine:latest
MAINTAINER Andre Faria <andremarcalfaria@gmail.com>

ARG user=jenkins
ARG group=jenkins
ARG uid=1000
ARG gid=1000
ARG JENKINS_AGENT_HOME=/home/${user}

#ENV Sonar-Scanner
ENV SONAR_RUNNER_HOME=/opt/sonar-scanner
ENV PATH $PATH:/opt/sonar-scanner/bin

# Update system
RUN apk update && \
    apk add --no-cache sudo bash unzip git openjdk8 openssh curl nodejs ansible
#Install Sonar-Scanner
RUN mkdir /tmp/tempdownload && \
    curl --insecure -o /tmp/tempdownload/scanner.zip -L https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-3.3.0.1492-linux.zip && \
    unzip /tmp/tempdownload/scanner.zip -d /tmp/tempdownload && \
    mv /tmp/tempdownload/$(ls /tmp/tempdownload | grep sonar-scanner) /opt/sonar-scanner && \
    rm -rf /tmp/tempdownload

# Add user jenkins to the image, change it's password
RUN addgroup -g ${gid} ${group} && \
    adduser -D -h "${JENKINS_AGENT_HOME}" -u "${uid}" -G "${group}" -s /bin/bash "${user}" && \
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
