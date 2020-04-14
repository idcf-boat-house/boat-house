1. 访问 https://github.com/settings/applications/new，

    填写 
    Application name: mattermost

    Homepage URL: https://github.com/mattermost/mattermost-plugin-github

    Authorization callback URL：https://your-mattermost-url.com/plugins/github/oauth/complete
    ![mattermost_1](../images/mattermost_github_01.png)

2. 复制对应的数据到对应的框中，“Save”
    ![mattermost_1](../images/mattermost_github_02.png)
3. 进入你的rep，“settings” >> 点击"Add webhook" >> 填写 

     ![mattermost_1](../images/mattermost_github_03.png)

    选择 Let me select individual events

    勾选

    Issues, Issue comments, Pull requests, Pull request reviews, Pull request review comments, Pushes, Branch or Tag creation, Branch or Tag deletion
     ![mattermost_1](../images/mattermost_github_04.png)

4. 输入 /github connect，输入github账号和密码
     ![mattermost_1](../images/mattermost_github_05.png)
    输入github 注册邮箱收到的Verification code
     ![mattermost_1](../images/mattermost_github_06.png)
    ![mattermost_1](../images/mattermost_github_07.png)

    点击 “Authorize ******”
    ![mattermost_1](../images/mattermost_github_08.png)
    /github me 显示当前账号的信息
    /git todo 待完成工作列表
     ![mattermost_1](../images/mattermost_github_09.png)

参考：https://github.com/mattermost/mattermost-plugin-github

