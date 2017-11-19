return {
	---------- 大厅和用户相关 --------

	-- 首次连接
	login = 1,
	-- 请求用户信息
	userInfo = 2,
	-- 查看游戏、支付等开关
	switch = 3,
	-- 绑定邀请人
	bind = 4,
	-- 进行实名认证
	realname = 5,
	-- 查询已邀请人的列表
	myInvitation = 6,
	-- 反馈
	feedback = 7,
	-- 返回错误信息
	err = 8,
	-- 心跳包
	heart = 9,
	forceDepart = 11,
	-- 加入房间
	joinRoom = 12,
	-- 推送玩家信息
	userInfoSE = 13,
	-- 设置下用于发牌的底牌
	setNextLineCard = 14,
	-- 客户端发什么，直接返回什么
	autoReturn = 15,

	----------- 涡阳麻将 ------------
	gy_createRoom = 101,
	gy_inRoom = 102,
	gy_reciveReady = 103,
	gy_reciveLeave = 104,
	gy_ready = 105,
	gy_offline = 107,
	gy_online = 108,
	gy_closeRoom = 109,
	gy_startInfo = 110,
	gy_action = 111,
	gy_effAction = 112,
	gy_operate = 113,
	gy_gameInfo = 114,
	gy_endGame = 115,
	gy_leaveRoom = 116,
	gy_applyDepart = 117,
	gy_respondDepart = 118,
	gy_chat = 119,
	gy_reciveChat = 120,
	gy_reciveApplyDepart = 121,
	gy_reciveRespondDepart = 122,


	----------- 阜阳麻将 ------------
	fy_createRoom = 201,
	fy_inRoomSE = 202,
	fy_readySE = 203,
	fy_leaveSE = 204,
	fy_ready = 205,
	fy_offlineSE = 207,
	fy_onlineSE = 208,
	fy_closeRoomSE = 209,
	fy_gameInfoSE = 210,
	fy_action = 211,
	fy_actionSE = 212,
	fy_operateSE = 213,
	fy_gameInfo = 214,
	fy_endGameSE = 215,
	fy_leave = 216,
	fy_applyDepart = 217,
	fy_respondDepart = 218,
	fy_chat = 219,
	fy_chatSE = 220,
	fy_respondDepartSE = 222
}
