SharePanel = Class(BasePanel);

function SharePanel:Ctor()
	self.m_comp.btnShareFriend = ButtonEx
    self.m_comp.btnShareMoments = ButtonEx

end

function SharePanel:OnInit()
    self.m_comp.btnShareFriend:AddLuaClick(self.OnClickFriends, self)
    self.m_comp.btnShareMoments:AddLuaClick(self.OnClickMoments, self)
end

--分享好友
function SharePanel:OnClickFriends()
    SDKMgr.OnShareFriends(PlayerMgr.GetMyselfID())
end

--分享朋友圈
function SharePanel:OnClickMoments()
    SDKMgr.OnShareMoments(PlayerMgr.GetMyselfID())
end
