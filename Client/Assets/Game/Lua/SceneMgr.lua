-- SceneMgr.lua
-- Author : Dzq
-- Date : 2017-09-26
-- Last modification : 2017-09-26
-- Desc: Scene管理类 负责切换场景资源处理


module(..., package.seeall)

function ChangeScene(sceneName)
	log("开始切换场景--"..sceneName)
	UIMgr.Open(Common_Panel.WaitPanel)
	coroutine.start(CoChange, sceneName)
end

function CoChange(sceneName)
	
	if sceneName == "" then
		-- log("无场景切换")
		return
	end

	Event.Brocast(Msg.ChangeSceneStart, sceneName)

	if not Platform.Editor then
		-- 需要先加载assetbundle
		local abName = string.lower(Game.CurMod).."_scene"

		local bLoaded = false
		resMgr:LoadScene(abName, sceneName, function(go) logWarn("go --"..tostring(go).." goType -- "..type(go)) bLoaded = true end, nil)

		while not bLoaded do
			log("等待加载场景")
			coroutine.step(1)
		end
	end
	
	local op = SceneManager.LoadSceneAsync(sceneName)
	while not op.isDone do
		coroutine.step(1)
	end
	UIMgr.CloseAll()
	log("切换场景完成")
	Event.Brocast(Msg.ChangeSceneEnd, sceneName)
end