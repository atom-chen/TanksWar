-- CtrlMgr.lua
-- Author : Dzq
-- Date : 2017-05-20
-- Last modification : 2017-05-20
-- Desc: Control管理类


module(..., package.seeall)

ctrlList = {};	--控制器列表--
modName = "";
curModCtrl = {}
commonCtrl = {}
curLoadName = false

isLoaded_module_res = false
isLoaded_common_res = false

common_module_num = 0
cur_module_num = 0

function CoInit(mdName)

	modName = mdName

	-- logWarn("ctrl mgr init -- "..mdName)
	----加载资源
	-- log("加载资源 ---- -- ")
	local totleTime = Time.time

	if mdName == Module.Main then 	----公共模块只加载一次
		commonCtrl = _G["Common_Ctrl"]
		local time = Time.time
		curLoadName = "Common_ResMgr"
		panelMgr:LoadUIPrefab("Common")
		if not Platform.Editor then
			while not UIResTool.HasMod("Common") do
				coroutine.step(1)
			end
		end

		isLoaded_common_res = true
		log("加载 [Common Res Mgr] 用时--"..(Time.time - time))

		--加载通用内容--
		for _,cName in pairs(commonCtrl) do
			if Get(cName) == nil then
				-- local time = Time.time
				require ('Modules.Common.Control.'..tostring(cName))
				local ctrl = _G[cName].New("Common")
				ctrl:Init()
				-- if not Platform.Editor then
				-- 	while not ctrl.m_isLoaded do	--加载一个界面要等
				-- 		coroutine.step(1)
				-- 	end
				-- end
				AddCtrl(ctrl.m_id, ctrl)
				-- log("加载 ["..cName.."] 用时--"..(Time.time - time))
			end
		end
	end
	
-----------------------------------------------------------------------
	curModCtrl = _G[modName.."_Ctrl"]
	-- logWarn("curModCtrl --- "..#curModCtrl)
	local time = Time.time
	curLoadName = mdName.."_ResMgr"
	-- logWarn("LoadUIPrefab -- "..mdName)
	panelMgr:LoadUIPrefab(mdName)
	if not Platform.Editor then
		while not UIResTool.HasMod(mdName) do
			coroutine.step(1)
		end
	end
	
	isLoaded_module_res = true
	log("加载 [Module Res Mgr] 用时--"..(Time.time - time))

	
	--加载模块对应资源
	for _,cName in pairs(curModCtrl) do
		-- local time = Time.time
		require ('Modules.'..modName..".Control."..tostring(cName))
		local ctrl = _G[cName].New(mdName)
		ctrl:Init()
		-- if not Platform.Editor then
		-- 	while not ctrl.m_isLoaded do	--加载一个界面要等
		-- 		coroutine.step(1)
		-- 	end
		-- end
		AddCtrl(ctrl.m_id, ctrl)
		-- log("加载 ["..cName.."] 用时--"..(Time.time - time))
	end

	log("加载结束总耗时 -- "..(Time.time - totleTime))
end

function LoadedNum()
	local initNum = 0
	for k,v in pairs(ctrlList) do
		if v.m_isLoaded then
			initNum = initNum + 1
		end
	end
	if isLoaded_common_res then
		initNum = initNum + 1
	end

	if isLoaded_module_res then
		initNum = initNum + 1
	end

	return initNum
end

--添加控制器--
function AddCtrl(ctrlName, ctrlObj)
	curLoadName = ctrlName
	ctrlList[ctrlName] = ctrlObj;
end

--获取控制器--
function Get(ctrlName)
	return ctrlList[ctrlName];
end

function GetModuleCtrl()
	-- log("module ctrl -- "..modName..'Ctrl')
	return ctrlList[modName..'Ctrl']
end

--获取当前模块加载的ctrl个数
function GetCurCtrlNum()
	if cur_module_num ~= 0 then
		return cur_module_num
	end

	local num = 0
	for k,v in pairs(curModCtrl) do
		num = num + 1
	end
	cur_module_num = num
	return cur_module_num
end

--获取通用模块加载的ctrl个数
function GetCommonCtrlNum()
	if common_module_num ~= 0 then
		return common_module_num
	end
	
	local num = 0
	for k,v in pairs(commonCtrl) do
		num = num + 1
	end
	common_module_num = num
	return common_module_num
end

--移除控制器--
function RemoveCtrl(ctrlName)
	if ctrlList[ctrlName] ~= nil then
		ctrlList[ctrlName]:UnLoad()
	end
	ctrlList[ctrlName] = nil;
end

--关闭控制器--
function Close()
	log('CtrlManager.Close---->>>');
end

--卸载模块--
function UnLoad(modName)
	for k,v in pairs(ctrlList) do
		if v and v.m_modName == modName then
			--顺便找到panel卸载
			v.m_panel:UnLoad()	
			UIMgr.RemovePanel(v.m_panelName)
			v.m_panelName = nil

			--卸载ctrl
			v:UnLoad()
			RemoveCtrl(v.m_id)
		end
	end

	--卸载模块对应资源
	for _,cName in pairs(curModCtrl) do
		package.loaded['Modules.'..modName..".Control."..tostring(cName)] = nil
		-- log('卸载脚本--'..'Modules.'..modName..".Control."..tostring(cName))
	end

	cur_module_num = 0
	common_module_num = 0
end