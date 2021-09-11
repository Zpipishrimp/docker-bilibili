#!/usr/bin/with-contenv bash

# 该脚本默认产生6点-24点随机运行时间
# 配置签到时间范围
STARTTIME=6
ENDTIME=24

# 随机数 产生随机分钟和小时
DIFF=$(($ENDTIME-$STARTTIME))
RANDMINUTE=$(($RANDOM%60))
RANDHOUR=$(($RANDOM%$DIFF+$STARTTIME))

# 创建定时任务脚本

cat > /etc/cron.d/bh-crontab << EOF
# do daily/weekly/monthly maintenance
# min   hour    day     month   weekday command
  $[RANDMINUTE]     $[RANDHOUR]       *       *       *      /app-conf/bh-run.sh
EOF
chmod 0644 /etc/cron.d/bh-crontab
