#!/bin/bash
set -e

if [[ -z "${GCS_KEY}" ]]; then
  >&2 echo "GCS_KEY is not set as instance variable!"
  exit 1
fi

if [[ -z "${BUCKET}" ]]; then
  >&2 echo "BUCKET is not set as instance variable!"
  exit 1
fi

if [[ -z "${USERNAME}" ]]; then
  >&2 echo "USERNAME is not set as instance variable!"
  exit 1
fi

if [[ -z "${PASSWORD}" ]]; then
  >&2 echo "PASSWORD is not set as instance variable!"
  exit 1
fi

echo $GCS_KEY | base64 --decode | gcloud auth activate-service-account --key-file=-
gsutil -m rsync -r gs://$BUCKET /var/geminabox-data

exec "$@"
