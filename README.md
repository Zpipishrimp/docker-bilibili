<h1 align="center">
Docker BILIBILI-HELPER | BILIBILI助手
</h1>

<div align="center">

![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/JunzhouLiu/BILIBILI-HELPER-PRE?style=flat-square)  
![](https://img.shields.io/docker/pulls/superng6/bilibili-helper?style=flat-square)

</div>

## 项目介绍

**基于 BILIBILI-HELPER 项目封装为 docker 镜像，并同步更新最新 release 版本 **

本镜像基于 openjdk8 官方镜像构建，安全可靠，并尽可能的缩小镜像体积。  
关于自定义配置请参照 BILIBILI-HELPER 官方文档。
https://github.com/JunzhouLiu/BILIBILI-HELPER-PRE

## 功能列表

- [x] 通过 docker 或者云函数执行定时任务。_【运行时间可自定义】_
- [x] 哔哩哔哩漫画每日自动签到，自动阅读 1 章节 。
- [x] 每日自动从热门视频中随机观看 1 个视频，分享一个视频。
- [x] 每日从热门视频中选取 5 个进行智能投币 _【如果投币不能获得经验了，则不会投币】_
- [x] 投币支持下次一定啦，可自定义每日投币数量。_【如果检测到你已经投过币了，则不会投币】_
- [x] 大会员月底使用快到期的 B 币券，给自己充电，一点也不会浪费哦，默认开启。_【已支持给指定 UP 充电】_
- [x] 大会员月初 1 号自动领取每月 5 张 B 币券和福利。
- [x] 每日哔哩哔哩直播自动签到，领取签到奖励。_【直播你可以不看，但是奖励咱们一定要领】_
- [x] 投币策略更新可配置投币喜好。_【可配置优先给关注的 up 投币】_
- [x] 自动送出即将过期的礼物。 _【默认开启，未更新到新版本的用户默认关闭】_
- [x] 支持推送执行结果到微信，钉钉，飞书等。
- [x] 支持赛事预测。_【支持反向预测】_

## Docker Hub

https://hub.docker.com/r/superng6/bilibili-helper

### 2.0 版，取消 DEDEUSERID SESSDATA BILI_JCT 环境变量，在 config.json 中配置 Cookies 即可

### 风险提示

如果不是常用登陆地，登陆设备，有可能会封号，详情请移步到相关讨论区 [BILIBILI-HELPER Isuess](https://github.com/JunzhouLiu/BILIBILI-HELPER-PRE/issues)

![aD6sFK](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/2021-02-08/aD6sFK.png)

## Blog

https://sleele.com/2020/11/24/docker-bilibili-helper/

## 使用说明

支持 x86-64、arm64、arm32

| Architecture | Tag          |
| ------------ | ------------ |
| x86-64       | latest       |
| arm64        | arm64-latest |
| arm32        | arm32-latest |

### 获取 Bilibili Cookies （适用 v1.x 版本）

- 浏览器打开并登录 [bilibili 网站](https://www.bilibili.com/)
- 按 F12 打开 「开发者工具」 找到 应用程序/Application -> 存储 -> Cookies
- 找到 `bili_jct` `SESSDATA` `DEDEUSERID` 三项，并复制值，填写至 docker environment 中

![20201012001307](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/20201012001307.jpg)

### 获取 Bilibili Cookies （适用 v2.x 版本）

1. 浏览器打开并登录 [bilibili][1] 网站
2. 按 F12 打开 「开发者工具」 打开 网络/NetWork -> 找到并点击 nav 请求
3. 下拉请求详情，复制完整的 cookie 和 UA 备用。

ps:cookie 和 ua 只需要选中，右键复制值即可。

![cookie](https://user-images.githubusercontent.com/10470892/136814046-f4cdbab4-70d0-411e-9d16-cc6305fe5949.png)

[1]: https://www.bilibili.com/

#### 参数说明

| Name             | Value                                                                                                | 备注                |
| ---------------- | ---------------------------------------------------------------------------------------------------- | ------------------- |
| PUID             | Linux 用户 ID（以 root 用户权限运行填写 0）                                                          |                     |
| PGID             | Linux 组 ID（以 root 用户权限运行填写 0）                                                            |                     |
| TZ               | 系统时区（默认上海时区）                                                                             |                     |
| CUSP             | 自定义配置文件（默认禁用）                                                                           |                     |
| TASK             | 执行任务的间隔时间（1d 表示 1 天，1h 表示 1 小时）                                                   |                     |
| CRON             | true 时会禁用 task，使用 cron，请手动编辑/config/bh-crontab （需重启容器）                           | docker 镜像环境变量 |
| DEDEUSERID       | 从 Cookie 中获取                                                                                     | v2.x 版本弃用       |
| SESSDATA         | 从 Cookie 中获取                                                                                     | v2.x 版本弃用       |
| BILI_JCT         | 从 Cookie 中获取                                                                                     | v2.x 版本弃用       |
| SERVERPUSHKEY    | 通过 server 酱推送执行结果到微信(可选项)                                                             | v2.x 版本弃用       |
| TELEGRAMBOTTOKEN | Telegram Bot 的 HTTP API (详见[BILIBILI-HELPER](https://github.com/JunzhouLiu/BILIBILI-HELPER-PRE)） | v2.x 版本弃用       |
| TELEGRAMCHATID   | Telegram 上 userinfobot 返回的 ID                                                                    | v2.x 版本弃用       |

### 运行方式

#### docker-compose

编辑 docker-compose.yml 文件，填写对应参数

```
version: "3"
services:
  bilibili-helper:
    image: superng6/bilibili-helper:latest
    container_name: bilibili-helper
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Asia/Shanghai
      # CRON=false，使用sleep;true,定时10.30运行；random，6-24时随机运行
      - CRON=random
    volumes:
      - /appdata/config:/config
    restart: unless-stopped
```

保存文件后在当前目录执行以下命令启动容器

```
docker-compose up -d
```

#### 简化版本

v1.x : 推荐不折腾用户使用，填写`bili_jct` `SESSDATA` `DEDEUSERID` 三项即可使用，默认 24 时执行任务一次
v2.x : 在 config.json 中填写完整的 cookie 串。

**配置文件位于 `/appdata/config/config.json`，v2.0.0 调整了配置项，如果执行失败，请复制最新的配置文件替换旧的配置文件。**
![容器目录](https://user-images.githubusercontent.com/10470892/136812990-24faff8d-68dc-4d84-9926-aa0be2cd7bba.png)
注意在容器目录中是config文件夹下的config.json，而非app-conf文件夹

该目录取决于 docker-compose.yml 文件中 volumes 参数中冒号(:)左边的路径(需要自行创建)

```
docker run -d \
  --name=bilibili-helper \
  --restart unless-stopped \
  superng6/bilibili-helper:latest
```

### 自动更新 bilibili-helper

使用 watchtower 每天早上 4 点检查更新 bilibili-helper

```
docker run -d \
  --name watchtower \
  --restart=always \
  -e TZ=Asia/Shanghai \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower --cleanup --schedule "0 0 4 * * *" \
  bilibili-helper
```

## 版本控制

如果在某版本的 bilibili-helper 中遇到问题，想要回退历史版本，可以删除容器后运行指定版本镜像`tag`  
https://hub.docker.com/r/superng6/bilibili-helper/tags?page=1&ordering=last_updated

![Xnip2020-11-24_20-55-52](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/Xnip2020-11-24_20-55-52.jpg)

## 群晖&Linux 用户权限

群晖用户请使用你当前的用户 SSH 进系统，输入 `id 你的用户id` 获取到你的 UID 和 GID 并输入进去

![nwmkxT](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/nwmkxT.jpg)

## 配置自定义功能

### 修改自定义配置的方法

若需要使用自定义配置需要采用 docker-compose 的运行方法

且需要设置自定义配置选项`CUSP=true`，设置为`false`会删除自定义配置文件

**配置文件位于 `/appdata/config/config.json`，v2.0.0 调整了配置项，如果执行失败，请复制最新的配置文件替换旧的配置文件。**

该目录取决于 docker-compose.yml 文件中 volumes 参数中冒号(:)左边的路径(需要自行创建)

### 自定义功能配置

配置文件示例：

```json
{
  "biliVerify": {
    "biliCookies": "你的bilibili cookies"
  },
  "taskConfig": {
    "skipDailyTask": false,
    "matchGame": false,
    "showHandModel": false,
    "predictNumberOfCoins": 1,
    "minimumNumberOfCoins": 100,
    "taskIntervalTime": 20,
    "numberOfCoins": 5,
    "coinAddPriority": 1,
    "reserveCoins": 10,
    "selectLike": 0,
    "monthEndAutoCharge": true,
    "giveGift": true,
    "silver2Coin": true,
    "upLive": "0",
    "chargeForLove": "14602398",
    "chargeDay": 8,
    "devicePlatform": "ios",
    "userAgent": "你的浏览器UA"
  },
  "pushConfig": {
    "SC_KEY": "",
    "SCT_KEY": "",
    "TG_BOT_TOKEN": "",
    "TG_USER_ID": "",
    "TG_USE_CUSTOM_URL": false,
    "DING_TALK_URL": "",
    "DING_TALK_SECRET": "",
    "PUSH_PLUS_TOKEN": "",
    "WE_COM_GROUP_TOKEN": "",
    "WE_COM_APP_CORPID": "",
    "WE_COM_APP_CORP_SECRET": "",
    "WE_COM_APP_AGENT_ID": 0,
    "WE_COM_APP_TO_USER": "",
    "PROXY_HTTP_HOST": "",
    "PROXY_SOCKET_HOST": "",
    "PROXY_PORT": 0
  }
}
```

在 docker-compose.yml 文件所在目录执行以下命令后生效

```
docker-compose down
docker-compose up -d
```

![Xnip2020-11-23_21-27-51](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/Xnip2020-11-23_21-27-51.jpg)

### 配置文件参数

**biliVerify**

| Key(字段)   | Value(值) | 说明                                       |
| ----------- | --------- | ------------------------------------------ |
| biliCookies | str       | bilibili 的 cookie，获取方式请查看使用说明 |

**taskConfig**

| Key(字段)            | Value(值)            | 说明                                                                               |
| -------------------- | -------------------- | ---------------------------------------------------------------------------------- |
| matchGame            | [false,true]         | 是否开启赛事预测。                                                                 |
| showHandModel        | [false,true]         | `true` ：压赔率高的，`false`：压赔率低的。                                         |
| predictNumberOfCoins | [1,10]               | 单次预测的硬币数量,默认为`1`。                                                     |
| minimumNumberOfCoins | [1,无穷大]           | 预留的硬币数，低于此数量不执行赛事预测。                                           |
| taskIntervalTime     | [1,无穷大]           | 任务之间的执行间隔,默认`10`秒,云函数用户不建议调整的太长，注意免费时长。           |
| numberOfCoins        | [0,5]                | 每日投币数量,默认 `5` ,为 `0` 时则不投币。                                         |
| reserveCoins         | [0,4000]             | 预留的硬币数，当硬币余额小于这个值时，不会进行投币任务，默认值为 `50`。            |
| selectLike           | [0,1]                | 投币时是否点赞，默认 `0`, `0`：否 `1`：是。                                        |
| monthEndAutoCharge   | [false,true]         | 年度大会员月底是否用 B 币券自动充电，默认 `true`。                                 |
| chargeDay            | [1，28]              | 充电日期，默认为每月`28`号。                                                       |
| chargeForLove        | [充电对象的 uid]     | 给指定 up 主充电，可填写充电对象的 UID ,默认给作者充电。                           |
| giveGift             | [false,true]         | 直播送出即将过期的礼物，默认开启，如需关闭请改为 `false`。                         |
| upLive               | [0,送礼 up 主的 uid] | 直播送出即将过期的礼物，可填写指定 up 主的 UID ，为 `0` 时则随随机选取一个 up 主。 |
| silver2Coin          | [false,true]         | 银瓜子兑换硬币，默认开启，如需关闭请改为 `false`。                                 |
| devicePlatform       | [ios,android]        | 手机端漫画签到时的平台，建议选择你设备的平台 ，默认 `ios`。                        |
| coinAddPriority      | [0,1]                | `0`：优先给热榜视频投币，`1`：优先给关注的 up 投币。                               |
| userAgent            | 浏览器 UA            | 你的浏览器的 UA。                                                                  |
| skipDailyTask        | [false,true]         | 是否跳过每日任务，默认`true`,如果关闭跳过每日任务，请改为`false`。                 |

- **tips:从 1.0.0 版本开始，随机视频投币有一定的概率会将硬币投给本项目的开发者。**
- **默认配置文件是给开发者充电，给自己充电或者给其他 up 充电，请改为对应的 uid**
- **userAgent 建议使用你自己真实常用浏览器 UA，如果不知道自己的 UA 请到[配置生成页面查看你的 UA](https://utils.misec.top/index)**

  **pushConfig**

| 字段类型        | Key(字段)              | Value(值)    | 说明                                                                           |
| --------------- | ---------------------- | ------------ | ------------------------------------------------------------------------------ |
| server 酱       | SC_KEY                 | str          | Server 酱老版本 key，SCU 开头的                                                |
| server 酱 turbo | SCT_KEY                | str          | Server 酱 Turbo 版本 key，SCT 开头的                                           |
| Telegram        | TG_USE_CUSTOM_URL      | [false,true] | 是否开启 TGbotAPI 反代                                                         |
| Telegram        | TG_BOT_TOKEN           | str          | TG 推送 bot_token,若开启反代，需填写完整反代 url `https://***/bot?token=xxx `  |
| Telegram        | TG_USER_ID             | str          | TG 推送的用户/群组/频道 ID                                                     |
| PUSH PLUS       | PUSH_PLUS_TOKEN        | str          | push plus++推送的`token`                                                       |
| 钉钉            | DING_TALK_URL          | str          | 钉钉推送的完整 URL,e.g.`https://oapi.dingtalk.com/robot/send?access_token=xxx` |
| 钉钉            | DING_TALK_SECRET       | str          | 钉钉推送的密钥                                                                 |
| 推送代理        | PROXY_HTTP_HOST        | str          | 推送使用 HTTP 代理,e.g.`127.0.0.1`                                             |
| 推送代理        | PROXY_SOCKET_HOST      | str          | 推送使用 SOCKS(V4/V5)代理,e.g.`127.0.0.1`                                      |
| 推送代理        | PROXY_PORT             | int          | 推送代理的端口，默认 0 不代理                                                  |
| 企业微信群消息  | WE_COM_TOKEN           | str          | 企业微信，群消息非应用消息                                                     |
| 企业微信应用    | WE_COM_APP_CORPID      | str          | 企业 id 获取方式参考 :[获取][4]                                                |
| 企业微信应用    | WE_COM_APP_CORP_SECRET | str          | 应用的凭证密钥                                                                 |
| 企业微信应用    | WE_COM_APP_AGENT_ID    | int          | 企业应用的 id，整型                                                            |
| 企业微信应用    | WE_COM_APP_TO_USER     | str          | 指定接收消息的成员，成员 ID 列表 默认为@all                                    |

[4]: https://work.weixin.qq.com/api/doc/90000/90135/

- **tips:`PROXY_HTTP_HOST`和`PROXY_SOCKET_HOST`仅需填写一个。**
- **tips:钉钉推送密钥可不填，不填仅用关键词验证。**

## 微信订阅通知

### 订阅执行结果

1. 前往 [sc.ftqq.com](http://sc.ftqq.com/3.version) 点击登入，创建账号（建议使用 GitHub 登录）。
2. 点击点[发送消息](http://sc.ftqq.com/?c=code) ，生成一个 Key。将其增加 pushConfig 中，变量名为 `SCT_KEY`
3. [绑定微信账号](http://sc.ftqq.com/?c=wechat&a=bind) ，开启微信推送。
   ![serverpush](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/serverpush.png)
4. 推送效果展示
   ![wechatMsgPush](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/wechatMsgPush.jpg)

### Preview

![Xnip2020-11-22_13-56-10](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/Xnip2020-11-22_13-56-10.jpg)
