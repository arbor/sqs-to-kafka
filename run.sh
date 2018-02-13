#!/bin/bash

set -e

export CLUB_NAME=${CLUB_NAME:-$USER}
export KAFKA_HOST=${KAFKA_HOST:-localhost}

exe=$(cat $(basename $PWD).cabal | grep executable | head -n 1 | cut -d' ' -f2)
echo "Running: $exe"

stack build
path=$(stack path --local-install-root)

${path}/bin/${exe} \
  --kafka-broker ${KAFKA_HOST}:9092 \
  --kafka-group-id ${CLUB_NAME}--sqs-to-kafka-${USER} \
  --kafka-schema-registry http://${KAFKA_HOST}:8081 \
  --input-topic ${CLUB_NAME}--sqs-to-kafka-input \
  --kafka-poll-timeout-ms 10000 \
  --kafka-debug-enable "broker,protocol" \
  --log-level LevelInfo
