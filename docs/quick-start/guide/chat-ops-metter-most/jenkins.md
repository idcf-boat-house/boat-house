
1. 在mattermost中进行配置
    ![mattermost_1](../images/mattermost_jenkins_1.png)

2. 在jenkins中进行配置

    安装mattermost插件，主菜单 >> Manage Jenkins >> 选择“Mange Plugins” >> Available >> 选择“Mattermost Notification Plugin” >> 点击“Install without restart”按钮
    ![mattermost_1](../images/mattermost_jenkins_2.png)

    点击用户名，进入后点击左侧菜单中的Configure，在Current token中输入Mattermost生成的私钥，点击“Add new token”生成token
    ![mattermost_1](../images/mattermost_jenkins_3.png)

3. 转到用户聊天界面，创建一个频道“Jenkins-CI-CD”
    输入 /jenkins connect <username> <token>

    ![mattermost_1](../images/mattermost_jenkins_4.png)

参考资料：https://github.com/mattermost/mattermost-plugin-jenkins