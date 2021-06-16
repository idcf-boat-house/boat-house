# BHOL503 - 讨厌的产品经理之服务器工作流

## 故事背景

- 产品经理向你的小组分配了新的任务，按照这个任务你在服务器上拉取了一个新的分支feature1，你的小组将此分支下载到本地并开始开发新的功能。
- 通过服务器上的feature1分支，小组成员可以开始交换代码并随时解决冲突。
- 小组成员任务代码已经可以提交并开始进行测试，小组成员在服务器上创建从feature1到master分支的拉取请求
- 小组成员开始在拉取请求上进行代码检视，并通过配置分支策略对开发质量进行控制，禁止团队直接向master提交代码
- 此时另外一个小组完成了hotfix分支的拉取请求并将代码合并到了master分支，此操作造成了master分支与feature1分支的代码冲突。
- 通过拉取请求页面的提示，团队成员及时发现了冲突，通过执行反向合并操作(从master->feature1)解决了冲突并继续开发工作。
- 根据拉取请求上提供的反馈，团队继续在feature1上进行开发，直到测试环境中的版本得到确认
- 团队成员完成拉取请求将代码合并到master分支。

## 01 - 在服务器上启用分支保护

分支保护可以确保我们代码库中的某一条分支中的代码一定是通过所设定的策略保护的，在Gitea上通过 仓库设置 ｜ 分支列表 选择 master 分支，进入分支保护策略选项。

![](images/bhol502-server013.png)

为了简化我们的实验流程，我们仅启用 禁用推送 这一个策略，此策略激活以后用户将无法直接推送代码到受保护的分支，确保受保护的分支一定是通过 合并请求 才能进入。

![](images/bhol502-server014.png)

## 02 - 在服务器上创建任务和分支

在 Gitea 服务器的 hello-boathouse 代码库下的【工单】中创建：升级系统到v3 的工单任务

![](images/bhol502-server001.png)

在vscode的terminal中执行以下命令，创建新分支 

```shell
## 确保我们处于master分支
git checkout master
## 创建并切换至feature001分支
git checkout -b feature001
## 设置当前分支的远程上游分支
git push --set-upstream origin feature001
## 推送feature001分支到服务器
git push origin feature001
```

![](images/bhol502-server002.png)

打开刚才创建的工单，将feature001分支绑定到这个工单上。

![](images/bhol502-server003.png)


## 03 - 推送新提交到feature001分支

在vscode中提交如下修改

![](images/bhol502-server004.png)

提交以后，在vscode中选择push，推送代码到服务器

![](images/bhol502-server005.png)

或者也可以使用以下命令完成推送

```shell
git push origin feature001
```

## 04 - 在服务器上创建合并请求，并添加评审意见

在Gitea上创建feature001->master的合并请求

![](images/bhol502-server006.png)

注意这里Gitea提示我们可以使用WIP: 作为标题前缀以便避免合并请求被意外合并

![](images/bhol502-server007.png)

通过【文件改动】页面，在第9行上添加评审意见，你可以使用 @ 符号引用用户，完成后点击【开始评审】，确保我们可以通过评审来跟踪评审意见的解决状态。

![](images/bhol502-server008.png)

提交评审以后可以在【对话内容】中看到评审的状态，团队需要在合并之前解决所有评审意见。

![](images/bhol502-server009.png)

## 05 - 按照评审意见提交修改，并观察评审状态变更

在vscode中对index.js的第9行进行修改，并添加提交说明：C12 - upgrade to v3 on feature001

![](images/bhol502-server010.png)

将以上改动推送到服务器，并再次观察【文件变动】，发现第8，9行均已经发生修改。

![](images/bhol502-server011.png)

现在，我们可以回到【对话内容】视图上点击 “已解决问题” 按钮标识此评审已经通过。

![](images/bhol502-server012.png)

## 06 - 创建hotfix001分支，并提交改动

在vscode的terminal中通过以下命令创建 hotfix001 分支，并提交改动到服务器

注意：此改动与feature001->master的修改冲突

```shell
## 确保我们处于master分支
git checkout master
## 创建并切换至feature001分支
git checkout -b hotfix001
## 设置当前分支的远程上游分支
git push --set-upstream origin hotfix001
## 推送feature001分支到服务器
git push origin hotfix001
```

在vscode中对index.js的第9行进行修改，并提交

![](images/bhol502-server015.png)

推送此改动到服务器，创建 合并请求 并直接完成合并

![](images/bhol502-server016.png)

## 07 - 回到feature001->master的合并请求上，修复冲突

因为hotfix中对index.js第9行的改动与当前的feature001上的改动冲突，这个合并请求会立即提示用户feature001将无法完成合并，这会督促团队尽快解决冲突，避免冲突的遗留造成更多代码合并风险。

![](images/bhol502-server017.png)

此时团队应该采用以下命令获取master分支代码到本地，并将master分支代码反向合并到feature001分支上，以便确保已经集成了hotfix001的内容，这也保证我们未来所发布的版本中不会遗漏hotfix001的代码内容。

```shell
## 确保我们处于feature001分支
git checkout feature001
## 获取服务器上master分支的最新代码
git pull origin master
```

vscode进入代码合并状态

![](images/bhol502-server018.png)

解决代码冲突，并将改动加入Staging状态

![](images/bhol502-server019.png)

完成提交并推送到服务器，推送完成后刷新 合并请求 页面，可以看到冲突提示已经消失。

![](images/bhol502-server020.png)


## 08 - 移除WIP保护，合并feature01到master分支

在合并请求上点击 ”编辑“ 并移除WIP字样

![](images/bhol502-server021.png)

现在我们就可以点击 “合并请求” 按钮将feature001合并进入master分支。

![](images/bhol502-server021.png)

完成合并后我们通过 【提交图】可以跟踪刚才完成的合并过程

![](images/bhol502-server022.png)


## 小结

本节实验中我们完成了一个典型的git服务器工作流程，其中采用了FPR-Flow分支模型，这种分支模型具有简单易用的特点，同时又可以应对非常复杂的开发模式。借助Git服务器的分支保护策略功能，我们可以设定不同的保护策略，确保我们的目标分支一直处于受控状态，不会有未经审核的代码进入。
