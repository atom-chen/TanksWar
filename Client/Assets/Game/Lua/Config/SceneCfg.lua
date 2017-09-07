
module(..., package.seeall)

cfg = {
    {id = 1000,	name = "战斗场景1",		sceneName = "level1",},
	{id = 1001,	name = "战斗场景2",		sceneName = "scene2",},   
}

function Get(id)
	for i = 1, #cfg do
		if cfg[i].id == id then
			return cfg[i]
		end
	end

	logError("找不到场景id"..id)
	return
end