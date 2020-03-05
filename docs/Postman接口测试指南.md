# Postman接口测试指南

### Postman安装

1. 应用程序
- 软件下载安装地址：
https://www.postman.com/
- 下载完毕后安装到PC:
![image.png](images/postman-api-01.png)
2. 浏览器
- [Chrome应用市场安装Postman](https://chrome.google.com/webstore/detail/postman/fhbjgbiflinjbdggehcddcbncdddomop/related?hl=en)
![image.png](images/postman-api-02.png)
![image.png](images/postman-api-04.png)
- [Firefox应用市场安装Postwoman](https://addons.mozilla.org/zh-CN/firefox/addon/postwoman/?src=search)
![image.png](images/postman-api-03.png)
![image.png](images/postman-api-05.png)

### 接口示例

此指南将使用 Boat House Product-Service 中的菜品分类功能块来进行接口测试，包含 CRUD 四个方法，方法详情见如下swagger ui:
![image.png](images/postman-api-06.png)

1. Create:
![image.png](images/postman-api-07.png)
1. Get List:
![image.png](images/postman-api-08.png)
1. Update:
![image.png](images/postman-api-09.png)
1. Delete:
![image.png](images/postman-api-10.png)

### 应用程序调用

1. 打开Postman应用，点击新建 Request 请求
![image.png](images/postman-api-11.png)
1. 请求方法选择对应的，此处测试添加功能，因此选择POST，同时从swagger ui中找到url地址：
![image.png](images/postman-api-12.png)
![image.png](images/postman-api-15.png)
1. 选择Request Body，使用raw的方式填写，并选择数据类型为Json，填写 Request Body Json 字符串
![image.png](images/postman-api-13.png)
1. 点击发送，查看 Response 结果：200代表请求成功
![image.png](images/postman-api-14.png)
1. 新建一个Get Request，获取所有的当前添加的结果：
![image.png](images/postman-api-16.png)
![image.png](images/postman-api-17.png)
![image.png](images/postman-api-18.png)

添加成功！

### 浏览器插件调用

以上我们已经使用Postman应用程序做了 Create/Get 请求的接口测试，接下来使用浏览器插件调用 Put/Delete 请求：

1. Put:
![image.png](images/postman-api-19.png)
![image.png](images/postman-api-20.png)
查看结果，修改成功：
![image.png](images/postman-api-21.png)
2. Delete:
![image.png](images/postman-api-22.png)
查看结果，删除成功：
![image.png](images/postman-api-23.png)