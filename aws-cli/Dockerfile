FROM ubuntu:17.04

# building a docker images meant to run with igor
# the image provieds all tools required for the code lab: aws cli, autostacker24, cli53
# run the following command to build the image locally:
#    docker build -t aws-cli .

CMD ["/bin/bash"]

ENV \
    CLI53_VERSION=0.8.8 \
    BUNDLER_VERSION=1.15.4 \
    RAKE_VERSION=12.0.0 \
    AWS_SIGV4_VERSION=1.0.0 \
    AWS_SDK_CORE_VERSION=2.7.3 \
    JSON=2.0.3 \
    JSON_PURE=2.0.3 \
    AUTOSTACKER_VERSION=2.7.0 \
    NODE_VERSION=6.x

RUN apt-get update \
 && apt-get install -y awscli ruby ruby-dev gcc make git curl tree vim groff \
 && rm -rf /var/lib/apt/* /var/cache/apt/*

RUN gem install -v ${BUNDLER_VERSION} bundler
RUN gem install -v ${RAKE_VERSION} rake
RUN gem install -v ${AWS_SIGV4_VERSION} aws-sigv4
RUN gem install -v ${AWS_SDK_CORE_VERSION} aws-sdk-core
RUN gem install -v ${JSON} json
RUN gem install -v ${JSON_PURE} json_pure
RUN gem install -v ${AUTOSTACKER_VERSION} autostacker24

RUN curl -L -o /usr/local/bin/cli53 https://github.com/barnybug/cli53/releases/download/${CLI53_VERSION}/cli53-linux-amd64 \
 && chmod +x /usr/local/bin/cli53

RUN curl -L -o /usr/local/bin/swamp https://github.com/felixb/swamp/releases/download/v0.1/swamp_amd64 \
 && chmod +x /usr/local/bin/swamp

RUN curl -sL https://deb.nodesource.com/setup_${NODE_VERSION} | bash - \
 && apt-get install nodejs \
 && rm -rf /var/lib/apt/* /var/cache/apt/*
