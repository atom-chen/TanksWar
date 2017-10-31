-- LoginPanel.lua
-- Author : Dzq
-- Date : 2017-07-25
-- Last modification : 2017-07-25
-- Desc: 登录Panel Item
LoginItem1 = Class(BaseItem);
  
function LoginItem1:Ctor()
	self.m_comp.text = TextEx
end

function LoginItem1:OnInit(param)
	self.m_comp.text.text = tostring('text -'..param)
end

