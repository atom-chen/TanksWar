

CreateRoomPanel = Class(BasePanel);

function CreateRoomPanel:Ctor()
	
	--log("LobbyPanel Ctor---->>>")
	-- self.m_comp.btnClose = UIButtonEx
    self.m_comp.btnCreate=UIButtonEx
	-- self.m_comp.txtTile =UITextEx
end

function CreateRoomPanel:OnInit()
	-- self.m_comp.btnClose:AddLuaClick(self.OnClickClose, self)
	self.m_comp.btnCreate:AddLuaClick(self.OnClickBtnCreate,self)	

	-- self.m_comp.txtTile.gameObject:SetActive(false)
end

function CreateRoomPanel:OnOpen(gameTypeID)

   log("  游戏类型  ： "..gameTypeID)
   local  data  = RuleCfg.GetById(gameTypeID)
   
end

function CreateRoomPanel:OnClickBtnCreate()
    
 
     log("    点击了创建房间    ")

end

--  Update 方法
function CreateRoomPanel:OnUpdate()
	--log("LoginPanel OnUpdate---->>>")
	-- log(Time.time)
end

-- 当窗口关闭
function CreateRoomPanel:OnClose()
	-- body
	-- log("   窗口关闭  ")
end