window系统中，在开启代理的情况下，
git 命令行工具默认不走本机代理，所以clone速度可能会很慢。
可以使用下面步骤进行加速。
1. 确认本地代理的地址和端口，地址一般为 127.0.0.1, 端口号 一般为 1080 或其它自定义端口。
2. 假设本机代理地址为 127.0.0.1:1080, 运行以下git命令,配置代理

```
git config --global http.proxy  socks5://127.0.0.1:1080
git config --global https.proxy socks5://127.0.0.1:1080
```

3. 完成后，使用以下命令，查看配置是否已经生效
```
git config --global --get http.proxy
git config --global --get https.proxy
```
4. 重新使用git clone ，感受速度提升。
