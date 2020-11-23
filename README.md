# Docker BILIBILI-HELPER | BILIBILI助手
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/JunzhouLiu/BILIBILI-HELPER?style=flat-square)  ![](https://img.shields.io/docker/pulls/superng6/bilbili-helper?style=flat-square)
## 项目介绍
根据BILIBILI-HELPER项目封装为docker镜像，并同步更新最新release版本  
https://github.com/JunzhouLiu/BILIBILI-HELPER  

BILIBILI-HELPER自身支持在GitHub action中运行，非常方便。但是由于GitHub action的服务器在海外，异地海外登录账号可能会引起B站风控警报，本地部署更可靠一些。  
本镜像基于openjdk8官方镜像构建，安全可靠，并尽可能的缩小镜像体积。  
关于自定义配置请参照BILIBILI-HELPER官方文档。
## Docker Hub
https://hub.docker.com/r/superng6/bilbili-helper

* [x] 自定义时间运行任务。(默认以打开容器时间开始每24时执行一次)
* [x] 哔哩哔哩漫画每日自动签到 。
* [x] 每日自动从热门视频中随机观看 1 个视频，分享一个视频。
* [x] 每日从热门视频中选取 5 个进行智能投币 *【如果投币不能获得经验，默认不投币】*
* [x] 投币支持下次一定啦，可自定义每日投币数量。*【如果检测到你已经投过币了，则不会投币】*
* [x] 大会员月底使用快到期的 B币券，给自己充电，一点也不会浪费哦，默认开启。*【可配置】*
* [x] 大会员月初 1 号自动领取每月 5 张 B币券 和福利。
* [x] 每日哔哩哔哩直播自动签到，领取签到奖励。*【直播你可以不看，但是奖励咱们一定要领】*
* [x] 通过server酱推送执行结果到微信。
* [x] Linux用户支持自定义配置了。
* [x] 投币策略更新可配置投币喜好。*【可配置优先给关注的up投币】*

## 使用说明
目前支持两种架构，x86-6和arm64位处理器。
| Architecture | Tag            |
| ------------ | -------------- |
| x86-64       | latest         |
| arm64        | arm64-latest   |


### 获取 Bilibili Cookies**
- 浏览器打开并登录 [bilibili 网站](https://www.bilibili.com/)
- 按 F12 打开 「开发者工具」 找到 应用程序/Application -> 存储 -> Cookies
- 找到 `bili_jct` `SESSDATA` `DEDEUSERID` 三项，并复制值，填写至docker environment中

![20201012001307](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/20201012001307.jpg)

#### 参数说明

| Name       | Value            |
| ---------- | ---------------- |
| PUID |  Linux用户ID（以root用户权限运行填写0） |
| PGID |  Linux组ID（以root用户权限运行填写0）  |
| TZ   | 系统时区（默认上海时区） |
| CUSP   | 自定义配置文件（默认禁用） |
| TASK   | 执行任务的间隔时间（1d表示1天，1h表示1小时） |
| DEDEUSERID | 从 Cookie 中获取 |
| SESSDATA   | 从 Cookie 中获取 |
| BILI_JCT   | 从 Cookie 中获取 |SERVERPUSHKEY
| SERVERPUSHKEY   | 通过server酱推送执行结果到微信(可选项) |

### 运行方式
#### docker-compose  
编辑docker-compose.yml文件，填写对应参数

````
version: "3"
services:
  bilbili-helper:
    image: superng6/bilbili-helper:latest
    container_name: bilbili-helper
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Asia/Shanghai
      - TASK=1d
      - DEDEUSERID=1
      - SESSDATA=2
      - BILI_JCT=3
#     - SERVERPUSHKEY=token
      - CUSP=false
    volumes:
      - /appdata/config:/config
    restart: unless-stopped   
````    

#### 简化版本
推荐不折腾用户使用，填写`bili_jct` `SESSDATA` `DEDEUSERID` 三项即可使用，默认24时执行任务一次
````
docker run -d \
  --name=bilbili-helper \
  -e DEDEUSERID=1 \
  -e SESSDATA=2 \
  -e BILI_JCT=3 \
  -e CUSP=false
  --restart unless-stopped \
  superng6/superng6/bilbili-helper:latest
  ````

### 配置自定义功能
## 修改自定义配置的方法
首先需要开启自定义配置选项`CUSP=true`，`false`会删除删除自定义配置文件  
挂载`/config`后可以直接在`nas/本机`中编辑`/config/config.json`文件，重启容器后生效. 
![Xnip2020-11-23_21-27-51](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/Xnip2020-11-23_21-27-51.jpg)

**配置文件位于 `/config/config.json`**

参数示意

| Key                | Value         | 说明                                                                                                          |
| ------------------ | ------------- | ------------------------------------------------------------------------------------------------------------- |
| numberOfCoins      | [0,5]         | 每日投币数量,默认 5                                                                                           |
| selectLike         | [0,1]         | 投币时是否点赞，默认 0, 0：否 1：是                                                                           |
| ~~watchAndShare~~  | ~~[0,1]~~     | ~~观看时是否分享~~                                                                                            |
| monthEndAutoCharge | [false,true]  | 年度大会员月底是否用 B币券 给自己充电，默认 `true`                                                            |
| devicePlatform     | [ios,android] | 手机端漫画签到时的平台，建议选择你设备的平台 ，默认 `ios`                                                     |
| coinAddPriority    | [0,1]         | 0：优先给热榜视频投币，1：优先给关注的up投币                                                                  |
| userAgent          | 浏览器UA      | 用户可根据部署平台配置，可根据userAgent参数列表自由选取，如果触发了HTTP/1.1 412 Precondition Failed也请修改UA |

userAgent可选参数列表
| 平台      | 浏览器         | userAgent                                                                                                                           |
| --------- | -------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| Windows10 | EDGE(chromium) | Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36 Edg/86.0.622.69 |
| Windows10 | Chrome         | Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.198 Safari/537.36                 |
| masOS     | safari         | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Safari/605.1.15               |
| macOS     | Firefox        | Mozilla/5.0 (Macintosh; Intel Mac OS X 10.12; rv:65.0) Gecko/20100101 Firefox/65.0                                                  |
| macOS     | Chrome         | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/73.0.3683.75 Safari/537.36            |

*ps：如果尝试给关注的 up 投币十次后（保不准你关注的是年更up主），还没完成每日投币任务，则切换成热榜模式，给热榜视频投币*

*投币数量代码做了处理，如果本日投币不能获得经验了，则不会投币，每天只投能获得经验的硬币。假设你设置每日投币 3 个，早上 7 点你自己投了 2 个硬币，则十点半时，程序只会投 1 个）*

# 微信订阅通知

## 订阅执行结果

1. 前往 [sc.ftqq.com](http://sc.ftqq.com/3.version) 点击登入，创建账号（建议使用 GitHub 登录）。
2. 点击点[发送消息](http://sc.ftqq.com/?c=code) ，生成一个 Key。将其增加到 Github Secrets 中，变量名为 `SERVERPUSHKEY`
3. [绑定微信账号](http://sc.ftqq.com/?c=wechat&a=bind) ，开启微信推送。
![serverpush](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/serverpush.png)
4. 推送效果展示
![wechatMsgPush](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/wechatMsgPush.jpg)

## 关于群晖

群晖用户请使用你当前的用户SSH进系统，输入 ``id 你的用户id`` 获取到你的UID和GID并输入进去

![nwmkxT](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/nwmkxT.jpg)



## # Preview
![Xnip2020-11-22_13-56-10](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/Xnip2020-11-22_13-56-10.jpg)
