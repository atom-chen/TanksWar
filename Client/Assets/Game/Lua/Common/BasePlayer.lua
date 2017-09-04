-- BasePlayer.lua
-- Author : Dzq
-- Date : 2017-08-29
-- Last modification : 2017-08-29
-- Desc: BasePlayer 玩家基类
BasePlayer = Class();
  
function BasePlayer:Ctor()
	self.m_id = false
	self.m_info = false
	self.m_name = false	
	self.m_gold = false
	self.m_diamond = false
end

function BasePlayer:Init(param)
	self.m_info = param
	self:OnInit(param)
end

function BasePlayer:GetName( )
	return self.m_name
end

function BasePlayer:GetID( )
	return self.m_id
end

function BasePlayer:GetGold( )
	return self.m_gold
end

function BasePlayer:GetDiamond( )
	return self.m_diamond
end

function BasePlayer:SetName( name )
	self.m_name = name
end

----获取玩家属性值
function BasePlayer:Get(attr)
	return self.m_info[attr]
end

function BasePlayer:Update()
	return self:OnUpdate()
end

function BasePlayer:OnUpdate()
end