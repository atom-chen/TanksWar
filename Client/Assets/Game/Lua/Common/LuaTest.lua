
-- local panel = UIMgr.Get(FYMJ_Panel.EndPanel)
-- panel:OnRestartClick()

	-- coroutine.start(function()
	-- 	local res = NetWork.Request(proto.fy_ready)
	-- 	if res.code == 0 then
	-- 		log("发送准备成功")
	-- 	else
	-- 		UIMgr.Open(Common_Panel.TipsPanel, res.msg)
	-- 	end
	-- end)
-- for k, v in pairs(RoomMgr.m_endInfo) do
-- 	log("k -- "..k.." v = "..tostring(v))
-- end

-- log(type(RoomMgr.m_endInfo.hand).." num -- "..#RoomMgr.m_endInfo.hand["20631"])

-- local target = PlayerMgr.Get(94479)
-- local score = 254
-- local pList = PlayerMgr.GetAll()
-- for k,v in pairs(pList) do
-- 	Event.Brocast(Msg.ShowScore, v, math.random(-100, 100))
-- end

-- local player = PlayerMgr.GetMyself()
-- -- local player = PlayerMgr.Get(52520)
-- local handCon = player:GetContainer(ContainerType.SELF)
-- local card = handCon.m_cardsItem[1]
-- local args = System.Collections.Hashtable.New()
-- -- args:Add("x", 0)
-- -- args:Add("islocal", true)
-- -- args:Add("time", 0.1)

-- args:Add("islocal", true)
-- args:Add("time", 0.5)
-- iTween.MoveTo(card.m_go, args)
-- iTween.MoveTo(card.m_go, iTween.Hash("x", 0.136, "islocal", true, "time", 0.1))

-- local player = PlayerMgr.GetMyself()
-- -- local player = PlayerMgr.Get(52520)
-- local handCon = player:GetContainer(ContainerType.SELF)
-- local card = handCon.m_cardsItem[1]
-- -- card:MoveBy(Vector3.New(0.1, 0.01, 0))
-- local offx = 0.034*handCon.m_vCfg.selfScale.x
-- log("offx -- "..offx)
-- log("x "..card.m_go.name.."-- "..card.m_go.transform.position.x.." y -- "..card.m_go.transform.position.y.." z -- "..card.m_go.transform.position.z)
-- log("x "..card.m_go.name.."-- "..card.m_go.transform.localPosition.x.." y -- "..card.m_go.transform.localPosition.y.." z -- "..card.m_go.transform.localPosition.z)
-- iTween.MoveTo(card.m_go, iTween.Hash("x", 0.136, "islocal", true, "time", 0.1))

-- iTween.MoveTo(card.m_go, iTween.Hash("path", Tran_pathPoint, "easetype", "linear", "speed", 3, "movetopath", false, "orienttopath", true, "looktarget", pathpoints[points – 1], "looktime", 0.1f, "delay", 0.5f, "lookahead", 0.01f, "islocal", true, "oncomplete", "Walked"))

-- coroutine.start(function()
-- 	coroutine.wait(2)
-- 	log("222 x "..card.m_go.name.."-- "..card.m_go.transform.position.x.." y -- "..card.m_go.transform.position.y.." z -- "..card.m_go.transform.position.z)
-- 	log("222 x "..card.m_go.name.."-- "..card.m_go.transform.localPosition.x.." y -- "..card.m_go.transform.localPosition.y.." z -- "..card.m_go.transform.localPosition.z)
-- end)


-- card:PlayDealAni()

-- SceneMgr.ChangeScene("FYMJ")

-- log(#package.loaded)
-- for k,v in pairs(package.loaded) do
-- 	if string.find(k, "RoomMgr") then
-- 		log(' k '..k)
-- 	end
-- end
-- log(tostring(typeof(UVTools)))
-- log(tostring(typeof(StateHandle)))

-- local player = PlayerMgr.GetMyself()
-- -- local handContainer = player:GetContainer(ContainerType.HAND)
-- -- local cards = {9,2,3,4,6,6}
-- -- handContainer:Init(cards)
-- local cards = {
-- 	-- handCards = {0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x41, 0x42, 0x43, 0x44},
-- 	-- handCards = 15,
-- 	-- handCards = {0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47},
-- 	handCards = {0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57, 0x58},
-- 	putCards = {0x21, 0x22, 0x23, 0x24, 0x25, 0x26},
-- 	-- putCards = {},
-- 	chiCards = {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39,},
-- 	-- chiCards = {},
-- }

-- player:SetSit(PlayerSit.Bottom)

-- player:InitCards(cards)
-- player:FreshCards()

-- local player = PlayerMgr.Get(2)
-- local putContainer = player:GetContainer(ContainerType.CHI)

-- local cardData = {
-- 	cards = {0x31,0x32,0x33,0x34},
-- 	showType = CardShowType.CHI,
-- 	otherId = 1234
-- }
-- putContainer:AddCardGroup(cardData)

-- RoomMgr.Init()

-- local tableContainer = RoomMgr.GetTableContainer()
-- tableContainer:RemoveCardsInEnd(1)

-- local tablePanel =  UIMgr.Get(FYMJ_Panel.TablePanel)
-- tablePanel:ShowPeng()

-- RoomMgr.m_info.lastCardNum = 100

-- RoomMgr.InitTableView()

-- local pList = PlayerMgr.GetAll()
-- for k, v in pairs(pList) do
-- 	v:FreshCards()
-- end
-- for i=1,3 do
-- 	RoomMgr.m_tableContainer:HideCardByIdx(1)
-- end

-- local encrypt_data = XXTEA.EncryptToBase64String("{wiego=23irlkm-=304tlr=-lkdfjg904m}", Game.XXTEAKey);
-- log(encrypt_data)

-- local recTbl = cjson.decode('{"info":"IUh9UDhOSn7zY/UiR6kQ3CtLWzsBpOT2NlUKfrJP/yZmrtnxfC+c5V+oEHPgLIhtV83SwD05oIC6le86F2c8+2fG1LlRirXT3IVAAga5/xIzNdkv5Vc6zhlJHYkRHiwwytdgGCjBMnHvw8D9baVfy9M2KvSETfY/5bvzMQ=="}')
-- log(Game.XXTEAKey)
-- local tbl = XXTEA.DecryptBase64StringToString(encrypt_data, Game.XXTEAKey)
-- local tbl = XXTEA.DecryptBase64StringToString("fSrQ+L5VPrWPxN2TdZn6ROaTk/MuF0GCLty5enEy4Zco3WqQT5/piLOw4hLfjD52CMbzwN3j41M=", Game.XXTEAKey)
-- log("tbl---"..tostring(tbl))
-- log("recTbl.info - "..recTbl.info)
-- log(tbl.token)


-- -- local player = PlayerMgr.GetMyself()
-- local player = PlayerMgr.Get(19072)
-- local putContainer = player:GetContainer(ContainerType.CHI)
-- -- putContainer:RemoveCardGroup(CardShowType.PENG, {0x33,0x33,0x33})

-- local cardData = {
-- 	cards = {0x33,0x33,0x33,0x33},
-- 	showType = CardShowType.MINGGANG,
-- 	otherId = 1234
-- }
-- putContainer:AddCardGroup(cardData))


-- local p = PlayerMgr.Get(28878)
-- local p = PlayerMgr.GetBySit(3)
-- local handCon = p:GetContainer(ContainerType.HAND)
-- local go = handCon.m_cardsItem[1]:GetGameObject()
-- local item = handCon.m_cardsItem[#handCon.m_cardsItem]
-- item:PlayMoAni()
-- iTween.RotateBy(go, iTween.Hash("x", 0.25, "delay", 0.2))

-- iTween.RotateBy(go, Vector3.New(-90, 0, 0), 0.001)
-- iTween.RotateBy(go, Vector3.New(0.25, 0, 0), 0.5) 

-- local clip = ResTool.GetAudioClip("ui_click")
-- AudioSource.PlayClipAtPoint(clip, Vector3.one)

-- local pList = PlayerMgr.GetAll()

-- for k,v in pairs(pList) do
-- 	local handCon = v:GetContainer(ContainerType.HAND)
-- 	handCon:Init({49,50,24,37,19,52,66,37,50,19,56,51,35})
-- 	handCon:SortItem()
-- 	handCon:OnShowCards(false)
-- 	handCon:OpenCard()
-- end

-- Event.Brocast(Msg.OnEndShow)


-- local player = PlayerMgr.GetMyself()
-- local handCon = player:GetContainer(ContainerType.SELF)
-- local card = handCon.m_cardsItem[1]
-- local meshRender = card.m_childGo:GetComponent("MeshRenderer")
-- log("meshRender -- "..tostring(meshRender))
-- local materials = meshRender.materials
-- for i=1, materials.Length do
-- 	print(" "..tostring(materials[i-1]))
-- end


