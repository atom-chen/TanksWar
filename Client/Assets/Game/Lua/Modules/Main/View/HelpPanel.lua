
HelpPanel = Class(BasePanel);

local toggleList = {}
local  contentList = {}
function HelpPanel:Ctor()
	
	self.m_comp.ContentParent = Transform

    self.m_comp.GridStatehand = Transform
end

function HelpPanel:OnInit()
	--  给输入框添加点击事件
    for i=1,self.m_comp.GridStatehand.childCount do
         toggleList[i]=self.m_comp.GridStatehand:GetChild(i-1):GetComponent("StateHandle")
         toggleList[i]:AddLuaClickEx(self.OnClickGameItem,self)
    end
    
    for i=1,self.m_comp.ContentParent.childCount do
        -- print(i)
        contentList[i]=self.m_comp.ContentParent:GetChild(i-1)
        contentList[i].gameObject:SetActive(false)
    end
     
    -- local toggleGroup = self.m_comp.GridStatehand:GetComponent("StateGroup")   
    -- toggleGroup:SetSel(0)
    contentList[1].gameObject:SetActive(true)
    toggleList[1]:SetStateEx(1)
    

end


function  HelpPanel:OnClickGameItem(btn)
    -- log("  an按钮状态  "..btn.m_curState)

    for i=1,#contentList do
        contentList[i].gameObject:SetActive(false);
    end

    -- log(" btn  name  : "..btn.gameObject.name)
    for i=1,#toggleList do
        -- print(toggleList[i].m_curState)
        if toggleList[i].m_curState==1 then
            contentList[i].gameObject:SetActive(true);
        end
    end
    -- body
end
