-- Game.lua
-- Author : Dzq
-- Date : 2017-05-21
-- Last modification : 2017-05-21
-- Desc: Game类

require "Common.Define"
require "Common.Global"
--require "coroutine"
--管理器--
Game = {};
Game.CurMod = "None"
Game.XXTEAKey = "UpAvieKT2!DASI&6vux*P$KEiYNtTu6d"
Game.GameFlag = "0003"
Game.IsReconnect = false 	--记录是否断线重连
Game.isLoadMain = false

local this = Game
local coLoad = nil

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
	-- gameMgr.SetDebugShow(g_Config.bShowDebug)
	
	----加载资源
	coLoad = coroutine.start(this.CoLoadModule, Module.Main)
	----协程等待加载完资源
	coroutine.start(this.CoUpdateProgress)
end

--加载游戏模块--
function Game.CoLoadModule(modName)

	logWarn("CoLoadModule -- "..modName.."| curMod--"..Game.CurMod)

	if Game.CurMod ~= "None" then
		logWarn("game UnLoadModule --- ")
		Game.UnLoadModule()
	end

	Game.CurMod = modName
	gameMgr.SetCurMod(modName)
    SceneMgr.CoChange(ModuleScene[modName])

	----返回大厅时 资源就不要重复加载了
	if Game.CurMod == Module.Main and Game.isLoadMain then
		return
	end

    UIMgr.CoInit(modName)
    CtrlMgr.CoInit(modName)
    PlayerMgr.CoInit(modName)
    --加载模块内脚本
    -- log('ModuleScript['..modName..'] -- '..#ModuleScript[modName])
    for i=1,#ModuleScript[modName] do
    	local script = ModuleScript[modName][i]
    	-- log('脚本- module --'..script)
    	require ('Modules.'..modName..'.'..script)
    	-- _G[script] = require ('Modules.'..modName..'.'..script)
    end
    --加载通用脚本
    -- log('ModuleScript[Common] -- '..#ModuleScript[Module.Common])
    for i=1,#ModuleScript[Module.Common] do
    	local script = ModuleScript[Module.Common][i]
    	-- log('脚本- common --'..script)
    	require ('Modules.'..Module.Common..'.'..script)
    	-- _G[script] = require ('Modules.'..modName..'.'..script)
    end

	if Game.CurMod ~= Module.Main and Game.CurMod ~= "None" then
		local num = 0
		local ctrlNum = 0
		for k,v in pairs(_G[modName..'_Panel']) do
			ctrlNum = ctrlNum + 1
		end

		-- logWarn("ctrlNum -- "..ctrlNum)
		while ctrlNum ~= num do
			num = UIMgr.GetModuleLoadNum()
			-- logWarn('num -- '..num)
			coroutine.step(1)
		end
	end
end

--卸载游戏模块--
function Game.UnLoadModule()

	----大厅内资源就不要卸载了
	if Game.CurMod == Module.Main or Game.CurMod == "None" then
		return
	end

	CtrlMgr.UnLoad(Game.CurMod)
	UIMgr.UnLoad(Game.CurMod)
	PlayerMgr.UnLoad(Game.CurMod)

	--卸载模块内脚本
	local modName = Game.CurMod
	-- log(' modName -- '..modName)
    -- log('unload ModuleScript[modName] -- '..#ModuleScript[modName])
    for i=1,#ModuleScript[modName] do
    	local script = ModuleScript[modName][i]
    	package.loaded['Modules.'..modName.."."..script] = nil
    	_G[script] = nil
    end

end

--更新进度
function Game.CoUpdateProgress()
	-- logWarn("CoUpdateProgress ----- ")
	local num = 0
	local ctrlNum = CtrlMgr.GetCurCtrlNum() + CtrlMgr.GetCommonCtrlNum() + 2
	-- logWarn("ctrlNum -- "..ctrlNum)
	while ctrlNum ~= num do
		num = CtrlMgr.LoadedNum()
		-- logWarn('num -- '..num)
		if CtrlMgr.curLoadName then
			local str = "加载资源--->>"..CtrlMgr.curLoadName
			local data = math.floor((num/ctrlNum)*100)
			UILoading.Instance:UpdateProgress(data, str, "")
		end
		coroutine.step(1)
	end
	CtrlMgr.curLoadName = false
	
	this.OnLoadFinish()
end

--加载完成
function Game.OnLoadFinish(tbl)
	UILoading.Instance:LoadEnd()
	-- gameMgr.OnLoadEnd()
	-- log("OnLoadFinish tbl ----- "..tostring(tbl))
	LocalConfig = util.LoadFile(g_Config.configFileName) or {}
	-- LocalConfig = {}

	CtrlMgr.OnLoadFinish(Game.CurMod)
	UIMgr.OnLoadFinish(Game.CurMod)
	PlayerMgr.OnLoadFinish(Game.CurMod)

	SoundMgr.OnLoadFinish()

	if not Game.isLoadMain then
		Network.Start()
	end

	if Game.CurMod == Module.Main then
		SoundMgr.PlayBG(SoundCfg.common_hallBg, true)
	end

	Game.isLoadMain = true

	local moduleCtrl = CtrlMgr.GetModuleCtrl()
	if moduleCtrl then
		moduleCtrl:StartModule(tbl)
	else
		util.LogError("没有找到 Module Ctrl  ")
	end
end

--获取当前模块
function Game.GetCurMod()
	return Game.CurMod
end

function Game.Update()
	--log("Game.Update ---------- ")
	UIMgr.Update()
	Network.Update()
	PlayerMgr.Update()
end

--销毁--
function Game.OnDestroy()
	-- log('Game OnDestroy--->>>');
	this.UnLoadModule()
end

function Game.OnMessage(key, data)
	Event.Brocast(tostring(key), tonumber(data))
end

function Game.OnConnected()
	log("Game OnConnected --- ")
end


function Game.SetAndroidPlatform()
	Platform.Android = true
end


function Game.SetIphonePlatform()
	Platform.Iphone = true
end

function Game.SetEditorrPlatform()
	Platform.Editor = true
end
