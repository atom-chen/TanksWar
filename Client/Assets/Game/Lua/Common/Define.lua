-- Define.lua
-- Author : Dzq
-- Date : 2017-05-24
-- Last modification : 2017-05-24
-- Desc: 常量定义类

----模块名
Module = {
	Common = "Common",
	Main = "Main",
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
	MainCtrl = "MainCtrl",
	LoginCtrl = "LoginCtrl",
	LobbyCtrl = "LobbyCtrl",
	SettingCtrl = "SettingCtrl",
	CreateRoomCtrl = "CreateRoomCtrl",
	JoinRoomCtrl = "JoinRoomCtrl",
}

Main_Panel = {
	LoginPanel = "LoginPanel",
	MainPanel = "MainPanel",
	LobbyPanel = "LobbyPanel",
	SettingPanel = "SettingPanel",
	CreateRoomPanel = "CreateRoomPanel",
	JoinRoomPanel = "JoinRoomPanel",
}


--协议类型--
ProtocalType = {
	BINARY = 0,
	PB_LUA = 1,
	PBC = 2,
	SPROTO = 3,
}

AUTO_ORDER_MIN = 100
AUTO_ORDER_MAX = 300

TimeOutSec = 3

IsClient = true