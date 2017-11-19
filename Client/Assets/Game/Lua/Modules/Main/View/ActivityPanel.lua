
ActivityPanel = Class(BasePanel);


local onCenter 
local oldCenterIndex

function ActivityPanel:Ctor()

    self.m_comp.notice = Transform 
    self.m_comp.dianGrid  = Transform
    self.m_comp.noticeGrid = Transform
end

function ActivityPanel:OnInit()
	

     ActivityCfg.GetCfgCount()
    
    local noticePrefab = self.m_comp.noticeGrid:GetChild(0).gameObject
    local dianPrefab =  self.m_comp.dianGrid:GetChild(0).gameObject
    --公告元素处理
    for i=1,ActivityCfg.GetCfgCount()-1 do
        local obj = GameObject.Instantiate(noticePrefab);
        obj.transform:SetParent(noticePrefab.transform.parent)
        obj.transform.localScale = Vector3.one;
        obj.transform.localPosition = Vector3.zero;

        local dianObj =  GameObject.Instantiate(dianPrefab);
        dianObj.transform:SetParent(dianPrefab.transform.parent)
        dianObj.transform.localScale = Vector3.one;
        dianObj.transform.localPosition = Vector3.zero;
        dianObj.transform:GetChild(1).gameObject:SetActive(false)

    end
     
    --公告内容赋值
    for i=1,ActivityCfg.GetCfgCount() do
       local img = self.m_comp.noticeGrid:GetChild(i-1):GetComponentInChildren(typeof(ImageEx))
       local sprite = "ui_Main_Activity_"..ActivityCfg.Cfg[i].icon
       -- log(" sprite  : "..sprite)
       -- log(" img "..img.gameObject.name)

       img:Set(sprite)
    end
    
   
    onCenter = self.m_comp.notice:GetComponent(typeof(CenterChild))    
    onCenter:RefreshState()
    
    oldCenterIndex = onCenter:GetCenterChildIndex()

    self:SetDian(oldCenterIndex)
    -- log("centerIndex   --  "..centerIndex)
   
end

 

function ActivityPanel:SetDian(index)
	-- body
	-- log(" ActivityPanel : "..index.."   self.m_comp.dianGrid.childCount :"..self.m_comp.dianGrid.childCount)
	for i=1,self.m_comp.dianGrid.childCount do
	    -- print(i)
		if i== (index+1) then
           local obj =  self.m_comp.dianGrid:GetChild(i-1):GetChild(1).gameObject
           obj:SetActive(true)
           -- img
        else
           local obj =  self.m_comp.dianGrid:GetChild(i-1):GetChild(1).gameObject
           obj:SetActive(false)
		end
	end
end

function ActivityPanel:OnUpdate( ... )
	-- body

	 --获取居中元素
     local centerIndex = onCenter:GetCenterChildIndex()
     if  centerIndex ~=	oldCenterIndex then
     	 oldCenterIndex = centerIndex
         self:SetDian(centerIndex)
     end
end




function ActivityPanel:OnOpen()
	-- body
    
end