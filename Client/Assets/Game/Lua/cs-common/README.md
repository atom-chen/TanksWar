# 客户端服务端协议通用模块

## 数据包压缩和解压

当前使用了 msgpack 来进行消息的压缩和解压，具体 api 请见： message.lua

## 协议约定

### login

首次连接

```
{
	token = "dfocvjpaojder32sdfaew5adsfadf"
}
```

### userInfo

查询当前用户信息


### s_userInfo

返回用户信息

```
{
	userId = 423423,
	nick = "234234234",
	parentId = 877833
}
```








### err 

返回错误信息

```
{
	code = 2
}
```

其中 code 对应的含义如下：

- 1 
- 2
- 3
- 4 房间号已经用完了，无法再创建新的房间