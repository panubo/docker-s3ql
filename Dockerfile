FROM debian:stretch

ENV S3QL_VERSION=3.0 S3QL_SHA1=0a7ec3554b372f781550bc94e6c0d31d9c9cd005

ADD *.sh /

RUN /build-s3ql.sh

ENTRYPOINT ["/entry.sh"]
