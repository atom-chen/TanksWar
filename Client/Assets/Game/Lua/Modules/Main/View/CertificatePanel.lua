
CertificatePanel = Class(BasePanel);

local  txt_name 
local  txt_id 
function CertificatePanel:Ctor()
	self.m_comp.btn_queding = ButtonEx
    self.m_comp.txt_name = UIText
    self.m_comp.txt_id = UIText
end

function CertificatePanel:OnInit()
	--  给输入框添加点击事件
    self.m_comp.btn_queding:AddLuaClick(self.OnClickQueDing, self)
    self:AddEvent(proto.realname, self.OnRealName, self)
    
end


--接收服务器消息响应
function CertificatePanel:OnRealName(data)
    if data.code==0 then
        UIMgr.Open(Common_Panel.TipsPanel, Lang.realName)
    elseif ata.code ~=0 then
        UIMgr.Open(Common_Panel.TipsPanel, data.msg)
    end
end


function CertificatePanel:OnClickQueDing()
    -- body
    -- log("  确定进行了实名认证---- ")
    txt_name =self.m_comp.txt_name.text
    txt_id = self.m_comp.txt_id.text
    
 

   -- log("  txt_name   :   "..txt_name)
   -- 进行本地字符认证
    local ChickResult =  self:ChickStr(txt_id)
    if txt_name==nil then 
       ChickResult=false
    end
    if ChickResult then
         log("   本地验证成功发送服务器  ")
         local  data = {}
         data.name = txt_name
         data.id = txt_id
         NetWork.SendMsg(proto.realname, data)
    else
        UIMgr.Open(Common_Panel.TipsPanel, Lang.realIdErr)
    end
end

function CertificatePanel:ChickStr(str)
    -- body
    -- log("  身份证号码   ： "..str)
    local result=false
    string.len(str)
    if string.len(str) == 15 then
       result= self:ClickIdBy15(str)
    elseif string.len(str) == 18 then
       result= self:ClickIdby18(str)
    end

    return result
end

function CertificatePanel:ClickIdBy15(str)
    -- body

    --全数字验证
     local  n =  tonumber(str)
     if  n==nil then
        return false
     end
    
    return true
    --身份验证
    -- local address = "11x22x35x44x53x12x23x36x45x54x13x31x37x46x61x14x32x41x50x62x15x33x42x51x63x21x34x43x52x64x65x71x81x82x91"
     -- log("  n  15  :     "..string.sub(str,1,14))
end

function CertificatePanel:ClickIdby18(str)
    -- body
     local  n =  tonumber(string.sub(str,1,17))
     if  n==nil then
        return false
     end
     if  tonumber(string.sub(str,18,18))==nil  and string.sub(str,18,18) ~= "x"  and string.sub(str,18,18) ~= "X" then
        return false
     end
    
    return true;
     -- log("  n  18 :     "..n)
end