
-- Desc: 登录Panel Item
CreateItem = Class(BaseItem);
  
function CreateItem:Ctor()
	self.m_comp.txtRuleName = TextEx
    self.m_comp.GridParent = UIGroup
    
end

function CreateItem:OnInit(param)

	 --初始化 子级
	 self.m_comp.GridParent:SetCount(#param.options)
        -- --数据设置
     self.m_comp.txtRuleName.text = param.name..":"
	 for i = 0, #param.options-1 do 
	 	local go = self.m_comp.GridParent:Get(i)
	 	local handle = go:GetComponent("StateHandle")
	 	handle:AddLuaClick(self.OnClick, self)
	 	local ruleText = go.transform:Find("txtRuleChild"):GetComponent("TextEx")
	 	ruleText.text= param.options[i+1].name
	 end

end

function CreateItem:GetRule( )
	local selIdx = 0
	for i=0, self.m_comp.GridParent.Count-1 do
		local handle = self.m_comp.GridParent:Get(i):GetComponent("StateHandle")
	   	if handle.m_curState == 1 then
	   		selIdx = i+1
	   	end
	end
	return selIdx

end

function CreateItem:OnClick()

end



