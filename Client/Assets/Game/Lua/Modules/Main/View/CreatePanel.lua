
require 'Modules/Main/View/Item/CreateItem'

CreatePanel = Class(BasePanel);

local ruleTitleName = {}
function CreatePanel:Ctor()
	
    self.m_comp.btnCreate = ButtonEx
    self.m_comp.ruleGroup = UIGroup
    self.m_comp.roundGroup = UIGroup

    self.m_itemList = {}

    self.m_curCfg = false
end

function CreatePanel:OnInit()
	self.m_comp.btnCreate:AddLuaClick(self.OnClickCreate,self)	
end

function CreatePanel:OnOpen(gameTypeID)

    if gameTypeID == 1 then
        self.m_curCfg = fyCfg
    elseif gameTypeID == 3 then
        self.m_curCfg = gyCfg
    end

    --局数
    self.m_comp.roundGroup:SetCount(#self.m_curCfg.round)
    for i=0,#self.m_curCfg.round-1 do
        local handle = self.m_comp.roundGroup:Get(i):GetComponent("StateHandle")
        if i == 0 then
            handle:SetStateEx(1)
        else
            handle:SetStateEx(0)    --有默认选值
        end
        local txtChild = handle.transform:Find("txtRuleChild"):GetComponent("TextEx")
        txtChild.text = self.m_curCfg.round[i+1].."局"
    end

    --玩法规则
    local ruleItemCount= #self.m_curCfg.rules
    self.m_comp.ruleGroup:SetCount(ruleItemCount)
	for i = 0, ruleItemCount-1 do 
		local go = self.m_comp.ruleGroup:Get(i)
		item = CreateItem.New(go)
		local itemData =self.m_curCfg.rules[i+1]
		item:Init(itemData)
		self.m_itemList[#self.m_itemList+1] = item  
	end

end

function CreatePanel:OnClickCreate()

    local  data = {}
    data.rules = {}
    --玩法规则处理
    for i = 1, self.m_comp.ruleGroup.Count do 
        local item = self.m_itemList[i]
        local idx = item:GetRule()
        data.rules[self.m_curCfg.rules[i].key] = self.m_curCfg.rules[i].options[idx].val
    end

    --局数规则处理
    for i=0, self.m_comp.roundGroup.Count do
        local handle = self.m_comp.roundGroup:Get(i):GetComponent("StateHandle")
        if handle.m_curState == 1  then
            data.round = self.m_curCfg.round[i+1]
            break
        end  	
    end

    --data  钻石
    data.onwerDiamond = 4

    self.m_ctrl:OnCreateRoom(data)
end

--  Update 方法
function CreatePanel:OnUpdate()
end

-- 当窗口关闭
function CreatePanel:OnClose()
end