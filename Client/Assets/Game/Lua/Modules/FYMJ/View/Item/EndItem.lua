-- EndItem.lua
-- Author : Dzq
-- Date : 2017-11-11
-- Last modification : 2017-11-11
-- Desc: 结算界面信息 Item
EndItem = Class(BaseItem)

function EndItem:Ctor()
    self.m_comp.scoreNum = UIArtFont
    self.m_comp.scoreInfo = GameObject
    self.m_comp.cardsInfo = GameObject
end


function EndItem:OnInit(param)
	log("EndItem:OnInit -- "..tostring(param))
	logWarn(" EndItem:OnInit --- "..cjson.encode(param))
end

function EndItem:SetInfo(player)
end

function EndItem:OnClickItem()
    
end
