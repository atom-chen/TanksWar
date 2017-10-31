
g_Config = {
	----配置

	--是否不联网
	single = true,
	--配置文件名
	configFileName = "LocalConfig",
	--是否显示debugUI
	bShowDebug = true,

	--登录获取token的地址
	wechatUrl = "http://dev-account.ruimiltd.com:4001/user/loginByOpenIdC",
	guestUrl = "http://dev-account.ruimiltd.com:4001/user/loginByGuestIdC",
	registerUrl = "http://dev-account.ruimiltd.com:4001/user/register",

	--分享配置
	shareFriendsUrl = "https://fir.im/3wum", 	--好友
	shareMomentsUrl = "https://fir.im/3wum",	--朋友圈
	shareTitle = "邀请有好礼！",					--标题
	shareImgUrl = "http://ugame.ruimiltd.com/bozhou/share.png",	--图片地址
	shareSite = "涡阳麻将",
	shareText = "我的邀请码:%s,输入后即可获得奖励哦！",	--分享内容

	gameID = "3",
	packageName = "com.jianyou.ahpg",


}

LoginType = {
	Wechat = "wechat",
	Guest = "guest",
}
