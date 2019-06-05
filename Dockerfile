FROM debian:stretch

ENV S3QL_VERSION=3.1 S3QL_SHA1=8253655bf8f04c6edac2181b6f2ee63c4aafc7ce

ADD build-s3ql.sh /

RUN /build-s3ql.sh

ADD entry.sh /

ENTRYPOINT ["/entry.sh"]
