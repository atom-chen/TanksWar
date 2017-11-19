-- RoomMgr.lua
-- Author : Dzq
-- Date : 2017-09-28
-- Last modification : 2017-09-28
-- Desc: 阜阳麻将 房间管理类 处理房间内逻辑 各个模块房间不同

local _M = { }

_M.m_roomId = false

_M.m_tableContainer = false
_M.m_roomInfo = false
_M.m_gameInfo = false
_M.m_endInfo = false

_M.curState = PlayState.Ready
_M.cardsInfo = false
_M.curOpt = {}

local this = _M

--初始化模块游戏
function _M.Init(roomInfo)
	log("RoomMgr init ----- ")
	SoundMgr.PlayBG(SoundCfg.fymj_roomBg, true)

	this.SetPlayState(PlayState.Ready)
	Event.Brocast(Msg.ChangeState, _M.curState)

	this.m_roomInfo = roomInfo

	Event.AddListener(tostring(proto.fy_inRoomSE), this.OnPlayerInRoom, this) --玩家进入
	Event.AddListener(tostring(proto.fy_closeRoomSE), this.OnExitRoom, this) --都同意解散
	Event.AddListener(tostring(proto.fy_gameInfoSE), this.OnStartPlay, this) --都做好准备开局
	Event.AddListener(tostring(proto.fy_endGameSE), this.OnEndGame, this) --结算信息

	Event.AddListener(Msg.ShowCardsEnd, this.OnShowCardsEnd, this) --都做好准备开局
	
	-- logWarn("this.m_roomInfo -- "..cjson.encode(this.m_roomInfo))

	Event.Brocast(Msg.RoomInfoUpdate, this.m_roomInfo)

	PlayerMgr.OnEnterRoom()

	local ctrl = CtrlMgr.Get(FYMJ_Ctrl.TableCtrl)
	ctrl:LoadEnd()

	if not this.m_roomInfo then
		util.LogError("初始化房间错误 传入参数空--")
		return
	end

	local panel = UIMgr.Get(FYMJ_Panel.TablePanel)
	
	panel:SetRoomId(this.m_roomInfo.roomId)

	local myself = PlayerMgr.GetMyself()
	--初始化牌桌内玩家
	local infoList = this.m_roomInfo.players
	log("玩家个数-- "..#infoList)
	for i=1, #infoList do
		local info = infoList[i]
		if not PlayerMgr.IsMyself(info.userId) then
			local player = PlayerMgr.AddOtherPlayer(info.userId, info)
			player:EnterRoom()
		else
			myself:UpdateInfo(info)
			myself:EnterRoom()
		end
	end

	--更新完玩家信息 要更新界面
	local pList = PlayerMgr.GetAll()
	for id, v in pairs(pList) do
		ctrl:UpdatePlayerInfo(v)
	end

	--如果在房间内并且在游戏中 请求牌局 
	if Game.IsReconnect and this.m_roomInfo.gaming == 1 then
		coroutine.start(function()
			local res = NetWork.Request(proto.fy_gameInfo)
			if res.code == 0 then
				-- log("请求牌局信息")
				--协程里报错打印不出信息
				local ok, err = pcall( function() 
					this:OnStartPlay(res.data)
					end)
				if not ok then 
				    util.LogError(" err -- "..tostring(err))
				end
				-- this:OnStartPlay(res.data)
			else
				UIMgr.Open(Common_Panel.TipsPanel, res.msg)
			end
		end)
	else
		this.SetPlayState(PlayState.Ready)
	end

end

function this:OnEndGame(tbl)
	log("this.OnEndGame---")
	-- {"d":{"an":{"19072":{},"43435":{},"93746":{},"20631":{}},"hu":{"19072":{},"43435":{},"93746":{},"20631":{}},
	-- "chi":{"19072":{},"43435":{},"93746":{},"20631":{}},"banker":20631,"score":{"19072":{},"43435":{},"93746":{},"20631":{}},
	-- "zimo":{"19072":{},"43435":{},"93746":{},"20631":{}},"gong":{"19072":{},"43435":{},"93746":{},"20631":{}},
	-- "used":{"19072":[20,56,51,35,54,40,41,21,54,53,38,67,38,55,38,23,70,71,39,21],
	-- "43435":[66,20,51,21,39,70,37,41,36,65,68,21,40,24,57,24,65,49,55,68,69,50],
	-- "93746":[37,18,57,22,25,57,55,67,17,66,68,49,41,22,23,20,69,69,17,69],
	-- "20631":[67,56,66,70,65,36,54,25,33,18,41,18,20,67,56,52,53,39,52,36,38,71]},
	-- "jie":{"19072":{},"43435":{},"93746":{},"20631":{}},"hand":{"19072":[49,50,24,37,19,52,66,37,50,19,56,51,35],
	-- "43435":[19,35,53,71,23,71,22,54,52,51,70,36,65],"93746":[33,33,24,40,33,25,19,34,35,18,25,57,68],
	-- "20631":[22,23,49,17,50,39,53,55,17,40]},"peng":{"19072":{},"43435":{},"93746":{},"20631":[34]}},"r":215}


	_M.m_endInfo = tbl

	coroutine.start(function()
		coroutine.wait(5)
		Event.Brocast(Msg.OnEndShow, tbl)
		UIMgr.Open(FYMJ_Panel.EndPanel)

		local pList = PlayerMgr.GetAll()
		for k,v in pairs(pList) do
			local handCon = v:GetContainer(ContainerType.HAND)
			handCon:Init(tbl.hand[tostring(k)])
			handCon:SortItem()
			handCon:Fresh()
			handCon:OpenCard()
		end
	end)
end

function this.InitTableView()
	-- log("初始化牌桌显示 剩余牌")
	this.m_tableContainer = TableContainer.New(find("tableCard"))
	this.m_tableContainer:Init(GYMJ_Cards_Num)
	this.m_tableContainer:SetBankerSit(PlayerSit.Up)
	this.m_tableContainer:SetDiceNum(3)
end

function this.InitCards(cardsInfo)
	this.cardsInfo = cardsInfo
	if not this.cardsInfo then
		log("InitCards 传入数据空")
		return
	end

	local anCardsInfo = this.cardsInfo.an
	local chiCardsInfo = this.cardsInfo.chi
	local gongCardsInfo = this.cardsInfo.gong
	local handCardsInfo = this.cardsInfo.hand
	local pengCardsInfo = this.cardsInfo.peng
	local jieCardsInfo = this.cardsInfo.jie
	local hlenInfo = this.cardsInfo.hlen 	--手牌数量相关

	local pList = PlayerMgr.GetAll()
	for id, v in pairs(pList) do
		local cardsData = {}
		cardsData.putCards = {}
		cardsData.chiCards = {}

		local handNum = 13

		local k = tostring(id)
		--组碰牌
		if pengCardsInfo[k] then
			for i=1, #pengCardsInfo[k] do
				local cardNum = pengCardsInfo[k][i]
				local c = {
					cards = {cardNum, cardNum, cardNum},
					showType = CardShowType.PENG,
					otherId = 3,
				}
				cardsData.chiCards[#cardsData.chiCards+1] = c
			end
		end

		--组吃牌
		if chiCardsInfo[k] then
			for i=1, #chiCardsInfo[k] do
				local c = {
					cards = chiCardsInfo[k][i],
					showType = CardShowType.CHI,
					otherId = 3,
				}
				cardsData.chiCards[#cardsData.chiCards+1] = c
			end
		end

		--组杠牌 暗杠
		if anCardsInfo[k] then
			for i=1, #anCardsInfo[k] do
				local cardNum = anCardsInfo[k][i]
				local c = {
					cards = {cardNum, cardNum, cardNum, cardNum},
					showType = CardShowType.ANGANG,
					otherId = 3,
				}
				cardsData.chiCards[#cardsData.chiCards+1] = c
			end
		end

		--公杠
		if gongCardsInfo[k] then
			for i=1, #gongCardsInfo[k] do
				local cardNum = gongCardsInfo[k][i]
				local c = {
					cards = {cardNum, cardNum, cardNum, cardNum},
					showType = CardShowType.MINGGANG,
					otherId = 3,
				}
				cardsData.chiCards[#cardsData.chiCards+1] = c
			end
		end
		--接杠
		if jieCardsInfo[k] then
			for i=1, #jieCardsInfo[k] do
				local cardNum = jieCardsInfo[k][i]
				local c = {
					cards = {cardNum, cardNum, cardNum, cardNum},
					showType = CardShowType.MINGGANG,
					otherId = 3,
				}
				cardsData.chiCards[#cardsData.chiCards+1] = c
			end
		end
		
		if handCardsInfo[k] then
			cardsData.handCards = handCardsInfo[k]
		else
			--计算出其他人手牌个数
			cardsData.handCards = hlenInfo[k]
		end
		_M.curOpt = this.cardsInfo.operate

		v:InitCards(cardsData)

	end
end

function this.GetTableContainer()
	return this.m_tableContainer
end

function this.GetCurOpt()
	return _M.curOpt
end

--房主
function this.GetRoomOwnerId()
	return this.m_roomInfo.owner
end

function this.PlayTableAni()
end

function this:OnPlayerInRoom(tbl)
	local otherPlayer = PlayerMgr.AddOtherPlayer(tbl.user.userId, tbl.user)
	local ctrl = CtrlMgr.Get(FYMJ_Ctrl.TableCtrl)
	ctrl:AddPlayer(otherPlayer)
end

function this:OnStartPlay(tbl)

	this.SetPlayState(PlayState.Playing)
	this.m_gameInfo = tbl
	this.InitTableView()
	this.InitCards(this.m_gameInfo)

	--播放牌桌动画		
	this.m_tableContainer:ShowUpAni()
	Event.Brocast(Msg.GameInfoUpdate, this.m_gameInfo)
	Event.Brocast(Msg.ShowCardsStart, true)

	coroutine.start(function() 
		coroutine.wait(ViewCfg.TableUpTime)
		--初始化牌 播放发牌动画
		local pList = PlayerMgr.GetAll()
		for id, v in pairs(pList) do
			local handCon
			if v:IsMyself() then
				handCon = v:GetContainer(ContainerType.SELF)
			else
				handCon = v:GetContainer(ContainerType.HAND)
			end
			if true then	--判断是否断线重连 非断线重连 走这里
				this.m_gameInfo.lastCardNum = fyCfg.cardTotalNum	--非断线要有发牌动画 这里应该是所有牌
				-- logWarn("this.m_gameInfo -- "..cjson.encode(this.m_gameInfo))
				handCon:OnShowCards(true)
			else

			end
		end	
	end)			
end

-- 发牌动画结束 在进行之后的操作
function this:OnShowCardsEnd(tbl)
	--发送开始游戏消息
	-- logWarn("发送开始游戏消息-----".._M.curState)
	
	this.SetPlayState(PlayState.Playing)

	if next(this.curOpt) then
		-- log("广播操作消息 --- "..cjson.encode(this.curOpt))
		Event.Brocast(tostring(proto.fy_operateSE), this.curOpt)
	end
end

function this.CreateRoom(roomId)
	m_roomId = roomId
end

function this.GetRoomID()
	return m_roomId
end

function this.SetPlayState(state)
	_M.curState = state
	Event.Brocast(Msg.ChangeState, _M.curState)
end

function this.OnExitRoom()

	local pList = PlayerMgr.GetAll()
	for _, v in pairs(pList) do
		v:LeaveRoom()
		if not v:IsMyself() then	--非自己清除
			PlayerMgr.RemovePlayer(v)
		end
	end

	PlayerMgr.OnLeaveRoom()

	coroutine.start(function ()
		local coLoad = coroutine.start(Game.CoLoadModule, Module.Main)
		coroutine.waitCo(coLoad)
		local data = {}
		data.isBackLobby = true
		Game.OnLoadFinish(data)
		-- Event.Brocast(Msg.EnterRoom)
	end)


	Event.RemoveListener(tostring(proto.fy_inRoomSE), this.OnPlayerInRoom) --玩家进入
	Event.RemoveListener(tostring(proto.fy_closeRoomSE), this.OnExitRoom) --都同意解散
	Event.RemoveListener(tostring(proto.fy_gameInfoSE), this.OnStartPlay) --都做好准备开局
	Event.RemoveListener(tostring(proto.fy_endGameSE), this.OnEndGame) --都做好准备开局

end

_G["RoomMgr"] = _M