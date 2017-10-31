-- LobbyPanel.lua
-- Author : Dzq
-- Date : 2017-08-17
-- Last modification : 2017-08-17
-- Desc: 大厅游戏Panel Item
LobbyItem = Class(BaseItem);

--游戏类型


function LobbyItem:Ctor()
	self.m_comp.btnGame = ButtonEx
	self.m_comp.imglock = ImageEx

end


function LobbyItem:OnInit(param)

    --数据初始化
    -- log("  ------  "..param.id)
    self.gameType = param.id
    self.m_comp.imglock.gameObject:SetActive(param.lock==1)
    local btnimage = self.m_comp.btnGame:GetComponent("ImageEx")
    local  imageName = "ui_Main_Lobby_"..param.icon
    -- log(btnimage.transform.)
    btnimage:Set(imageName)
     
	--事件注册
    self.m_comp.btnGame:AddLuaClick(self.OnClickItem, self)
    
end

function  LobbyItem:OnClickItem()
     -- log("  ----   "..self.gameType)
     UIMgr.Open(Main_Panel.CreatePanel, self.gameType)
    
end
