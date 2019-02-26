#!/usr/bin/env bash

# Entry point to mount s3ql filesystem before exec'ing command.

# Fail on all script errors
set -e
[ "${DEBUG:-false}" == 'true' ] && { set -x; S3QL_DEBUG='--debug'; }

# Defaults
: ${S3QL_DATADIR:='/var/s3ql'}
: ${S3QL_AUTHFILE:="${S3QL_DATADIR}/authinfo2"}
: ${S3QL_CACHEDIR:="${S3QL_DATADIR}"}
: ${S3QL_MOUNTPOINT:='/mnt'}
: ${S3QL_ARGS:=''}
: ${S3QL_BACKEND:='s3'}

# Configuration checks
if [ -z "$S3QL_BUCKET_NAME" ]; then
  echo "Error: S3QL_BUCKET_NAME is not specified"
  exit 128
fi

if [ -z "$S3QL_ENCRYPTION_KEY" ] && [ -z "$S3QL_ACCESS_KEY" ]; then
  echo "Error: S3QL_AUTHFILE not specified, or S3QL_ENCRYPTION_KEY not provided"
  exit 128
fi

if [ ! -f "${S3QL_AUTHFILE}" ] && [ -z "$S3QL_ACCESS_KEY" ]; then
  echo "Error: S3QL_AUTHFILE not specified, or S3QL_ACCESS_KEY not provided"
  exit 128
fi

if [ ! -f "${S3QL_AUTHFILE}" ] && [ -z "$S3QL_ACCESS_SECRET" ]; then
  echo "Error: S3QL_AUTHFILE not specified, or S3QL_ACCESS_SECRET not provided"
  exit 128
fi

echo "==> Mounting S3QL Filesystem"
mkdir -p ${S3QL_MOUNTPOINT} ${S3QL_DATADIR}

# Write auth file if it does not exist
if [ ! -f "${S3QL_AUTHFILE}" ]; then
  (
    echo "[${S3QL_BACKEND}]"
    echo "storage-url: ${S3QL_BUCKET_NAME}"
    echo "backend-login: ${S3QL_ACCESS_KEY}"
    echo "backend-password: ${S3QL_ACCESS_SECRET}"
    echo "fs-passphrase: ${S3QL_ENCRYPTION_KEY}"
  ) > "${S3QL_AUTHFILE}"
  chmod 400 ${S3QL_AUTHFILE}
fi

if [ -z "$1" ]; then
  set -ex
  mount.s3ql $S3QL_DEBUG $S3QL_ARGS --cachedir $S3QL_CACHEDIR --authfile $S3QL_AUTHFILE --fg $S3QL_BUCKET_NAME $S3QL_MOUNTPOINT
else
  (set -ex; mount.s3ql $S3QL_DEBUG $S3QL_ARGS --cachedir $S3QL_CACHEDIR --authfile $S3QL_AUTHFILE $S3QL_BUCKET_NAME $S3QL_MOUNTPOINT)
  echo "Running command $@"
  exec "$@"
fi
