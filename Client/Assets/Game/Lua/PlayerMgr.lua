-- PlayerMgr.lua
-- Author : Dzq
-- Date : 2017-08-29
-- Last modification : 2017-08-29
-- Desc: Player管理类

module(..., package.seeall)

local playerList = {};	--控制器列表--
local modName = ""
local mySelf = false	--自己--

actList = {}
curActTime = 0
startActTime = 0

function CoInit(mdName)
	modName = mdName

	log("PlayerMgr 初始化")

end

--------------------------------------------------------消息相关-------------------------------------------

function OnEnterRoom()
	if modName == Module.FYMJ then
		Event.AddListener(tostring(proto.fy_readySE), Ready)
		Event.AddListener(tostring(proto.fy_leaveSE), Leave)
		Event.AddListener(tostring(proto.fy_offlineSE), Offline)
		Event.AddListener(tostring(proto.fy_onlineSE), OnLine)
		Event.AddListener(tostring(proto.fy_actionSE), Action)
		Event.AddListener(tostring(proto.fy_operateSE), Operate)
		Event.AddListener(tostring(proto.fy_chatSE), Chat)
		Event.AddListener(tostring(proto.fy_respondDepartSE), RespondDeaprt)
	end
end

function OnLeaveRoom()
	if modName == Module.FYMJ then
		Event.RemoveListener(tostring(proto.fy_readySE), Ready)
		Event.RemoveListener(tostring(proto.fy_leaveSE), Leave)
		Event.RemoveListener(tostring(proto.fy_offlineSE), Offline)
		Event.RemoveListener(tostring(proto.fy_onlineSE), OnLine)
		Event.RemoveListener(tostring(proto.fy_actionSE), Action)
		Event.RemoveListener(tostring(proto.fy_operateSE), Operate)
		Event.RemoveListener(tostring(proto.fy_chatSE), Chat)
		Event.RemoveListener(tostring(proto.fy_respondDepartSE), RespondDeaprt)
	end
end

function Ready(tbl)
	local p = Get(tbl.userId)
	if not p then
		logError("Ready 没找到玩家-userId-"..tostring(tbl.userId))
		return
	end
	p:OnReady(tbl)
	Event.Brocast(Msg.PlayerInfoUpdate, p)
end

function Leave(tbl)
	local p = Get(tbl.userId)
	if not p then
		logError("Leave 没找到玩家-userId-"..tostring(tbl.userId))
		return
	end
	p:OnLeave(tbl)
	Event.Brocast(Msg.PlayerInfoUpdate, p)
end

function Offline(tbl)
	local p = Get(tbl.userId)
	if not p then
		logError("Offline 没找到玩家-userId-"..tostring(tbl.userId))
		return
	end
	p:OnOffline(tbl)
	Event.Brocast(Msg.PlayerInfoUpdate, p)
end

function OnLine(tbl)
	local p = Get(tbl.userId)
	if not p then
		logError("OnLine 没找到玩家-userId-"..tostring(tbl.userId))
		return
	end
	p:OnOnLine(tbl)
	Event.Brocast(Msg.PlayerInfoUpdate, p)
end

function Chat(tbl)
	local p = Get(tbl.userId)
	if not p then
		logError("Chat 没找到玩家-userId-"..tostring(tbl.userId))
		return
	end
	p:OnChat(tbl)	
end

function RespondDeaprt(tbl)
	local p = Get(tbl.userId)
	if not p then
		logError("RespondDeaprt 没找到玩家-userId-"..tostring(tbl.userId))
		return
	end
	p:OnRespondDeapr(tbl)	
end


function Action(tbl)
	local p = Get(tbl.userId)
	if not p then
		logError("Action 没找到玩家-userId-"..tostring(tbl.userId))
		return
	end

	local act = {}
	act.optType = "action"
	act.name = tbl.opt
	act.data = tbl
	act.target = p
	actList[#actList+1] = act

	p:OnAction(tbl)
	-- logWarn("添加operate操作--- "..tbl.opt)
end

function Operate(tbl)
	local myself = GetMyself()
	local act = {}
	act.optType = "operate"
	act.name = tbl.opt
	act.data = tbl
	act.target = myself
	actList[#actList+1] = act

	-- logWarn("添加operate操作--- "..tbl.opt)
end

-----------------------------------------------------------------------------------------------------------

function AddMainPlayer(id, info)
	mySelf = Player.New()
	mySelf:Init(info)
	AddPlayer(id, mySelf)
	return mySelf
end

function AddOtherPlayer(id, info)
	local p = PlayerOther.New()
	p:Init(info)
	AddPlayer(id, p)
	return p
end


--添加panel--
function AddPlayer(id, p)
	if p == nil then
		logError("p 为空")
		return
	end
	
	if playerList[id] ~= nil then
		util.LogError("PlayerMgr中重复添加 "..id)
		p = nil
		return
	end

	playerList[id] = p
	return p
end

--获取player--
function Get(id)
	return playerList[id]
end

function GetAll()
	return playerList
end

function IsMyself(o)
	local p = GetMyself()
	if type(o) == "number" then
		return o == p:GetID()
	else
		return o == p
	end
end

--获取自己--
function GetMyself()
	return mySelf
end

function GetMyselfID()
	return mySelf:GetID()
end

function GetName(userId)
	local p
	if not userId then
		p = player
	else
		p = Get(userId)
	end
	if p ~= nil then
		return p:GetName()
	end
	logError('未找到玩家--'..tostring(userId))
	return
end

function GetGold(userId)
	local p
	if not userId then
		p = player
	else
		p = Get(userId)
	end
	if p ~= nil then
		return p:GetGold()
	end
	logError('未找到玩家--'..tostring(userId))
	return
end

function GetDiamond(userId)
	local p
	if not userId then
		p = player
	else
		p = Get(userId)
	end
	if p ~= nil then
		return p:GetDiam()
	end
	logError('未找到玩家--'..tostring(userId))
	return
end

----获取玩家属性值
function GetAttr(attr, userId)
	local p
	if not userId then
		p = player
	else
		p = Get(userId)
	end
	if p ~= nil then
		return p:Get(attr)
	end
	logError('未找到玩家--'..tostring(userId))
	return
end

--更新
function Update()
	
	if #actList > 0 then
		if Time.GetTimestamp() - startActTime >= curActTime then
			-- log("PlayerMgr.curActTime -- "..PlayerMgr.curActTime)
			Exec()
		end
	end

	for _, player in pairs(playerList) do
		-- if id ~= nil and player:IsOnLine() == true then
			player:Update()
		-- end
	end
end

function Exec()
	local act = actList[1]

	local target = act.target

	if not target then
		util.LogError("target is nil act name -- "..act.name)
		return
	end

	-- logWarn("Exec -- actTime - "..PlayerMgr.curActTime.." | cur time "..Time.GetTimestamp().." name - "..target:GetName())
	startActTime = Time.GetTimestamp()
	
	local data = act.data
	local name = act.name

	if act.optType == "action" then
		target:OnAction(data)

		if Operation.CHU.name == name then
			target:OnActionChu(data)
			PlayerMgr.curActTime = Operation.CHU.time
		elseif Operation.MO.name == name then
			PlayerMgr.curActTime = Operation.MO.time
			target:OnActionMo(data)
			Event.Brocast(Msg.ActionMo,target)
		elseif Operation.CHI.name == name then
			PlayerMgr.curActTime = Operation.CHI.time
			target:OnActionChi(data)
		elseif Operation.PENG.name == name then
			PlayerMgr.curActTime = Operation.PENG.time
			target:OnActionPeng(data)
		elseif Operation.AN.name == name then
			PlayerMgr.curActTime = Operation.AN.time
			target:OnActionAn(data)
		elseif Operation.JIE.name == name then
			PlayerMgr.curActTime = Operation.JIE.time
			target:OnActionJie(data)
		elseif Operation.GONG.name == name then
			PlayerMgr.curActTime = Operation.GONG.time
			target:OnActionGong(data)
		elseif Operation.HU.name == name then
			PlayerMgr.curActTime = Operation.HU.time
			target:OnActionHu(data)
		else
			util.LogError("没有找到操作类型 act.name : "..act.name)
			return
		end
	elseif act.optType == "operate" then
		-- logWarn("exec---"..tostring(data))
		target:OnOperate(data)
	end

	table.remove(actList, 1)
end

--移除player--
function RemovePlayer(o)
	local id = false
	if type(o) == "number" then
		id = o
	else
		id = o:GetID()
	end

	if not id then
		util.LogError("没有找到要删除玩家："..tostring(o))
		return
	end

	if playerList[id] ~= nil then
		playerList[id]:UnLoad()
	end
	playerList[id] = nil;
end

function OnLoadFinish(mdName)
	actList = {}
	modName = mdName
end


--卸载模块--
function UnLoad(modName)
	local my = GetMyself()
	for _, player in pairs(playerList) do
		if player ~= my then
			player:UnLoad()
			RemovePlayer(player:GetID())
			player = nil
		end
	end

end
