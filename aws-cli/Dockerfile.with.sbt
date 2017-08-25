FROM ubuntu:17.04

# building a docker images meant to run with igor
# the image provieds all tools required for the code lab: aws cli, autostacker24, cli53
# run the following command to build the image locally:
#    docker build -t aws-cli .

CMD ["/bin/bash"]

ENV \
    CLI53_VERSION=0.8.8 \
    BUNDLER_VERSION=1.15.4

RUN apt-get update \
 && apt-get install -y awscli ruby ruby-dev gcc make git curl tree vim groff openjdk-8-jdk \
 && rm -rf /var/lib/apt/* /var/cache/apt/*

RUN gem install -v ${BUNDLER_VERSION} bundler

RUN curl -L -o /usr/local/bin/cli53 https://github.com/barnybug/cli53/releases/download/${CLI53_VERSION}/cli53-linux-amd64 \
 && chmod +x /usr/local/bin/cli53

RUN curl -L -o /usr/local/bin/swamp https://github.com/felixb/swamp/releases/download/v0.1/swamp_amd64 \
 && chmod +x /usr/local/bin/swamp

RUN curl -L https://github.com/sbt/sbt/releases/download/v1.0.0/sbt-1.0.0.tgz | tar -xzvC /usr/local/lib \
 && chown -R root:root /usr/local/lib/sbt \
 && ln -s /usr/local/lib/sbt/bin/sbt /usr/local/bin/


