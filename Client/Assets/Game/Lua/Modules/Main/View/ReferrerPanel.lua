ReferrerPanel = Class(BasePanel);

function ReferrerPanel:Ctor()
    self.m_comp.btnTJ =  ButtonEx
    self.m_comp.txtInputId = UIText
end

function ReferrerPanel:OnInit()
    self.m_comp.btnTJ:AddLuaClick(self.OnClickBtnTJ, self)
end

function ReferrerPanel:OnClickBtnTJ()
    local inputId = self.m_comp.txtInputId.text
    local id = tonumber(inputId)
    if id == nil then
       UIMgr.Open(Common_Panel.TipsPanel, Lang.inputErr)
       return
    end
    
    --发送消息给服务器
    local data = {}
    data.parentId = id
    self.m_ctrl:OnBind(data)
end

