# S3QL Docker image

Docker image for [S3QL](https://github.com/s3ql/s3ql/).

## Configuration

- `S3QL_ACCESS_KEY` - (required. Same as `AWS_ACCESS_KEY_ID`)
- `S3QL_ACCESS_SECRET` - (required. Same as `AWS_SECRET_ACCESS_KEY`)
- `S3QL_BUCKET_URL` - (required)
- `S3QL_ENCRYPTION_PASSPHRASE` - (required)
- `S3QL_AUTHFILE` - path to s3ql auth file.
- `S3QL_DATADIR` - path to s3ql data directory
- `S3QL_CACHEDIR` - path to s3ql cache directory
- `S3QL_MOUNTPOINT` - mountpoint default `/mnt`
- `AWS_S3_URL` - s3 endpoint
- `S3QL_ARGS` - additional s3ql mount arguments
- `S3QL_BACKEND` - default `s3`
- `DEBUG` - enable DEBUG mode.

## Usage example

```bash
docker run --rm -t -i --privileged \
  -e S3QL_ACCESS_KEY=xxxxxxxxxxxxxxxxxxxx \
  -e S3QL_ACCESS_SECRET=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx \
  -e S3QL_ENCRYPTION_PASSPHRASE=xxxxxxxxxxxxxxxx \
  -e S3QL_BUCKET_URL=example \
  docker.io/panubo/s3ql:3.1
```

NB, requires `privileged` mode for access to fuse device.

## Status

Experimental.
