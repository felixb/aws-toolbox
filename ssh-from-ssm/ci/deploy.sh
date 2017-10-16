#!/usr/bin/env bash

if [ -z "${PROFILE}" ]; then
    echo "Please set environment variable PROFILE"
    exit 1
fi

if [ -z "${NOTIFICATIONEMAILADDRESS}" ]; then
    echo "Please set environment variable NOTIFICATIONEMAILADDRESS"
    exit 1
fi

bundle check || bundle install

# Deploy
bundle exec autostacker24 update --template ssh-from-ssm/cf-templates/ssm.yaml \
    --param NotificationEmailAddress="${NOTIFICATIONEMAILADDRESS}" \
    --stack "ssm-test" \
    --profile "${PROFILE}"
