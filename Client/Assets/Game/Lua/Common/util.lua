--------------------------------------------------------------------------------
--      一些工具函数函数
--------------------------------------------------------------------------------

module("util",package.seeall)

local jsonUtil = require "3rd.cjson.util"

local compType = typeof(UnityEngine.Component)
local goType = typeof(UnityEngine.GameObject)
local monoTableType = typeof(UI.MonoTable)
-- 传入一个游戏对象和类型定义，返回table，如果table没有传进来则新建一个
function GetMonoTable(gameObject,define,table)
	table = table or {}
	local monoTable = gameObject:GetComponent(monoTableType)
	if monoTable == nil then
		logError("未绑定MonoTable脚本："..gameObject.name)
		return
	end
	for k,v in pairs(define) do
		--获取类型
		local valueType
		if v == nil or type(v)~="table" then
			valueType = nil
		else
			valueType = typeof(v)
			if(valueType == nil) then 
				valueType = nil 
			elseif goType:Equals(valueType) then --游戏对象
				valueType = true
			elseif valueType:IsSubclassOf(compType) ==false then 
				valueType = nil
			end
		end
		-- 设置值到表上
		if valueType == nil then
			table[k] = v
		elseif valueType == true then--游戏对象
			table[k] = monoTable:getv(k)
		else
			local go = monoTable:getv(k)
			if go then
				table[k] = go:GetComponent(valueType)
			end
		end
		if type(table[k]) == "table" then
			logError("table["..k.."] 类型错误，没有找到这个组件名："..k)
			return
		end
	end
end

--浅复制表，如果to没有传进来，那么新建一个返回
function Clone(from,to)
	to = to or {}
	for k,v in pairs(from) do
		to[k] =v
	end
	return to
end

function CheckTableForPrint(table)
	local t2= {}
	for k,v in pairs(table) do
		local vType = type(v)
		if vType == "table" then
			t2[k] = CheckTableForPrint(v)
		elseif vType == "userdata" then
			t2[k] = tostring(v)
		else
			t2[k] =v
		end      
	end
	return t2
end

--返回表的字符串表示，cjson不能转换userdata，这里要转换下
function PrintTable(table,notPrint)
	local log = cjson.encode(CheckTableForPrint(table))
	if notPrint == nil or notPrint==false then
		LogError(log)
	end
	return log
end

function IsArray(table)
	if type(table) ~= "table" then return false end
	for k,_ in pairs(table)  do      
		if type(k) ~= "number" then
			return false
		end
	end  
	return true
end

--导表出来的lua数组格式有问题，这里转换下
function ParseCfgArray(old)
	local newArray = {}
	if old == nil or type(old) ~= "table" then return newArray end

	--如果是从0开始的数组，转成从1开始
	if old[0] ~= nil then 
		for i = 0,#old do 
			newArray[i+1] =old[i][1]
		end  
	--弄紧凑
	elseif IsArray(old) then
		local i = 1
		local kvs = {}
		for k,v in pairs(old)  do      
			kvs[#kvs+1]={k,v}
		end  
		table.sort(kvs,function(a,b) return a[1]<b[1] end)
		for i =1,#kvs do
			newArray[#newArray+1] =kvs[i][2]
		end
	--键值对转数组
	else
		local i = 1
		for k,v in pairs(old)  do      
			newArray[i] =v
			i =i+1
		end  
	end

	return newArray
end

-- 保证正确调用,无论是lua函数或者c#委托
function SafeCall(fun,...)
	if fun == nil then return end
	
	if type(fun) == "userdata" then
			return UI.UILuaPanel.TryCall(fun,...)
	else
		return fun(...)
	end
end
    
-- 根据值找到key
function IndexOf(table,findValue)
	for k,v in pairs(table) do
		if findValue == v then
			return k
		end
	end
end

--这里会加上堆栈，Debuger没有打印堆栈，print好像只有当前文件的堆栈
function LogError(log)
	Debugger.LogError(""..log.."\n"..debug.traceback())
end

--这里会加上堆栈，Debuger没有打印堆栈，print好像只有当前文件的堆栈
function Log(log)
	Debugger.Log(""..log.."\n"..debug.traceback())
end

local prevFilePath = ""
function OnRefresh(scriptName)
	local findCount = 0
	local filePath = ""
	----与之前刷的脚本不一致 重置prevFilePath
	if not string.find(prevFilePath, scriptName) then
		prevFilePath = ""
	end
	for k,v in pairs(package.loaded) do
		if string.find(k, scriptName) then
			log("refresh script : "..k)
			findCount = findCount + 1
			filePath = k
		end
	end
	if findCount == 0 and prevFilePath == "" then
		logError("未找到脚本："..scriptName)
		return
	end
	if findCount > 1 then
		logError("找到多个脚本名为："..scriptName.." 的脚本，加上路径再刷新")
		return
	end
	
	local mod = {}
	----刷新panel
	if string.find(scriptName, "Panel") then
		--log("是Panel脚本")
		mod = UIMgr.Get(scriptName)
		
		if not mod then
			logError("panel为空："..scriptName)
			return
		end	
		----可能上次刷新失败了
		if prevFilePath ~= "" then
			filePath = prevFilePath
		end
		package.loaded[filePath] = nil
		local ok, err = pcall( function() require(filePath) end)
		if not ok then
			logError('脚本报错：\n'..tostring(err))
			prevFilePath = filePath
			return
		end
		
		prevFilePath = ""
		local go = mod.m_go
		local ctrl = mod.m_ctrl
		--清空button事件
		for _,comp in pairs(mod.m_comp) do
			--string.find(tostring(comp), tostring(typeof(UIButtonEx)))
			if (string.find(tostring(comp), "UI.StateHandle")) then
				comp:Clear()	
			end
		end
		UIMgr.RemovePanel(scriptName)
		
		ctrl:OnCreate(go)
		ctrl:OpenPanel()
	end

	----刷新item
	if string.find(scriptName, "Panel") and string.find(scriptName, "Item") then
		local panelList = UIMgr.GetAll()
		local panel = nil
		for i=1, #panelList do
			if string.find(scriptName, panelList[i].m_name) then
				panel = panelList[i]
				break
			end
		end
		if not panel then
			logError("未找到脚本"..scriptName.."的父级panel 可能名字错误")
			return
		end
		log("刷新item------")
	end

	----刷新Cfg
	if string.find(scriptName, "Cfg") then
		if prevFilePath ~= "" then
			filePath = prevFilePath
		end
		package.loaded[filePath] = nil
		local ok, err = pcall( function() require(filePath) end)
		if not ok then
			logError('脚本报错：\n'..tostring(err))
			prevFilePath = filePath
			return
		end
	end
	
	----刷新ctrl
	if string.find(scriptName, "Ctrl") then
		--log("是Ctrl脚本")
		mod = CtrlMgr.Get(scriptName)
	end
	
end

function SaveFile(fileName, tbl)
	jsonUtil.file_save(fileName, cjson.encode(tbl))
end

function LoadFile(fileName)
	if not fileName or type(fileName) ~= "string" or fileName == "" then
		logError("传入文件名不正确 fileName--"..tostring(fileName))
		return nil
	end
	local cfg = jsonUtil.file_load(fileName)
	if cfg ~= "null" and cfg then
		return cjson.decode(cfg)
	end
	
	return nil
end

function Test()
	if prevFilePath ~= "" then
		filePath = prevFilePath
	end
	package.loaded["Common.LuaTest"] = nil
	local ok, err = pcall( function() require("Common.LuaTest") end)
	if not ok then
		logError('Test 脚本报错：\n'..tostring(err))
		prevFilePath = filePath
		return
	end
end