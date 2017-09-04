-- LobbyPanel.lua
-- Author : Dzq
-- Date : 2017-08-17
-- Last modification : 2017-08-17
-- Desc: 大厅游戏Panel Item
LobbyItem = Class(BaseItem);

--游戏类型


function LobbyItem:Ctor()
	self.m_comp.btnGame = UIButtonEx
	self.m_comp.imglock = UIImageEx

end


function LobbyItem:OnInit(param)

    --数据初始化
    -- log("  ------  "..param.id)
    self.gameType = param.id
    self.m_comp.imglock.gameObject:SetActive(param.lock==1)
    local btnimage = self.m_comp.btnGame:GetComponent("ImageEx")
    local  imageName = "ui_Main_"..param.icon
    btnimage:Set(imageName)
  
	--事件注册
    self.m_comp.btnGame:AddLuaClick(self.OnClickItem, self)
    
end

function  LobbyItem:OnClickItem()

     UIMgr.Open("CreateRoomPanel",self.gameType)
    
end
