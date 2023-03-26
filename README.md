# Check OpenWrt's DDNS status and start
## 你可能不需要这个脚本

该脚本是为了解决 OpenWrt 的 DDNS 的服务因为一些异常停止后不会自动重启的问题.

实际上解决该问题只需要您使用 [crontab](https://openwrt.org/docs/guide-user/base-system/cron) 加入下面一行命令就可以解决.
> 如果您使用 Luci,那请在 `系统`-`计划任务`添加一行命令,并点击`提交`
```shell
# if DDNS service's name is "my_ddns"
* */1 * * * /usr/lib/ddns/dynamic_dns_updater.sh -S my_ddns start &
# an hour
```
上面这种方式也可以保证对应的 DDNS 服务会在停止后启动.但是对于已启动服务时会上面方法会先停止旧的 DDNS 服务,再启动.


## 这是什么

这个脚本需要配合 OpenWrt 的 DDNS 服务使用.
这个 shell 脚本会检查 DDNS 服务是否还在运行,如果对应服务没有运行,就会手动启动 DDNS 服务.

将该脚本加入计划任务中,可以保证 DDNS 服务一直在运行.

## Why

OpenWrt 的 DDNS 可能会因为网络或者其他原因异常中止,这种情况下不会自动重启服务,需要手动启动 DDNS 服务.

## Usage

1. 下载 check_and_start_ddns.sh 脚本到路由器任意目录
    ```shell
        curl -L -o /usr/share/check_and_start_ddns.sh https://github.com/fooooxxxx/op-check-and-start-ddns/releases/latest/download/check_and_start_ddns.sh
    ```

2. 赋予脚本可执行权限
    ```shell
        chmod +x /usr/share/check_and_start_ddns.sh
    ```

3. 找到配置的 DDNS 服务名称
   - 通过查看配置文件 找到需要启动的 DDNS 服务名称
        ```shell
            cat /etc/config/ddns | grep "config service"
            # output: config service 'my_ddns'
        ```
   - 使用 Luci 界面
        在 `服务`-`DDNS` 中找到需要检查并启动的 DDNS 服务,`配置`列的即为服务名称

4. 试运行脚本 try to run the script
    
    ```shell
        # ./check_and_start_ddns.sh <service_name>
        /usr/share/check_and_start_ddns.sh my_ddns
    ```

5. 添加脚本到 `计划任务` 中去
    [crontab](https://openwrt.org/docs/guide-user/base-system/cron)
    ```shell
        * */2 * * * /usr/share/check_and_start_ddns.sh my_ddns
    ```
## 参考链接

https://openwrt.org/docs/guide-user/services/ddns/client
https://openwrt.org/docs/guide-user/base-system/cron