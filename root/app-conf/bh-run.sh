#!/usr/bin/with-contenv bash
# 启动bilibili-helper
BH_TODAY="$(date +"%Y-%m-%d")"
BH_RUN_TIME="$(grep ^今天已签到完毕 "/config/bilibili-helper.log" | cut -d: -f2-)"

if [ "${BH_TODAY}" != "${BH_RUN_TIME}" ] && [ "${CRON}" = random ]
then
    cd /app && java -jar BILIBILI-HELPER.jar /config/config.json | s6-setuidgid abc tee /config/bilibili-helper.log
    echo -e "今天已签到完毕:$(date +"%Y-%m-%d")" | s6-setuidgid abc tee -a /config/bilibili-helper.log
    . /app-conf/random-bh.sh
    crontab /config/bh-crontab
    echo -e "明天签到的时间为:" | s6-setuidgid abc tee -a /config/bilibili-helper.log
    cat /config/bh-crontab | s6-setuidgid abc tee -a /config/bilibili-helper.log
fi

if [ "${CRON}" = true ]
then
    cd /app && java -jar BILIBILI-HELPER.jar /config/config.json | s6-setuidgid abc tee /config/bilibili-helper.log
    echo -e "今天已签到完毕=$(date +"%Y-%m-%d")" | s6-setuidgid abc tee -a /config/bilibili-helper.log
fi