--------------------------------------------------------------------------------
--      一些工具函数函数
--------------------------------------------------------------------------------

module("util",package.seeall)

jsonUtil = require "3rd.cjson.util"

local compType = typeof(UnityEngine.Component)
local goType = typeof(UnityEngine.GameObject)
local monoTableType = typeof(MonoTable)
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

function AddComponentIfNoExist(go, comp)
	-- log("AddComponentIfNoExist -- "..tostring(comp))
	local co = go:GetComponent(tostring(comp))
	if (not co or co == null) then
	    return go:AddComponent(comp)
	else
	    return co
	end
end

function GetUVPosByCard(id)
	local ny = Bit.andOp(id, 0xF0)%0x0F
	local nx = Bit.andOp(id, 0x0F)

	--定义的牌和显示的图片有出入 需要处理下
	if ny == 1 then		--万
		ny = 2
	elseif ny == 2 then	--筒
		ny = 3
	elseif ny == 3 then	--条
		ny = 1
    elseif ny == 5 then	--花
        if id == 0x51 then	--春
        	ny = 4
        	nx = 8
    	elseif id == 0x52 then	--夏
    		ny = 5
    		nx = 1
		elseif id == 0x53 then	--秋
			ny = 5
			nx = 2
		elseif id == 0x54 then	--冬
			ny = 4
			nx = 9
		elseif id == 0x55 then	--梅
			ny = 5
			nx = 3
		elseif id == 0x56 then	--兰
			ny = 5
			nx = 4
		elseif id == 0x57 then	--竹
			ny = 5
			nx = 5
		elseif id == 0x58 then	--菊
			ny = 5
			nx = 6
    	end
	end

	return ny, nx
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
			--string.find(tostring(comp), tostring(typeof(ButtonEx)))
			if (string.find(tostring(comp), "UI.StateHandle")) then
				comp:Clear()	
			end
		end
		UIMgr.RemovePanel(scriptName)
		
		ctrl:OnCreate(go)
		ctrl:OpenPanel()
	end

	if string.find(scriptName, "Cfg") then
		if prevFilePath ~= "" then
			filePath = prevFilePath
		end
		package.loaded[filePath] = nil
		local ok, err = pcall( function() _G[scriptName] = require(filePath) end)
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
		if not mod then
			logError("ctrl为空："..scriptName)
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
		local panel = mod.m_panel
		local modul = mod.m_modName
		CtrlMgr.RemoveCtrl(scriptName)

		local ctrl = _G[scriptName].New(modul)
		ctrl:Init()
		CtrlMgr.AddCtrl(ctrl.m_id, ctrl)
	end
	
end

function SaveFile(fileName, tbl)
	if Platform.Editor then  -- pc上就直接存在项目目录下 否则打包资源时会被删掉
		jsonUtil.file_save(fileName, cjson.encode(tbl))
	else
		jsonUtil.file_save(Util.DataPath..fileName, cjson.encode(tbl))
	end
end

function LoadFile(fileName)
	if not fileName or type(fileName) ~= "string" or fileName == "" then
		logError("传入文件名不正确 fileName--"..tostring(fileName))
		return nil
	end
	local cfg
	if Platform.Editor then  -- pc上就直接存在项目目录下 否则打包资源时会被删掉
		cfg = jsonUtil.file_load(fileName)
	else
		cfg = jsonUtil.file_load(Util.DataPath..fileName)
	end

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

function OnGM(param)
	log("OnGm --- "..param)
	local paramList = string.split(param, " ")
	for k, v in pairs(paramList) do
		log(" k -- "..k..' v - '..v)
	end
	
	local protoId = 0
	local data = {}
	local mySelf = PlayerMgr.GetMyself()
	if string.lower(paramList[1]) == "depart" then
		protoId = proto.forceDepart
		local roomId = paramList[2]
		if not roomId then
			roomId = mySelf:Get("roomId")
		else
			roomId = tonumber(roomId)
		end
		log("roomId -- "..roomId)
		data.roomId = roomId
	elseif string.lower(paramList[1]) == "departallroom" then
		coroutine.start(function()
			local roomList = {871232,987876,876543,234263,123584,545678,548971,658945,215456,456546,564654,555688,565656,465878,456413,545878,564897,568988,965682,657852,478974,474512,567787}
			for _,v in pairs(roomList) do
				protoId = proto.forceDepart
				data.roomId = v
				local res = NetWork.Request(protoId, data)
				if res.code ~= 0 then
					UIMgr.Open(Common_Panel.TipsPanel, res.msg)
				end
			end
		end)
		UIMgr.Open(Common_Panel.TipsPanel, "执行GM命令成功")
		return
	else
		UIMgr.Open(Common_Panel.TipsPanel, "命令错误："..param)
		return
	end

	coroutine.start(function()
		local res = NetWork.Request(protoId, data)
		if res.code == 0 then
			UIMgr.Open(Common_Panel.TipsPanel, "执行GM命令成功")
			return
		else
			UIMgr.Open(Common_Panel.TipsPanel, res.msg)
			return
		end
	end)

end