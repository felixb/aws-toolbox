#! /bin/bash

if [ "${1}" == '--help' ]; then
  echo "usage: ${0} [--profile profile-name] git-glone-args"
  echo "  --profile profile-name - select aws cli profile, defaults to 'default'"
  exit 1
fi

if [ "${1}" == '--profile' ]; then
  profile_args="--profile ${2}"
  shift
  shift
fi

git clone \
  --config credential.UseHttpPath=true \
  --config credential.helper="!aws ${profile_args} codecommit credential-helper \$@" \
  $@

