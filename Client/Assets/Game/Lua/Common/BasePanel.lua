-- BasePanel.lua
-- Author : Dzq
-- Date : 2017-05-18
-- Last modification : 2017-05-18
-- Desc: panel基类 子类继承的名必须和对应的预置体名统一

BasePanel = Class()

function BasePanel:Ctor(go)
	----此处变量不能置为nil nil代表没定义 在子类里是不存在的
	
	-----参数-----
	self.m_param = false
	self.m_id = "base"
	self.m_name = "base"
	self.m_ctrl = false

	-----panel必带组件相关------
	self.m_go = go
	self.m_transform = go:GetComponent("RectTransform")
	self.m_ani = go:GetComponent("Animator");
	self.m_raycaster = go:GetComponent("GraphicRaycaster")
	
	-----层级相关-----
    self.m_canTop = true --加入置顶判断中，像摇杆和聊天提示这种界面不需要加入判断
    self.m_disableRaycasterIfNotTop = true --如果不是最顶层的界面，禁用GraphicRaycaster,注意如果界面打开多了，那么这个组件会极大影响性能，勾上这个选项后就不会了
    self.m_autoOrder = true --动态层级，如果为false那么层级就是Canvas上的层级了。动态层级从50~200，ui_hight层不支持动态层级
	self.m_checkTop = {}

	-----定义组件相关-----
	self.m_comp = {}	----panel中的所有组件
	self.m_comp.btnClose = ButtonEx 	----没个界面默认的关闭按钮
	
	-----标记相关-----
	self.m_layer = 0
	self.m_isTop = false
	self.m_isAniPlaying = false
	self.m_isInit = false
	self.m_beginOpenTime = 0
	self.m_beginCloseTime = 0
	self.m_openAniName = "ui_ani_open_1"
	self.m_closeAniName = "ui_ani_close_1"
	self.m_isAniOpening = false --是否正在播放开启效果
    self.m_isAniClosing = false --是否正在播放关闭效果
	
	-----事件相关-----
	self.msgIdList = {}
	--logWarn("Balse panel Ctor---->>>")
end

function BasePanel:Init()
	if self.m_isInit == true then
		util.LogError("重复初始化:"..self.m_name)
	end
	
	self:SetActive(true)
	
	----动态层级支持 界面上有特效需要重新设置层级
	--Util.DoAllChild(self.m_transform, function() sort end)
	
	----处理panel内定义组件对应
	local itemDefine = util.Clone(self.m_comp)
	util.GetMonoTable(self.m_go, itemDefine, self.m_comp)

	----通用关闭
	if self.m_comp.btnClose ~= nil then
		self.m_comp.btnClose:AddLuaClick(self.OnClickClose, self)
	end
	self:OnInit()
	self:SetActive(false)
	self.m_isInit = true
end

function BasePanel:AddEvent(msgID, callback, tbl)
	if (type(msgID) == "number") then
		msgID = tostring(msgID)
	end
	Event.AddListener(msgID, callback, tbl);
	local data = {}
	data.msgID = msgID
	data.callback = callback
	self.msgIdList[#self.msgIdList + 1] = data
end

function BasePanel:RemoveEvent(msgID)
	for i=1, #self.msgIdList do
		if self.msgIdList[i].msgID == id then
			Event.RemoveListener(self.msgIdList[i].msgID, self.msgIdList[i].callback)
			self.msgIdList[i] = nil
			break
		end
	end
end

function BasePanel:GetComponent(name)
	if not name or name == "" then
		logError("没名字 -- ")
		return nil
	end
	if not self.m_go then
		logError("self.m_go为空---："..self.m_name)
		return nil
	end
	return self.m_go:GetComponent(name)
end

function BasePanel:GetOrder()
	-- util.Log("GetOrder --- "..self.m_name)
	return (self:GetComponent("Canvas")).sortingOrder
end

function BasePanel:SetOrder(order)
	if not self.m_isInit then
		logError("为初始化完就设置层级了:"..self.m_name)
		return
	end
	
	local canvas = self:GetComponent("Canvas");
	if canvas.sortingOrder ~= order then
		canvas.sortingOrder = order
	end
end

function BasePanel:SetActive(bActive)
	self.m_go:SetActive(bActive)
end

function BasePanel:Open(param, immediate)
	
	if self.m_isAniOpening then
		logError("播放打开动画中")
		return
	end
	if not self.m_isInit then
		logError("打开的时候没有初始化")
		return
	end
	
	self:SetActive(true)
	
	self.m_isAniOpening = true
	self.m_isAniClosing = false
	self.m_beginOpenTime = Time.time
	
	----动态层级和置顶
	UIMgr.CheckOpenTopAndAutoOrder(self)
	
	immediate = immediate or false
	if self.m_openAniName == "" or immediate then
		----这里要重置到初始值
		local tranFrame = self.m_transform:Find("frame")
		if tranFrame then
			tranFrame.localScale = Vector3.one
		end
		
		self:ClearAni()
		self:OnOpen(param)
		self:OnOpenEnd()
	else
		self:PlayAni(self.m_openAniName)
		self:OnOpen(param)
	end
	
	----发事件 窗口打开
	--EventMgr.FireAll(MSG.MSG_SYSTEM, MSG_SYSTEM.PANEL_OPEN, uiPanel);
	----
end

function BasePanel:Fresh(param)
	if not self:IsOpen() or self.m_isAniPlaying == true then
		return
	end
	param = param or self.m_param
	self:OnOpen(param)
	self:OnOpenEnd()
end

function BasePanel:OnClickClose()
	self:Close()
	-- SoundMgr.PlayUI(SoundCfg.common_click)
end

function BasePanel:Close(immediate)
	-- util.Log("Close -- "..self.m_name)
	immediate = immediate or false
	if self.m_isAniPlaying and immediate == false then
		util.LogError("播放关闭动画中")
		return
	end
	
	local isAniCloseBefore = self.m_isAniClosing
	if self.m_go.activeSelf == false then
		util.LogError("重复关闭:"..self.m_name)
		return
	end
	
	self.m_isAniClosing = true
	self.m_isAniOpening = false
	self.m_beginCloseTime = Time.time
	local needAniClose = (not immediate) and (self.m_closeAniName ~= "")
	--取消置顶
	UIMgr.CheckCloseTopAndAutoOrder(self, needAniClose)
	
	--检查场景相机的禁用
	--UIMgr.CheckDisableSceneCamera()
	if not needAniClose then
		self:SetActive(false)
		self:ClearAni()
		if not isAniCloseBefore then
			self:OnClose()
		end
		self:OnCloseEnd()
	else
		self:PlayAni(self.m_closeAniName)
		--垃圾回收
		--GCCollect()
		self:OnClose()
	end
		
	--发送关闭窗口的事件
	--EventMgr.FireAll(MSG.MSG_SYSTEM, MSG_SYSTEM.PANEL_CLOSE, uiPanel);
end

function BasePanel:ClearAni()
	self.m_isAniOpening = false
	self.m_isAniClosing = false
	if self.m_ani then
		self.m_ani.enabled = false
	end
end

function BasePanel:PlayAni(name, checkHierarchy)
	if not self.m_ani or not name then
		return false
	end
	
	checkHierarchy = checkHierarchy or true
	
	local thisGroup = self.m_transform:GetComponent("CanvasGroup")
	local tranFrame = self.m_transform:Find("frame")
	if not thisGroup or not tranFrame then
		logError("不符合规定的结构不能播放")
		return false
	end
	
	self.m_ani.enabled = false
	self.m_ani:Play(name, -1, 0)
	self.m_ani.enabled = true
	self.m_ani:Update(0)
	return true
end

function BasePanel:IsOpen()
	if tostring(self.m_go) == "null" then
		return false
	end
	return self.m_isInit and self.m_go.activeSelf
end

function BasePanel:IsTop()
	return self.m_isTop
end

function BasePanel:SetTop(bTop)
	if not self.m_canTop then
		logError("非置顶判断的窗口竟然被修改了置顶值")
		return
	end
	self.m_isTop = bTop
	if self.m_raycaster and self.m_disableRaycasterIfNotTop then
		self.m_raycaster.enabled = self.m_isTop
	end
	self:CheckTop()
end

function BasePanel:CheckTop()
	local b = self.m_isTop and (not UIMgr.closingTopPanel)
	for go in pairs(self.m_checkTop) do
		go:SetActive(b)
	end
end

function BasePanel:IsAniPlaying()
	return self.m_isAniOpening or self.m_isAniClosing
end

function BasePanel:Update()
	if self.m_isInit then
		if self.m_isAniOpening then
			if Util.IsAnimatorEnd(self.m_ani) == true then
				self:ClearAni()
				--UIMgr.CheckDisableSceneCamera()
				self:OnOpenEnd()
			end
		end
		
		if self.m_isAniClosing then
			if Util.IsAnimatorEnd(self.m_ani) == true then
				self:SetActive(false)
				self:ClearAni()
				self:OnCloseEnd()
				self:SetOrder(0)
				UIMgr.CheckTopByOtherPanelClose(self)
				return
			end
		end
	    
		self:OnUpdate()
	end
end

function BasePanel:OnInit()
	--logWarn("Balse panel OnInit---->>>")
end

function BasePanel:OnOpen(param)
	--logWarn("Balse panel OnOpen---->>>")
end

function BasePanel:OnOpenEnd()
	--logWarn("Balse panel OnOpenEnd---->>>")
end

function BasePanel:OnClose()
	--logWarn("Balse panel OnClose---->>>")
end

function BasePanel:OnCloseEnd()
	--logWarn("Balse panel OnCloseEnd---->>>")
end


function BasePanel:OnUpdate()
	--logWarn("Balse panel OnUpdate---->>>")
end

function BasePanel:UnLoad( )
	for i=1, #self.msgIdList do
		Event.RemoveListener(self.msgIdList[i].msgID, self.msgIdList[i].callback)
	end

	destroy(self.m_go)

	self.msgIdList = {}

	self.m_param = false
	self.m_id = "base"
	self.m_name = "base"
	self.m_ctrl = false

	-----panel必带组件相关------
	
	self.m_transform = false
	self.m_ani = false
	self.m_raycaster = false
	
	-----层级相关-----
    self.m_canTop = true --加入置顶判断中，像摇杆和聊天提示这种界面不需要加入判断
    self.m_disableRaycasterIfNotTop = true --如果不是最顶层的界面，禁用GraphicRaycaster,注意如果界面打开多了，那么这个组件会极大影响性能，勾上这个选项后就不会了
    self.m_autoOrder = true --动态层级，如果为false那么层级就是Canvas上的层级了。动态层级从50~200，ui_hight层不支持动态层级
	self.m_checkTop = {}

	-----定义组件相关-----
	self.m_comp = {}	----panel中的所有组件
	self.m_comp.btnClose = false 	----没个界面默认的关闭按钮
	
	-----标记相关-----
	self.m_layer = 0
	self.m_isTop = false
	self.m_isAniPlaying = false
	self.m_isInit = false
	self.m_beginOpenTime = 0
	self.m_beginCloseTime = 0
	self.m_openAniName = "ui_ani_open_1"
	self.m_closeAniName = "ui_ani_close_1"
	self.m_isAniOpening = false --是否正在播放开启效果
    self.m_isAniClosing = false --是否正在播放关闭效果
		
	self.m_go = false
end

function BasePanel:OnDestroy()
	--logWarn("Balse panel OnDestroy---->>>")
end
