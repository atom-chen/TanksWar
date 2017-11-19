-- BasePlayer.lua
-- Author : Dzq
-- Date : 2017-08-29
-- Last modification : 2017-08-29
-- Desc: BasePlayer 玩家基类
BasePlayer = Class();
  
function BasePlayer:Ctor()
	self.m_info = false
	self.m_cards = {}
	self.m_cardsRoot = false
	self.m_selfRoot = false
	self.m_handRoot = false 	--自己放在桌上的手牌
	self.m_putRoot = false
	self.m_chiRoot = false
	self.m_container = {}

	self.msgIdList = {}
end

function BasePlayer:Init(param)
	--{"nick":"游客_8243","avatar":"","openId":"","userId":57342,"ip":"",
	--"rounds":0,"gold":0,"guestId":"4248518626994161518239593","diamond":100,
	--"identityNum":"","createtime":1506069407,"phone":"","gender":1,"parentId":0,
	--"token":"8ed6f3006cbc64c1aa43b652b5874ba5","fresh":0,"name":"","roomId":0,"pos":""}
	self.m_info = param
	self.m_selfRoot = false
	self.m_putRoot = false
	self.m_chiRoot = false
	self.m_handRoot = false

	--默认设置在线
	self.m_info.bOnline = true

	self:OnInit()
end

--进入房间的初始化操作
function BasePlayer:EnterRoom()

	self:OnEnterRoom()
end

--离开房间的清除操作
function BasePlayer:LeaveRoom()

	self:OnLeaveRoom()
end

--------------------------------------------------------基本属性-------------------------------------------

----获取玩家属性值
function BasePlayer:Get(attr)
	return self.m_info[attr]
end

function BasePlayer:IsMyself()
	return PlayerMgr.IsMyself(self)
end

function BasePlayer:GetAvatar()
	return self.m_info.avatar
end

function BasePlayer:GetName( )
	return self.m_info.nick
end

function BasePlayer:GetID()
	return self.m_info.userId
end

function BasePlayer:GetGold( )
	return self.m_info.gold
end

function BasePlayer:GetDiamond( )
	return self.m_info.card
end

function BasePlayer:GetInfo()
	return self.m_info
end

function BasePlayer:GetReady()
	return self.m_info.ready
end

function BasePlayer:GetIsOnline()
	return self.m_info.bOnline
end

--位置
function BasePlayer:GetSit()
end

--朝向
function BasePlayer:GetDir()
	return self.m_info.dir
end

-----------------------------------------------------------------------------------------------------------


--------------------------------------------------------牌局相关-------------------------------------------

function BasePlayer:InitCards(cards)
	self.m_cards = cards
	self.m_cardsRoot = find("playerCard").transform
	if self.m_cardsRoot == nil then
		logError("没找到牌根节点")
		return
	end
	local sit = self:GetSit()
	-- log("id - "..self:GetID().." isMyself -- "..tostring(self:IsMyself()))
	if self:IsMyself() then 	----手牌自己的
		local tablePanel = UIMgr.Get(_G[Game.CurMod.."_Panel"].TablePanel)
		self.m_selfRoot = tablePanel:GetCardsRoot()
		self.m_selfRoot.gameObject:SetActive(true)
	end

	if self.m_selfRoot == nil then
		util.LogError("未找到 ".."player"..sit.."self")
		return
	end

	local handName = "player"..sit.."hand"
	self.m_handRoot = self.m_cardsRoot:Find(handName)
	-- log("find player put -- "..tostring(self.m_putRoot.name))
	if self.m_handRoot == nil then
		util.LogError("未找到 ".."player"..sit.."hand")
		return
	end

	local putName = "player"..sit.."put"
	self.m_putRoot = self.m_cardsRoot:Find(putName)
	-- log("find player put -- "..tostring(self.m_putRoot.name))
	if self.m_putRoot == nil then
		util.LogError("未找到 ".."player"..sit.."put")
		return
	end
	
	local chiName = "player"..sit.."chi"
	self.m_chiRoot = self.m_cardsRoot:Find(chiName)
	-- log("find player chi -- "..tostring(self.m_chiRoot.name))
	if self.m_chiRoot == nil then
		util.LogError("未找到 ".."player"..sit.."chi")
		return
	end

	local viewCfg = ViewCfg[sit]
	-- log(" viewCfg.handScale "..tostring(viewCfg.handScale))
	if self.m_selfRoot then
		self.m_selfRoot.localScale = viewCfg.selfScale
		self.m_selfRoot.localEulerAngles = viewCfg.selfAngle
		self.m_selfRoot.localPosition = viewCfg.selfPos
		for i=0, (self.m_selfRoot.childCount-1) do
			self.m_selfRoot:GetChild(i).gameObject:SetActive(false)
		end
	end
	
	self.m_putRoot.localScale = viewCfg.putScale
	self.m_putRoot.localEulerAngles = viewCfg.putAngle
	self.m_putRoot.localPosition = viewCfg.putPos
	for i=0, (self.m_putRoot.childCount-1) do
		self.m_putRoot:GetChild(i).gameObject:SetActive(false)
	end

	self.m_chiRoot.localScale = viewCfg.chiScale
	self.m_chiRoot.localEulerAngles = viewCfg.chiAngle
	self.m_chiRoot.localPosition = viewCfg.chiPos
	for i=0, (self.m_chiRoot.childCount-1) do
		self.m_chiRoot:GetChild(i).gameObject:SetActive(false)
	end

	self.m_handRoot.localScale = viewCfg.handScale
	self.m_handRoot.localEulerAngles = viewCfg.handAngle
	self.m_handRoot.localPosition = viewCfg.handPos
	for i=0, (self.m_handRoot.childCount-1) do
		self.m_handRoot:GetChild(i).gameObject:SetActive(false)
	end

	self:CreateContainer(ContainerType.HAND):Init(self.m_cards.handCards)
	self:CreateContainer(ContainerType.PUT):Init(self.m_cards.putCards)
	self:CreateContainer(ContainerType.CHI):Init(self.m_cards.chiCards)
	if self:IsMyself() then
		local con = self:CreateContainer(ContainerType.SELF)
		con:Init(self.m_cards.handCards)
	end
	self:OnInitCards()
end

--创建牌
function BasePlayer:CreateContainer(conType, cards)
	
	if ContainerType.NONE == conType then
		logError("空容器类型")
		return
	elseif ContainerType.HAND == conType then
		self.m_container[conType] = HandContainer.New(self.m_handRoot)
	elseif ContainerType.PUT == conType then
		self.m_container[conType] = PutContainer.New(self.m_putRoot)
	elseif ContainerType.CHI == conType then
		self.m_container[conType] = ChiContainer.New(self.m_chiRoot)
	elseif ContainerType.SELF == conType then
		self.m_container[conType] = SelfContainer.New(self.m_selfRoot)
	end
	
	self.m_container[conType]:SetOwner(self)

	----可以先不初始化 只创建
	if type(cards) == "table" and #cards ~= 0 then
		log("createcontainer ---type "..conType.." num - "..#cards..' ismyself -'..tostring(self:IsMyself()))
		self.m_container[conType]:Init(cards)
	end
	
	return self.m_container[conType]
end

function BasePlayer:GetContainer(conType)
	return self.m_container[conType]
end

function BasePlayer:FreshCards()
	for _,cont in pairs(self.m_container) do
		cont:Fresh()
	end
end

-----------------------------------------------------------------------------------------------------------

--------------------------------------------------------消息处理-------------------------------------------

function BasePlayer:AddEvent(msgID, callback, tbl)
	if (type(msgID) == "number") then
		msgID = tostring(msgID)
	end
	Event.AddListener(msgID, callback, tbl);
	local data = {}
	data.msgID = msgID
	data.callback = callback
	self.msgIdList[#self.msgIdList + 1] = data
end

function BasePlayer:RemoveEvent(id)
	for i=1, #self.msgIdList do
		if self.msgIdList[i].msgID == id then
			Event.RemoveListener(self.msgIdList[i].msgID, self.msgIdList[i].callback)
			self.msgIdList[i] = nil
			break
		end
	end
end
-----------------------------------------------------------------------------------------------------------


--------------------------------------------------------周期函数-------------------------------------------

function BasePlayer:OnInit()
end

function BasePlayer:OnInitCards(cards)
end

function BasePlayer:OnEnterRoom()
	self:OnEnterRoom()
end

function BasePlayer:OnLeaveRoom()
	self:OnLeaveRoom()
end

function BasePlayer:Update()
	return self:OnUpdate()
end

function BasePlayer:UpdateInfo(newInfo)
	for k,v in pairs(newInfo) do
		self.m_info[k] = v 	--覆盖更新
	end
	-- log("更新玩家信息---- ")
	Event.Brocast(Msg.PlayerInfoUpdate,self)
end

function BasePlayer:OnUpdate()
end

function BasePlayer:UnLoad()
	Event.Brocast(Msg.RemovePlayer, self)
	for i=1, #self.msgIdList do
		Event.RemoveListener(self.msgIdList[i].msgID, self.msgIdList[i].callback)
	end
	self.msgIdList = {}
end

function BasePlayer:OnReady()
end

function BasePlayer:OnLeave()
end

function BasePlayer:OnOffline()
end

function BasePlayer:OnOnLine()
end

function BasePlayer:OnAction()
end

function BasePlayer:OnActionChu(tbl)
end

function BasePlayer:OnActionMo(tbl)
end

function BasePlayer:OnActionChi(tbl)
end

function BasePlayer:OnActionPeng(tbl)
end

function BasePlayer:OnActionAn(tbl)
end

function BasePlayer:OnActionJie(tbl)
end

function BasePlayer:OnActionGong(tbl)
end

function BasePlayer:OnOperate()
end

function BasePlayer:OnChat()
end

function BasePlayer:OnRespondDeaprt()
end

-----------------------------------------------------------------------------------------------------------

