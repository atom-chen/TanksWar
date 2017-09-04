-- Game.lua
-- Author : Dzq
-- Date : 2017-05-21
-- Last modification : 2017-05-21
-- Desc: Game类

require "Define"
require "Global"
--require "coroutine"
--管理器--
Game = {};
Game.CurMod = "None"

local this = Game
local coLoad = nil

--初始化完成，发送链接服务器信息--
function Game.OnInitOK()
	gameMgr.SetDebugShow(g_Config.bShowDebug)
	
	----加载资源
	coLoad = coroutine.start(this.CoLoadModule, Module.Main)
	----协程等待加载完资源
	coroutine.start(this.CoUpdateProgress)
end

--加载游戏模块--
function Game.CoLoadModule(modName)
	Game.CurMod = modName
	gameMgr.SetCurMod(modName)
    UIMgr.CoInit(modName)
    CtrlMgr.CoInit(modName)
    PlayerMgr.CoInit(modName)
end

--卸载游戏模块--
function Game.UnLoadModule()
	
	UIMgr.UnLoad(Game.CurMod)
	CtrlMgr.UnLoad(Game.CurMod)

	Game.CurMod = "None"
	gameMgr.SetCurMod(Game.CurMod)
end

--更新进度
function Game.CoUpdateProgress()
	local num = 0
	local ctrlNum = CtrlMgr.GetCurCtrlNum() + CtrlMgr.GetCommonCtrlNum() + 2
	-- log("ctrlNum -- "..ctrlNum)
	while ctrlNum ~= num do
		num = CtrlMgr.LoadedNum()
		-- logWarn('num -- '..num)
		if CtrlMgr.curLoadName then
			local str = "加载资源--->>"..CtrlMgr.curLoadName
			local data = math.floor((num/ctrlNum)*100)
			UILoading.Instance:UpdateProgress(data, str)
		end
		coroutine.step(1)
	end
	CtrlMgr.curLoadName = false
	
	this.OnLoadFinish()
	-- log("OnLoadFinish ------ ")
	
end

--加载完成
function Game.OnLoadFinish()
	UILoading.Instance:LoadEnd()
	gameMgr.OnLoadEnd()

	LocalConfig = util.LoadFile(g_Config.configFileName) or {}

	local mainCtrl = CtrlMgr.GetMainCtrl()
	if mainCtrl then
		mainCtrl:StartModule()
	else
		logError("没有找到MainCtrl  ")
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
end

--销毁--
function Game.OnDestroy()
	-- log('Game OnDestroy--->>>');
	this.UnLoadModule()
end
