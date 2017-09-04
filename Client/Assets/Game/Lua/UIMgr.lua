-- UIMgr.lua
-- Author : Dzq
-- Date : 2017-05-20
-- Last modification : 2017-07-16
-- Desc: Panel管理类

module(..., package.seeall)

local panelList = {};	--控制器列表--
local modName = ""
local topPanel = false
local closingTopPanel = false
function CoInit(mdName)

	--加载通用内容--
	local common_panel = _G['Common_Panel']
	for _,pName in pairs(common_panel) do
		require ('Modules/Common/View/'..pName)
	end

	--加载对应模块内容--
	modName = mdName
	local mod_panel = _G[modName..'_Panel']
	for _,pName in pairs(mod_panel) do
		require ('Modules/'..modName.."/View/"..pName)
	end

	-- log("UIMgr.Init----->>>");
end

--添加panel--
function AddPanel(panelName, panel)
	if panel == nil then
		logError("panel 为空")
		return
	end
	
	if panelList[panelName] ~= nil then
		logError("UIMgr中重复添加 "..panelName)
		GameObject:Destroy(panel.m_go)
		panel = nil
		return
	end
	
	panel.m_id = panelName
	panel.m_name = panelName
	-- log("AddPanel ------- "..panelName);

	panelList[panelName] = panel;
	panel:Init()

	--加入一个全局的打开函数
	-- _G[panelName].Open = function(param)
	-- 	local panel = Get(panelName)
	-- 	if panel == nil then
	-- 		logError("未初始化过"..panelName)
	-- 		return
	-- 	end
	-- 	panel:Open(param)
	-- end
	
	return panel
end

--获取panel--
function Get(panelName)
	return panelList[panelName];
end

function GetAll()
	return panelList
end
--打开panel--
function Open(panelName, param, immediate)
	local panel = Get(panelName)
	if panel == nil then
		logError("没有找到panel："..panelName)
		return
	end
	
	panel:Open(param, immediate)
	return panel
end

--刷新panel--
function Fresh(panelName, param)
	local panel = Get(panelName)
	if panel == nil then
		logError("没有找到panel："..panelName)
		return
	end
	
	panel:Fresh(param)
	return panel
end

--关闭panel--
function Close(panelName, immediate)
	local panel = Get(panelName)
	if panel == nil then
		logError("没有找到panel："..panelName)
		return
	end
	
	panel:Close(immediate)
	-- log('UIMgr Close---->>>'..panelName);
	return panel
end

function CloseAll()
	if topPanel then
		topPanel:SetTop(false)
		topPanel = nil
	end
	
	for _, panel in panelList do
		if panel:IsOpen() then
			panel:Close(true)
		end
	end
end

--更新
function Update()
	for pName, panel in pairs(panelList) do
		if panel ~= nil and panel:IsOpen() == true then
			panel:Update()
		end
	end
end

--移除panel--
function RemovePanel(panelName)
	panelList[panelName] = nil;
end

--卸载模块--
function UnLoad(modName)

end

function CheckOpenTopAndAutoOrder(panel)
	if not panel:IsOpen() then
		logError("打开状态下才能检测动态层级:"..panel.m_name)
		return
	end
	
	--动态层级
	if panel.m_autoOrder then
		local order = AUTO_ORDER_MIN
		local tempPanel
		for _,p in pairs(panelList) do
			tempPanel = p
			if (not (tempPanel:IsOpen())) or (tempPanel == panel) or (not tempPanel.m_autoOrder) then
				
			else
				local orderHight = tempPanel:GetOrder() + 10
				if orderHight > order then
					order = orderHight
				end
			end
		end
		
		if order >= AUTO_ORDER_MAX then
			logError("面板动态层级超过了最大值:"..panel.m_name)
		end
		
		panel:SetOrder(order)
	end
	
	--置顶
	if panel.m_canTop and (not topPanel or topPanel:GetOrder() <= panel:GetOrder()) then
		if topPanel then
			topPanel:SetTop(false)
		end
		
		topPanel = panel
		--如果有正在关闭的顶层窗口，现在打开了一个置顶的窗口，那么正在关闭的顶层窗口多半被挡住了，那么就把它设置成false
		closingTopPanel = false
		panel:SetTop(true)
	end
	
end

function CheckCloseTopAndAutoOrder(panel, needAniClose)
	
	--设置成正在关闭的顶层窗口
	if panel.m_canTop then
		if panel:IsTop() and needAniClose then
			closingTopPanel = panel
		else
			closingTopPanel = false
		end
	end
	
	--取消置顶
	if panel:IsTop() then
		if topPanel ~= panel then
			local topName = ""
			if topPanel then
				topName = topPanel.m_name
				topPanel:SetTop(false)
			end
			logError("逻辑错误.面板标记为顶层，于管理器不符.面板:"..panel.m_name.."  管理器的顶层面板"..topName)
			
		end
		
		panel:SetTop(false)
		--找到除了要关闭界面之外的一个顶层面板
		local top = false
		local tempPanel = false
		for _,p in pairs(panelList) do
			tempPanel = p
			if tempPanel == panel or (not tempPanel:IsOpen()) or tempPanel.m_isAniPlaying or (not tempPanel.m_canTop) then
				
			else
				if (not top) or top:GetOrder() < tempPanel:GetOrder() then
					top = tempPanel
				end
			end
		end
		topPanel = top
		if topPanel then
			topPanel:SetTop(true)
		end
		
	end
	
end


function CheckTopByOtherPanelClose(panel)
	if closingTopPanel == panel then
		closingTopPanel = false
	end
	
	if topPanel then
		topPanel:CheckTop()
	end
end

