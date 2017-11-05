-- TablePanel.lua
-- Author : Dzq
-- Date : 2017-10-11
-- Last modification : 2017-10-11
-- Desc: 牌桌显示界面

require 'Modules/FYMJ/View/Item/TableItem'

TablePanel = Class(BasePanel)

function TablePanel:Ctor()
	self.m_openAniName = ""
   	self.m_closeAniName = ""

	self.m_comp.selfCards = GameObject 
	self.m_comp.infoView = GameObject
	self.m_comp.leftTop = GameObject
	self.m_comp.rightTop = GameObject
	self.m_comp.rightMid = GameObject
	self.m_comp.btnExit = ButtonEx
	self.m_comp.btnHelp = ButtonEx
	self.m_comp.txtTime = TextEx
	self.m_comp.imgNet = ImageEx
	self.m_comp.txtCardsNum = TextEx
	self.m_comp.btnSetting = ButtonEx
	self.m_comp.btnChat = ButtonEx

	self.m_comp.btnHu = ButtonEx
	self.m_comp.btnTing = ButtonEx
	self.m_comp.btnGang = ButtonEx
	self.m_comp.btnPeng = ButtonEx
	self.m_comp.btnChi = ButtonEx
	self.m_comp.btnGuo = ButtonEx

	self.m_comp.optRoot = GameObject
	self.m_comp.centerObj = GameObject
	self.m_comp.txtRoomId = TextEx

	self.m_myself = false

	self.m_optBtns = {}
	self.m_infoViewList = {}
	self.m_infoStateList = {}

	-- logWarn("TablePanel:Ctor ---- ")
end

function TablePanel:OnInit()
	self.m_comp.btnSetting:AddLuaClick(self.OnSettingClick, self)
	self.m_comp.btnExit:AddLuaClick(self.OnExitClick, self)
	self.m_comp.btnHelp:AddLuaClick(self.OnHelpClick, self)
	self.m_comp.btnChat:AddLuaClick(self.OnChatClick, self)

	self.m_comp.btnSetting:AddLuaDragBegin(self.OnDragBegin, self, false)
	self.m_comp.btnSetting:AddLuaDrag(self.OnDrag, self, false)
	self.m_comp.btnSetting:AddLuaDragEnd(self.OnDragEnd, self, false)

	self.m_comp.btnHu:AddLuaClickEx(self.OnClickAction, self)
	self.m_comp.btnTing:AddLuaClickEx(self.OnClickAction, self)
	self.m_comp.btnGang:AddLuaClickEx(self.OnClickAction, self)
	self.m_comp.btnPeng:AddLuaClickEx(self.OnClickAction, self)
	self.m_comp.btnChi:AddLuaClickEx(self.OnClickAction, self)
	self.m_comp.btnGuo:AddLuaClickEx(self.OnClickAction, self)

	self.m_optBtns[Operation.HU.name] 	= self.m_comp.btnHu
	self.m_optBtns[Operation.TING.name] = self.m_comp.btnTing
	self.m_optBtns[Operation.PENG.name] = self.m_comp.btnPeng
	self.m_optBtns[Operation.CHI.name] 	= self.m_comp.btnChi
	self.m_optBtns[Operation.GUO.name] 	= self.m_comp.btnGuo
	self.m_optBtns[Operation.GONG.name] = self.m_comp.btnGang
	self.m_optBtns[Operation.AN.name] 	= self.m_comp.btnGang
	self.m_optBtns[Operation.JIE.name] 	= self.m_comp.btnGang


	self.m_comp.infoView:SetActive(false)
	self.m_comp.optRoot:SetActive(false)
	self.m_comp.selfCards:SetActive(false)

    self:AddEvent(Msg.ChangeState, self.OnStateChange, self) --游戏状态改变
    self:AddEvent(Msg.OnOperate, self.ShowOpt, self) --操作权限

	self.m_myself = PlayerMgr.GetMyself()

	-- logWarn("TablePanel:OnInit ---- ")
end

function TablePanel:OnSettingClick()
	log("OnSettingClick ---- ")
end

function TablePanel:OnExitClick()
	-- log("OnExitClick ---- ")
	local cxt = {
		msgType = 2,
		okTxt = "确定",
		cancelTxt = "取消",
		onOk = self.m_ctrl.OnExit,
		title = "退出",
		content = "确定退出房间吗？",
		tbl = self,
	}
	UIMgr.Open(Common_Panel.MsgPanel, cxt)
end

function TablePanel:OnHelpClick()
	log("OnHelpClick ---- ")
end

function TablePanel:OnChatClick()
	log("OnChatClick ---- ")
end

function TablePanel:GetCardsRoot()
	return self.m_comp.selfCards.transform
end


function TablePanel:OnClickAction(btn)
	for k,v in pairs(self.m_optBtns) do
		if v == btn then
			--这里暗杠接杠明杠时处理有问题 待处理
			self.m_myself:OnSendAction(k)
			break
		end
	end

	self:HideAllOpt()
end

function TablePanel:ShowOpt(optData)
	self:HideAllOpt()
	self.m_comp.optRoot:SetActive(true)
	-- log("接收操作消息 --- "..cjson.encode(optData))
	for i=1, #optData do
		-- log("有操作--"..optData[i].opt)
		if self.m_optBtns[optData[i].opt] then
			self.m_optBtns[optData[i].opt].gameObject:SetActive(true)
		end
	end
end

function TablePanel:HideAllOpt()
	for k,v in pairs(self.m_optBtns) do
		v.gameObject:SetActive(false)
	end
end

function TablePanel:OnOpen()
	-- log("TablePanel OnOpen---->>>")
	self.m_infoViewList = {}
	self.m_infoStateList = {}
	--初始化没个玩家的头像
	for i = 1, 4 do 
		local go = self.m_comp.infoView.transform:Find("player"..i).gameObject
		local handle = go:GetComponent("StateHandle")
		self.m_infoStateList[#self.m_infoStateList+1] = handle
		local item = TableItem.New(go)
		item:Init(i)
		item:SetActive(false)
		-- logWarn("handle -- "..type(handle).." str-- "..tostring(handle))
		handle:SetStateEx(PlayState.Ready)
		self.m_infoViewList[#self.m_infoViewList+1] = item
	end
end

function TablePanel:OnStartPlay()
	for i = 1, #self.m_infoViewList do
		local item = self.m_infoViewList[i]
		local handle = item:GetComponent("StateHandle")
		-- item:SetActive(true)
		handle:SetStateEx(PlayState.Playing)
	end
end

function TablePanel:OnStateChange(state)
	for i = 1, #self.m_infoViewList do
		if self.m_infoViewList[i]:IsActive() then
			self.m_infoViewList[i]:UpdateInfo(state)
		end
	end
end

function TablePanel:SetPlayerInfo(player)
	local sit = player:GetSit()
	-- log("setplayerinfo sit --- "..sit)
	if self.m_infoViewList[sit] ~= nil then
		self.m_comp.infoView:SetActive(true)
		self.m_infoViewList[sit]:SetActive(true)
		self.m_infoViewList[sit]:SetInfo(player)
	end
end

function TablePanel:HidePlayer(player)
	local sit = player:GetSit()
	if self.m_infoViewList[sit] then
		self.m_infoViewList[sit]:SetActive(false)
	end
end

function TablePanel:SetCardScale(scale)
	self.m_comp.selfCards.transform.localScale = scale
end

function TablePanel:SetRoomId(roomId)
	self.m_comp.txtRoomId.text = "房间:<color=blue>"..roomId.."</color>"
end

function TablePanel:SetRoomInfo(data)
	if data.roomId then
		self.m_comp.txtRoomId.text = "房间:<color=blue>"..data.roomId.."</color>"
	end
	if data.lastCardNum then
		self.m_comp.txtCardsNum.text = "剩余"..data.lastCardNum
	end
	
end

function TablePanel:SetCardPos(pos)
	self.m_comp.selfCards.transform.localPosition = pos
end

function TablePanel:OnClose()
	-- log("TablePanel OnClose---->>>")
end

function TablePanel:OnUpdate()
	-- log("TablePanel OnUpdate---->>>")
end

function TablePanel:OnFresh()
	-- log("TablePanel OnFresh---->>>")
end

function TablePanel:OnDestroy()
	-- log("TablePanel OnDestroy---->>>")
end
