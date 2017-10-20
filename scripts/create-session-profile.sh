#!/usr/bin/env bash

set -e
set -o pipefail

function usage() {
    echo "Fetches a session token and writes short lived a aws profile for later use" >&2
    echo "" >&2
    echo "${0} [--profile AWS_PROFILE] [--target-profile TARGET_AWS_PROFILE] [--target-shared-credentials SHARED_CREDENTIALS_FILE] [--replace] [--duration-seconds DURATION]" >&2
    echo "  --profile                   - use specified AWS profile to fetch the session token" >&2
    echo "  --target-profile            - name of the new profile" >&2
    echo "  --target-shared-credentials - path to the shared credentials file" >&2
    echo "  --replace                   - replaces existing credentials file" >&2
    echo "  --duration-seconds          - session token is valid for given amount of time" >&2
    echo "  --help                      - shows this message" >&2
    exit 1
}

# default settings
SHARED_CREDENTIALS="${AWS_SHARED_CREDENTIALS_FILE:-${HOME}/.aws/credentials}"
DURATION_SECONDS='900'
TARGET_PROFILE='session-profile'
REPLACE=0

# command line parsing
while [ $# -gt 0 ]; do
    if [ "${1}" == '--profile' ] && [ -n "${2}" ]; then
        export AWS_PROFILE="${2}"
        shift; shift
    elif [ "${1}" == '--target-profile' ] && [ -n "${2}" ]; then
        TARGET_PROFILE="${2}"
        shift; shift
    elif [ "${1}" == '--replace' ]; then
        REPLACE=1
        shift
    elif [ "${1}" == '--target-shared-credentials' ] && [ -n "${2}" ]; then
        SHARED_CREDENTIALS="${2}"
        shift; shift
    elif [ "${1}" == '--duration-seconds' ] && [ -n "${2}" ]; then
        DURATION_SECONDS="${2}"
        shift; shift
    else
        usage
    fi
done

# fetch session token
credentials=$(aws sts get-session-token \
        --duration-seconds "${DURATION_SECONDS}" \
        --output json \
    | grep \
        -e 'SecretAccessKey' \
        -e 'SessionToken' \
        -e 'AccessKeyId' \
    | cut \
        -d '"' \
        -f 2,4 \
        --output-delimiter ' = ' \
    | sed \
        -e 's/SecretAccessKey/aws_secret_access_key/' \
        -e 's/SessionToken/aws_session_token/' \
        -e 's/AccessKeyId/aws_access_key_id/')


# write session token to shared credentials file
if [ ${REPLACE} -eq 1 ]; then
    rm -f "${SHARED_CREDENTIALS}"
fi
cat >> "${SHARED_CREDENTIALS}" <<EOF

[${TARGET_PROFILE}]
${credentials}
EOF

echo "Wrote session profile ${TARGET_PROFILE} to ${SHARED_CREDENTIALS}"
echo "Valid for ${DURATION_SECONDS}s"