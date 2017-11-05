-- RoomMgr.lua
-- Author : Dzq
-- Date : 2017-09-28
-- Last modification : 2017-09-28
-- Desc: 阜阳麻将 房间管理类 处理房间内逻辑 各个模块房间不同

local _M = { }

_M.m_roomId = false

_M.m_tableContainer = false
_M.m_info = false

_M.curState = PlayState.Ready
_M.cardsInfo = false
_M.curOpt = {}

local this = _M

--初始化模块游戏
function _M.Init(roomInfo)
	log("RoomMgr init ----- ")

	_M.curState = PlayState.Ready
	Event.Brocast(Msg.ChangeState, _M.curState)

	this.m_info = roomInfo

	Event.AddListener(tostring(proto.fy_inRoomSE), this.OnPlayerInRoom, this) --玩家进入
	Event.AddListener(tostring(proto.fy_closeRoomSE), this.OnExitRoom, this) --都同意解散
	Event.AddListener(tostring(proto.fy_gameInfoSE), this.OnStartPlay, this) --都做好准备开局
	Event.AddListener(tostring(proto.fy_endGameSE), this.OnEndGame, this) --都做好准备开局

	Event.Brocast(Msg.RoomInfoUpdate, this.m_info)

	PlayerMgr.OnEnterRoom()

	local ctrl = CtrlMgr.Get(FYMJ_Ctrl.TableCtrl)
	ctrl:LoadEnd()

	if not this.m_info then
		util.LogError("初始化房间错误 传入参数空--")
		return
	end

	local panel = UIMgr.Get(FYMJ_Panel.TablePanel)
	
	panel:SetRoomId(this.m_info.roomId)

	local myself = PlayerMgr.GetMyself()
	--初始化牌桌内玩家
	local infoList = this.m_info.players
	-- log("玩家个数-- "..#infoList)
	for i=1, #infoList do
		local info = infoList[i]
		if not PlayerMgr.IsMyself(info.userId) then
			local player = PlayerMgr.AddOtherPlayer(info.userId, info)
			ctrl:AddPlayer(player)
			player:EnterRoom()
		else
			myself:UpdateInfo(info)
			myself:EnterRoom()
		end
	end

	--如果在房间内并且在游戏中 请求牌局 
	if Game.IsReconnect and this.m_info.gaming == 1 then
		coroutine.start(function()
		    local res = NetWork.Request(proto.fy_gameInfo)
		    if res.code == 0 then
		    	log("请求牌局信息")
		    	--协程里报错打印不出信息
		    	local ok, err = pcall( function() 
		    		this:OnStartPlay(res.data)
		    		end)
		    	if not ok then 
		    	    util.LogError(" err -- "..tostring(err))
		    	end
		    	
		    else
		        UIMgr.Open(Common_Panel.TipsPanel, res.msg)
		    end
		end)
	end
end

function this:OnEndGame(tbl)
	log("this.OnEndGame---")
	UIMgr.Open(Common_Panel.TipsPanel, "本局结束，显示结算界面")
end

function this.InitTableView()
	log("初始化牌桌显示 剩余牌")
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

	local pList = PlayerMgr.GetAll()
	for id, v in pairs(pList) do
		local cardsData = {}
		cardsData.putCards = {}
		cardsData.chiCards = {}

		local handNum = 13

		local k = tostring(id)
		--组碰牌
		if pengCardsInfo[k] then
			handNum = handNum - #pengCardsInfo[k]
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
			handNum = handNum - #chiCardsInfo[k]
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
			handNum = handNum - #anCardsInfo[k]
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
			handNum = handNum - #gongCardsInfo[k]
			for i=1, #gongCardsInfo[k] do
				local cardNum = gongCardsInfo[k][i]
				local c = {
					cards = {cardNum, cardNum, cardNum, cardNum},
					showType = CardShowType.GONGGANG,
					otherId = 3,
				}
				cardsData.chiCards[#cardsData.chiCards+1] = c
			end
		end
		--接杠
		if jieCardsInfo[k] then
			handNum = handNum - #jieCardsInfo[k]
			for i=1, #jieCardsInfo[k] do
				local cardNum = jieCardsInfo[k][i]
				local c = {
					cards = {cardNum, cardNum, cardNum, cardNum},
					showType = CardShowType.GONGGANG,
					otherId = 3,
				}
				cardsData.chiCards[#cardsData.chiCards+1] = c
			end
		end
		
		if handCardsInfo[k] then
			cardsData.handCards = handCardsInfo[k]
		else
			--计算出其他人手牌个数
			-- log("计算出userid: "..k..'  手牌个数：'..handNum)
			cardsData.handCards = handNum
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
	return this.m_info.owner
end

function this:OnPlayerInRoom(tbl)
	local otherPlayer = PlayerMgr.AddOtherPlayer(tbl.user.userId, tbl.user)
	local ctrl = CtrlMgr.Get(FYMJ_Ctrl.TableCtrl)
	ctrl:AddPlayer(otherPlayer)
end

function this:OnStartPlay(tbl)
	-- util.Log("StartPlay ----- ")
	_M.curState = PlayState.Playing

	this.InitTableView()
	this.InitCards(tbl)

	local ctrl = CtrlMgr.Get(FYMJ_Ctrl.TableCtrl)

	local pList = PlayerMgr.GetAll()
	for id, v in pairs(pList) do
		local handCon = v:GetContainer(ContainerType.HAND)
		if true then	--判断是否断线重连 非断线重连 走这里
			tbl.lastCardNum = fyCfg.cardTotalNum	--非断线要有发牌动画 这里应该是所有牌
			-- ctrl:SetCardNum(fyCfg.cardTotalNum)
			handCon:OnShowCards(true)
		else

		end
	end


	ctrl:StartPlay()
	Event.Brocast(Msg.ChangeState, _M.curState)
	Event.Brocast(Msg.RoomInfoUpdate, tbl)

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