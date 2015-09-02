#!/bin/bash

HOST=$1
MASTER="${HOST%-*}-db1"

echo exit | mongo --host $MASTER > /dev/null 2>&1
while [ $? -ne 0 ]; do
    echo 'Testing connection to master'
    echo -n "."
    sleep 1
    echo exit | mongo --host $MASTER  > /dev/null 2>&1
done

while [ `mongo --host $MASTER --quiet --eval "rs.status()['ok']"` != "1" ]; do
    echo -n "."
    sleep 1
done

mongo --host $MASTER --quiet /usr/libexec/mongo/rs_mongo_add_member.js

