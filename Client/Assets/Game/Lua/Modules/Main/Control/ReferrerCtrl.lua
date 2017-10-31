ReferrerCtrl = Class(BaseCtrl);

function ReferrerCtrl:Ctor()
	self.m_id = "ReferrerCtrl"
	self.m_panelName = "ReferrerPanel"
end

function ReferrerCtrl:OnInit()
     
end

function ReferrerCtrl:OnBind(data)
	coroutine.start(function ()
		local tbl = NetWork.Request(proto.bind, data)
		if tbl.code == 0 then
			UIMgr.Open(Common_Panel.TipsPanel, Lang.bindSucce)
			return
		else
			UIMgr.Open(Common_Panel.TipsPanel, tbl.msg)
			return
		end	
	end)	
    
end
