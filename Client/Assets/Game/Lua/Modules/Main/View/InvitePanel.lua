
require 'Modules/Main/View/Item/InviteItem'

InvitePanel = Class(BasePanel);

function InvitePanel:Ctor()
	self.m_comp.MyID = UIArtFont
    self.m_comp.IconGroup = UIGroup
end

function InvitePanel:OnInit()
    self.m_comp.MyID.gameObject:SetActive(false)
    self.m_comp.IconGroup.gameObject:SetActive(false)
end

function InvitePanel:OnOpen( )
    self:ShowMyId();
end

  -- 自身ID 显示
function InvitePanel:ShowMyId()
    local  strId = PlayerMgr.GetMyselfID()
    self.m_comp.MyID.gameObject:SetActive(true)
    self.m_comp.MyID:SetNum(tostring(strId), false)
end

function InvitePanel:ShowInviteRole()
    --显示邀请人
    coroutine.start(function()
        local res = NetWork.Request(proto.myInvitation)
        if res.code == 0 then
            self.m_comp.IconGroup:SetCount(#res.data)
            for i = 0, #res.data-1 do 
                local go = self.m_comp.IconGroup:Get(i)
                item = InviteItem.New(go)
                local itemData = res.data[i+1]
                item:Init(itemData)
            end
            self.m_comp.IconGroup.gameObject:SetActive(true)
        else
            UIMgr.Open(Common_Panel.TipsPanel, res.msg)
        end
    end)
end

function InvitePanel:OnOpenEnd( )
    self:ShowInviteRole()
end


