#!/usr/bin/env bash

/usr/local/bin/confd -onetime -backend env
java -jar /app/fcrepo-camel-toolbox.jar --config /app/configuration.properties
