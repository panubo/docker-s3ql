#!/usr/bin/env bash

# Build S3QL from source

# Fail on errors
set -euo pipefail
[ "${DEBUG:-false}" == 'true' ] && set -x

# Don't prompt on install
export DEBIAN_FRONTEND=noninteractive

# Runtime requirements
RUNTIME_REQS='psmisc libsqlite3-0 python3 python3-llfuse python3-cryptography python3-dugong python3-defusedxml python3-apsw python3-requests'
apt-get update
apt-get -y install $RUNTIME_REQS

# Install build requirements
BUILD_REQS='curl bzip2 python3-setuptools python3-dev libsqlite3-dev build-essential'
apt-get -y install $BUILD_REQS

# Test requirements
TEST_APT_REQS='python3-pip'
TEST_PIP_REQS='pytest'
apt-get -y install $TEST_APT_REQS
# requires pytest > 4
pip3 install $TEST_PIP_REQS

# Build s3ql
DIR=$(mktemp -d) && cd ${DIR}
curl -sSf -L https://github.com/s3ql/s3ql/releases/download/release-${S3QL_VERSION}/s3ql-${S3QL_VERSION}.tar.bz2 -o s3ql.tar.bz2
sha1sum s3ql.tar.bz2
echo "$S3QL_SHA1 s3ql.tar.bz2" | sha1sum -c -
tar -xjf s3ql.tar.bz2 -C . --strip-components=1
python3 setup.py build_ext --inplace
python3 -m pytest tests/
python3 setup.py install
rm -rf ${DIR} && cd /

# Check binaries are sane
find /usr/local/bin/ -type f -name '*s3ql*' -exec {} --version \;

# Cleanup
pip3 uninstall -y $TEST_PIP_REQS
apt-get -y remove $BUILD_REQS $TEST_APT_REQS
apt-get -y install $RUNTIME_REQS  # re-add cryptography
apt-get -y autoremove && rm -rf /var/lib/apt/lists/*
rm -- "$0"
