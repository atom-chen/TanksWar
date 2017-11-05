JoinCtrl = Class(BaseCtrl);

function JoinCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "JoinCtrl"
	self.m_panelName = "JoinPanel"
	--log("LobbyCtrl Ctor---->>>")
end

function JoinCtrl:OnInit()
end


function JoinCtrl:JoinRoom(roomId)
	-- return
	if not roomId then
		util.LogError("roomid 为空--"..tostring(roomId))
		return
	end

	coroutine.start(function()
	    local res = NetWork.Request(proto.joinRoom, {roomId = roomId, clean = 1})
	    if res.code == 0 then
	        local recvData = res.data
	        -- log("recvData --- -- "..tostring(recvData))
	        coroutine.start(function ()
	        	local coLoad = coroutine.start(Game.CoLoadModule, Module.FYMJ)
	        	coroutine.waitCo(coLoad)
	        	Game.OnLoadFinish(recvData)
	        end)
	    else
	        UIMgr.Open(Common_Panel.TipsPanel, res.msg)
	    end
	end)

end
