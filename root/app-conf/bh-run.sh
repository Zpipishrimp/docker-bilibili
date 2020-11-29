#!/usr/bin/with-contenv bash

# 启动bilbili-helper
cd /app && java -jar /app/BILIBILI-HELPER.jar ${DEDEUSERID} ${SESSDATA} ${BILI_JCT} ${SERVERPUSHKEY} | s6-setuidgid abc tee /config/bilbili-helper.log

