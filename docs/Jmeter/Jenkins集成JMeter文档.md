**Boat-house**

**Jenkins集成Jmeter手册**

1. 1、上传jmx文件

在项目根目录下创建文件夹jmeter，并将测试人员提供的jmx文件放置到该文件夹中。

如图：

![](images/Jmeter-16.png)

1. 2、流水线添加jmeter操作步骤

在项目的Jenkinsfile文件中，添加jmeter测试的stage，代码如下：

![](images/Jmeter-17.png)

1. 3、正常执行pipeline

![](images/Jmeter-18.png)

1. 4、查看报告

 ![](images/Jmeter-19.png)
 
 ![](images/Jmeter-20.png)
