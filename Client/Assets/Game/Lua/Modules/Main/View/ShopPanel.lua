ShopPanel = Class(BasePanel);
require 'Modules/Main/View/Item/ShopItem'

function ShopPanel:Ctor()
	-- self.m_comp.btnShareFriend = ButtonEx
 --    self.m_comp.btnShareMoments = ButtonEx
      self.m_comp.group_shop = UIGroup
      self.itemList={}
end

function ShopPanel:OnInit()
    -- self.m_comp.btnShareFriend:AddLuaClick(self.OnChatFriendShare, self)
    
    -- self.m_comp.btnShareMoments:AddLuaClick(self.OnChatMomentsShare ,self)
    
end

function  ShopPanel:OnOpen()
	-- body
	local shopItemcount =  ShopCfg.GetShopCount()
    
    self.m_comp.group_shop:SetCount(shopItemcount)
	for i = 0, shopItemcount-1 do 
		local go = self.m_comp.group_shop:Get(i)
	    local data = ShopCfg.GetById(i+1)
		item = ShopItem.New(go)
		item:Init(data)
		self.itemList[#self.itemList+1] = item  
	end
end
