InviteItem = Class(BaseItem);
  
function InviteItem:Ctor()
	self.m_comp.imgIcon = ImageEx
    self.m_comp.txtName = TextEx
end

function InviteItem:OnInit(param)
    
    self.m_comp.txtName.text =  param.nick
    local  url = "http://wx.qlogo.cn/mmopen/A2UUGSoeQz6U51ylujnMktCIosFh3kpOcjQtxOv2HeuR1hiawlLc0Klju3LySlib6icx1yH497Cdo9ob8DmRFc3Y0E82vntQgfO/0"
    self.m_comp.imgIcon:SetImageURL(url,false)
end

function InviteItem:OnO( ... )
	-- body
end