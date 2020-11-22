# Docker BILIBILI-HELPER Docker | BILIBILI助手
![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/JunzhouLiu/BILIBILI-HELPER?style=flat-square)

## 项目介绍
根据BILIBILI-HELPER项目封装为docker镜像  
https://github.com/JunzhouLiu/BILIBILI-HELPER


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


### 获取 Bilibili Cookies**
- 浏览器打开并登录 [bilibili 网站](https://www.bilibili.com/)
- 按 F12 打开 「开发者工具」 找到 应用程序/Application -> 存储 -> Cookies
- 找到 `bili_jct` `SESSDATA` `DEDEUSERID` 三项，并复制值，填写至docker environment中

![Ig1gTI](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/Ig1gTI.jpg)


| Name       | Value            |
| ---------- | ---------------- |
| DEDEUSERID | 从 Cookie 中获取 |
| SESSDATA   | 从 Cookie 中获取 |
| BILI_JCT   | 从 Cookie 中获取 |

docker-compose  
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
      - CUSP=true
    volumes:
      - /appdata/config:/config
    restart: unless-stopped   
  ````    


### 配置自定义功能

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

## # Preview
![Xnip2020-11-22_13-56-10](https://cdn.jsdelivr.net/gh/SuperNG6/pic@master/uPic/Xnip2020-11-22_13-56-10.jpg)