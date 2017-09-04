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

	commonCtrl = _G["Common_Ctrl"]
	curModCtrl = _G[modName.."_Ctrl"]


	----加载资源
	-- log("加载资源 ---- -- ")
	local time = Time.time
	local totleTime = Time.time
	curLoadName = mdName.."_ResMgr"
	panelMgr:LoadUIPrefab(mdName)
	-- while not UIResTool.HasMod(mdName) do
	-- 	coroutine.wait(1)
	-- end
	isLoaded_module_res = true
	-- log("加载 [Module Res Mgr] 用时--"..(Time.time - time))
	
	coroutine.wait(1)

	local time = Time.time
	panelMgr:LoadUIPrefab("Common")
	curLoadName = "Common_ResMgr"
	-- while not UIResTool.HasMod("Common") do
	-- 	coroutine.wait(1)
	-- end

	coroutine.wait(1)
	isLoaded_common_res = true
	-- log("加载 [Common Res Mgr] 用时--"..(Time.time - time))

	--加载通用内容--
	for _,cName in pairs(commonCtrl) do
		if Get(cName) == nil then
			local time = Time.time
			require ('Modules/Common/Control/'..tostring(cName))
			local ctrl = _G[cName].New("Common")
			ctrl:Init()
			-- while not ctrl.m_isLoaded do	--加载一个界面要等
			-- 	coroutine.wait(1)
			-- end
			AddCtrl(ctrl.m_id, ctrl)
			-- log("加载 ["..cName.."] 用时--"..(Time.time - time))
		end
	end

	--加载模块对应资源
	for _,cName in pairs(curModCtrl) do
		local time = Time.time
		require ('Modules/'..modName.."/Control/"..tostring(cName))
		local ctrl = _G[cName].New(mdName)
		ctrl:Init()
		-- while not ctrl.m_isLoaded do	--加载一个界面要等
		-- 	coroutine.wait(1)
		-- end
		AddCtrl(ctrl.m_id, ctrl)
		-- log("加载 ["..cName.."] 用时--"..(Time.time - time))
	end

	-- log("加载结束 ----耗时 -- "..(Time.time - totleTime))
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

function GetMainCtrl()
	return ctrlList["MainCtrl"]
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
		if v then
			v:UnLoad()
		end
	end
end