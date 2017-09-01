#! /bin/bash

function usage() {
  echo "usage: ${0} [-e] [--env] --role role-name command-line"
  echo "  -e     - abort after first failure"
  echo "  --env  - set AWS_PROFILE instead adding --profile argument"
  echo "  --role - switch into specified role for target accounts"
  exit 1
}

if [ "${1}" == '-e' ]; then
  set -e
  shift
fi

if [ "${1}" == '--env' ]; then
  AWS_ENV=1
  shift
else
  AWS_ENV=0
fi

if [ "${1}" == '--role' ]; then
  AWS_ROLE=${2}
  shift
  shift
else
  usage
fi

MFA_ARN=$(aws sts get-caller-identity --output json | jq -r '.Arn' | sed -e 's/user/mfa/')

while read account; do
  swamp -account "${account}" -mfa-device "${MFA_ARN}" -target-profile "tmp-${account}" -target-role "${AWS_ROLE}"
  if [ ${AWS_ENV} -eq 1 ]; then
    AWS_PROFILE="tmp-${account}" ${@}
  else
    ${@} --profile "tmp-${account}"
  fi
done < /dev/stdin
