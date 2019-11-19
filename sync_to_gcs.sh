#!/bin/bash

while inotifywait -r -e modify,create,delete,move /var/geminabox-data; do
  gsutil rsync -r /var/geminabox-data gs://$BUCKET
done
