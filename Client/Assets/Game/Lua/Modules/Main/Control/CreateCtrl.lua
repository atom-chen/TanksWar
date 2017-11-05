
CreateCtrl = Class(BaseCtrl);

function CreateCtrl:Ctor()
	--自动会走基类的Ctor构造函数
	self.m_id = "CreateCtrl"
	self.m_panelName = "CreatePanel"
	--log("LobbyCtrl Ctor---->>>")
end

function CreateCtrl:OnInit()
end

function CreateCtrl:OnCreateRoom(data)
	
	coroutine.start(function ()
		local tbl = NetWork.Request(proto.fy_createRoom, data)
		if tbl.code == 0 then
			local recvData = tbl.data
			log("recvData --- -- "..tostring(recvData))
			coroutine.start(function ()
				local coLoad = coroutine.start(Game.CoLoadModule, Module.FYMJ)
				coroutine.waitCo(coLoad)
				Game.OnLoadFinish(recvData)
				Event.Brocast(Msg.EnterRoom, recvData.roomId)
			end)
			return
		else
			UIMgr.Open(Common_Panel.TipsPanel, tbl.msg)
			return
		end	
	end)
end
