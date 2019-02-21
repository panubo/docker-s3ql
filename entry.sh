#!/usr/bin/env bash

# Entry point to mount s3ql filesystem before exec'ing command.

# Fail on all script errors
set -e
[ "${DEBUG:-false}" == 'true' ] && { set -x; S3QL_DEBUG='-d -d'; }

# TODO

echo "Running command $@"

exec "$@"
