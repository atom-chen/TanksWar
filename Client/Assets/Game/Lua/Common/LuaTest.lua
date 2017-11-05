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
-- putContainer:AddCardGroup(cardData)

RoomMgr.OnExitRoom()