-- SceneMgr.lua
-- Author : Dzq
-- Date : 2017-09-06
-- Last modification : 2017-09-06
-- Desc: Scene管理类

module(..., package.seeall)

local modName = ""
function CoInit(mdName)

	-- log("SceneMgr.Init----->>>");
end

function ChangeScene(sceneId)
	local info = SceneCfg.Get(sceneId)
	log("info --- "..info.sceneName)
	SceneManager.LoadScene(info.sceneName)
end

--更新
function Update()

end


--卸载模块--
function UnLoad(modName)

end