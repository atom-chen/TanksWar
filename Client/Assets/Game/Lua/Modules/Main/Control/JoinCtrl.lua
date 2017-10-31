JoinCtrl = Class(BaseCtrl);

function JoinCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "JoinCtrl"
	self.m_panelName = "JoinPanel"
	--log("LobbyCtrl Ctor---->>>")
end

function JoinCtrl:OnInit()
	self:AddEvent(proto.joinRoom, self.OnJoinRoom, self)
end

function JoinCtrl:OnStart(data)
	UIMgr.Open(Main_Panel.JoinPanel)
end

function JoinCtrl:JoinRoom(roomId)

	-- coroutine.start(function ( ... )
	-- 	local coLoad = coroutine.start(Game.CoLoadModule, Module.FYMJ)
	-- 	coroutine.waitCo(coLoad)
	-- 	Game.OnLoadFinish()
	-- end)
	
	-- return
	if not roomId then
		util.LogError("roomid 为空--"..tostring(roomId))
		return
	end

	NetWork.SendMsg(proto.joinRoom, {roomId = roomId})
end

function JoinCtrl:OnJoinRoom(tbl)
	if tbl.code == 0 then
		local recvData = tbl.data
		-- log("recvData --- -- "..tostring(recvData))
		coroutine.start(function ()
			local coLoad = coroutine.start(Game.CoLoadModule, Module.FYMJ)
			coroutine.waitCo(coLoad)
			Game.OnLoadFinish(recvData)
		end)
		return
	else
		UIMgr.Open(Common_Panel.TipsPanel, tbl.msg)
		return
	end
end