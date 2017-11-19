-- Define.lua
-- Author : Dzq
-- Date : 2017-05-24
-- Last modification : 2017-05-24
-- Desc: 常量定义类

----模块名
Module = {
	Common = "Common",
	Main = "Main",
	FYMJ = "FYMJ",
	GYMJ = "GYMJ",
}

----模块脚本
ModuleScript = {
	Common = {"Card", "SelfContainer", "ChiContainer", "HandContainer", "PutContainer", "TableContainer"},
	Main = {"Player"},
	GYMJ = {"RoomMgr", "PlayerOther",},
	FYMJ = {"RoomMgr", "PlayerOther",},
}

----模块场景
ModuleScene = {
	Main = "",
	GYMJ = "GYMJ",
	FYMJ = "FYMJ",
}

----通用界面相关
Common_Ctrl = {
	TipsCtrl = "TipsCtrl",
	NoticeCtrl = "NoticeCtrl",
	MsgCtrl = "MsgCtrl",
	WaitCtrl = "WaitCtrl",
}

Common_Panel = {
	TipsPanel = "TipsPanel",
	NoticePanel = "NoticePanel",
	MsgPanel = "MsgPanel",
	WaitPanel = "WaitPanel",
}

----主界面相关配置
Main_Ctrl = {
	MainCtrl			 = 		 "MainCtrl",
	LoginCtrl			 = 		 "LoginCtrl",
	LobbyCtrl			 = 		 "LobbyCtrl",
	SettingCtrl			 = 		 "SettingCtrl",
	CreateCtrl		 	 = 		 "CreateCtrl",
	JoinCtrl		 	 = 		 "JoinCtrl",
    HelpCtrl			 = 		 "HelpCtrl",
    CertificateCtrl		 = 		 "CertificateCtrl",
    InviteCtrl	 		 = 		 "InviteCtrl",
    ReferrerCtrl		 = 		 "ReferrerCtrl",
    ActivityCtrl		 = 		 "ActivityCtrl",
    ShareCtrl			 = 		 "ShareCtrl",
    ShopCtrl			 = 		 "ShopCtrl",
}

Main_Panel = {
	LoginPanel			 =		 "LoginPanel",
	MainPanel			 =		 "MainPanel",
	LobbyPanel			 =		 "LobbyPanel",
	SettingPanel		 =		 "SettingPanel",
	CreatePanel			 =		 "CreatePanel",
	JoinPanel			 =		 "JoinPanel",
	HelpPanel			 =		 "HelpPanel",
	CertificatePanel	 =		 "CertificatePanel",
	InvitePanel			 =		 "InvitePanel",
	ReferrerPanel		 =		 "ReferrerPanel",
	ActivityPanel		 =		 "ActivityPanel",
	SharePanel			 =		 "SharePanel",
    ShopPanel			 =		 "ShopPanel",
}

--------------------------------------------------------------------------
----涡阳麻将相关配置
GYMJ_Ctrl = {
	GYMJCtrl = "GYMJCtrl",
	PromptCtrl = "PromptCtrl",
	MessageCtrl = "MessageCtrl",
	LoginCtrl = "LoginCtrl",
	LobbyCtrl = "LobbyCtrl",
}

GYMJ_Panel = {
	PromptPanel = "PromptPanel",	
	MessagePanel = "MessagePanel",
	LoginPanel = "LoginPanel",
	LobbyPanel = "LobbyPanel",
}

--------------------------------------------------------------------------

--------------------------------------------------------------------------
----阜阳麻将相关配置
FYMJ_Ctrl = {
	FYMJCtrl = "FYMJCtrl",
	TableCtrl = "TableCtrl",
	EndCtrl = "EndCtrl",
}

FYMJ_Panel = {
	FYMJPanel = "FYMJPanel",
	TablePanel = "TablePanel",
	EndPanel = "EndPanel",
}

--------------------------------------------------------------------------

--协议类型--
ProtocalType = {
	BINARY = 0,
	PB_LUA = 1,
	PBC = 2,
	SPROTO = 3,
}

--平台类型--
Platform = {
	Android = false,
	Iphone = false,
	Editor = false,
}

--玩家座位
PlayerSit = {
	None = 0,	--无
	Bottom = 1,	--下
	Right = 2,	--右
	Up = 3,		--上
	Left = 4,	--左
}

--牌状态 -- 摸牌和亮牌都需要动画 放着状态里做比较麻烦 发出的牌方向不一致
CardState = {
	Normal = 0, --常规
	Select = 1, --选中
	Lock = 2,	--禁用
}

--游戏状态
PlayState = {
	Ready = 0,
	Playing = 1,
	Dealing = 2,
	End = 3,
}

Operation = {
	MO	 	= { name = "mo",	 time = 0.8, },
	CHU	 	= { name = "chu",	 time = 0, },
	CHI	 	= { name = "chi",	 time = 0.8, },
	PENG	= { name = "peng",	 time = 0.8, },
	AN	 	= { name = "an",	 time = 0.8, },
	JIE	 	= { name = "jie",	 time = 0.8, },
	GONG	= { name = "gong",	 time = 0.8, },
	HU	 	= { name = "hu",	 time = 0, },
	GUO	 	= { name = "guo",	 time = 0.8, },
	TING	= { name = "ting",	 time = 0.8, },
}

--cardsContainer type
ContainerType = {
	NONE = 0,
	HAND = 1,
	PUT = 2,
	CHI = 3,
	TABLE = 4,
	SELF = 5,	--自己摆在桌上的手牌
}

--cardShowType
CardShowType = {
	NONE = 0,
	CHI = 1,
	PENG = 2,
	ANGANG = 3,
	MINGGANG = 4,
}

PlatformType = {
	Unknown = 0,
	SinaWeibo = 1,			--Sina Weibo         
	TencentWeibo = 2,		--Tencent Weibo          
	DouBan = 5,				--Dou Ban           
	QZone = 6, 				--QZone           
	Renren = 7,				--Ren Ren           
	Kaixin = 8,				--Kai Xin          
	Pengyou = 9,			--Friends          
	Facebook = 10,			--Facebook         
	Twitter = 11,			--Twitter         
	Evernote = 12,			--Evernote        
	Foursquare = 13,		--Foursquare      
	GooglePlus = 14,		--Google+       
	Instagram = 15,			--Instagram      
	LinkedIn = 16,			--LinkedIn       
	Tumblr = 17,			--Tumblr         
	Mail = 18, 				--Mail          
	SMS = 19,				--SMS           
	Print = 20, 			--Print       
	Copy = 21,				--Copy             
	WeChat = 22,		    --WeChat Friends    
	WeChatMoments = 23,	    --WeChat WechatMoments   
	QQ = 24,				--QQ              
	Instapaper = 25,		--Instapaper       
	Pocket = 26,			--Pocket           
	YouDaoNote = 27, 		--You Dao Note           
	Pinterest = 30, 		--Pinterest    
	Flickr = 34,			--Flickr          
	Dropbox = 35,			--Dropbox          
	VKontakte = 36,			--VKontakte       
	WeChatFavorites = 37,	--WeChat Favorited        
	YiXinSession = 38, 		--YiXin Session   
	YiXinTimeline = 39,		--YiXin Timeline   
	YiXinFav = 40,			--YiXin Favorited  
	MingDao = 41,          	--明道
	Line = 42,             	--Line
	WhatsApp = 43,         	--Whats App
	KakaoTalk = 44,         --KakaoTalk
	KakaoStory = 45,        --KakaoStory 
	FacebookMessenger = 46, --FacebookMessenger
	Bluetooth = 48,         --Bluetooth
	Alipay = 50,            --Alipay
	AlipayMoments = 51,     --AlipayMoments
	Dingding = 52,			--DingTalk 钉钉
	Youtube = 53,			--youtube
	MeiPai = 54,			--美拍

}

AUTO_ORDER_MIN = 100
AUTO_ORDER_MAX = 300

GYMJ_Cards_Num = 108

TimeOutSec = 5

IsClient = true