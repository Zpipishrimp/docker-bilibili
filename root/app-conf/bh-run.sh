#!/usr/bin/with-contenv bash

# 启动bilibili-helper
cd /app && java -jar /app/BILIBILI-HELPER.jar ${DEDEUSERID} ${SESSDATA} ${BILI_JCT} ${SERVERPUSHKEY} ${TELEGRAMBOTTOKEN} ${TELEGRAMCHATID} | s6-setuidgid abc tee /config/bilibili-helper.log

if [ "${CRON}" = random ]
then
    . /app-conf/random-bh.sh
    ps -ef | grep cron | grep -v grep | awk '{printf $2}' | xargs kill -9
    ps -ef | grep tail | grep -v grep | awk '{printf $2}' | xargs kill -9
fi
