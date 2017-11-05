
CertificatePanel = Class(BasePanel);

function CertificatePanel:Ctor()
	self.m_comp.btn_queding = ButtonEx
    self.m_comp.txt_name = UIText
    self.m_comp.txt_id = UIText
end

function CertificatePanel:OnInit()
    self.m_comp.btn_queding:AddLuaClick(self.OnRealName, self)
end

function CertificatePanel:OnRealName()
    local name = self.m_comp.txt_name.text
    local id = self.m_comp.txt_id.text
    
    local ChickResult = self:CheckStr(id)
    if name == nil or name == "" then 
       ChickResult = false
    end

    if ChickResult then
         local  data = {}
         data.name = txt_name
         data.id = id
         coroutine.start(function()
             local res = NetWork.Request(proto.realname, data)
             if res.code == 0 then
                 UIMgr.Open(Common_Panel.TipsPanel, Lang.realName)
             else
                 UIMgr.Open(Common_Panel.TipsPanel, res.msg)
             end
         end)

    else
        UIMgr.Open(Common_Panel.TipsPanel, Lang.realIdErr)
    end
end

function CertificatePanel:CheckStr(str)
    local len = string.len(str)
    if len == 15 then
       return self:ClickIdBy15(str)
    elseif len == 18 then
       return self:ClickIdby18(str)
    end
end

function CertificatePanel:ClickIdBy15(str)
     local n =  tonumber(str)
     if  n == nil then
        return false
     end
    return true
end

function CertificatePanel:ClickIdby18(str)
    local n = tonumber(string.sub(str,1,17))
    if n == nil then
        return false
    end

    if tonumber(string.sub(str,18,18)) == nil  and string.sub(str,18,18) ~= "x"  and string.sub(str,18,18) ~= "X" then
        return false
    end
    
    return true
end