-- BaseCtrl.lua
-- Author : Dzq
-- Date : 2017-05-19
-- Last modification : 2017-05-18
-- Desc: ctrl基类

BaseCtrl = Class()

function BaseCtrl:Ctor(modName)
	----此处变量不能置为nil nil代表没定义 在子类里是不存在的
	self.m_id = "BaseCtrl"		--ctrl名
	self.m_modName = modName		--模块名 创建panle用
	self.m_panelName = "base"	--预置体名 创建panel用
	self.m_panel = false
	self.m_luaBehaviour = false
	self.m_data = false
	self.m_isLoaded = false
	self.msgIdList = {}
	--logWarn("Balse ctrl Ctor---->>>")
end

function BaseCtrl:Init()
	if self.m_panelName == 'base' then
		logError('继承的panel没有给prefab名')
		return
	end
	if not self.m_panel then
    	panelMgr:CreatePanel(self.m_modName, self.m_panelName, self.OnCreate, self);
	end
    self:OnInit()
end

function BaseCtrl:AddEvent(msgID, callback, tbl)
	if (type(msgID) == "number") then
		msgID = tostring(msgID)
	end
	Event.AddListener(msgID, callback, tbl);
	local data = {}
	data.msgID = msgID
	data.callback = callback
	self.msgIdList[#self.msgIdList + 1] = data
end

function BaseCtrl:RemoveEvent(msgID)
	for i=1, #self.msgIdList do
		if self.msgIdList[i].msgID == msgID then
			Event.RemoveListener(self.msgIdList[i].msgID, self.msgIdList[i].callback)
			self.msgIdList[i] = nil
			break
		end
	end
end

function BaseCtrl:OnInit()

end

function BaseCtrl:OnStart( param, ... )
	
end

--加载完后的回调--
function BaseCtrl:OnCreate(obj)
	
	if not obj then
		logError("加载界面失败:"..self.m_panelName)
		return
	end
	
	local panelClass = _G[self.m_panelName]
	if not panelClass then
		logError("未加载panel脚本："..self.m_panelName)
		return
	end
	
	self.m_panel = panelClass.New(obj)
	self.m_panel.m_ctrl = self
	UIMgr.AddPanel(self.m_panelName, self.m_panel)
	self.m_isLoaded = true
	
end

function BaseCtrl:OpenPanel()
	if not self.m_panel then
		logError("panel界面为空："..self.m_panelName)
		return false
	end
	self.m_panel:Open(self.m_data)
end

function BaseCtrl:UnLoad( )
	for i=1, #self.msgIdList do
		Event.RemoveListener(self.msgIdList[i].msgID, self.msgIdList[i].callback)
	end

	self.m_id = "BaseCtrl"		--ctrl名
	self.m_modName = modName		--模块名 创建panle用
	self.m_panelName = "base"	--预置体名 创建panel用
	self.m_panel = false
	self.m_luaBehaviour = false
	self.m_data = false
	self.m_isLoaded = false
	self.msgIdList = {}
	logWarn("un load ctrl -- "..self.m_panelName)
end