#!/bin/bash -e

pg_dump -Fc psql -f postgres.dump
aws s3 cp /home/mastodon/postgres.dump s3://imichka-mastodon/backup-postgres/$(date --iso-8601=seconds)/
