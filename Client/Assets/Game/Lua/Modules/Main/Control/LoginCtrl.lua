-- LoginCtrl.lua
-- Author : Dzq
-- Date : 2017-05-21
-- Last modification : 2017-05-21
-- Desc: LoginCtrl

LoginCtrl = Class(BaseCtrl);

function LoginCtrl:Ctor()
	self.m_id = "LoginCtrl"
	self.m_modName = "Main"
	self.m_panelName = "LoginPanel"
	
	self.m_loginType = ""

	--log("LoginCtrl Ctor---->>>")
end

function LoginCtrl:OnInit()
	self:AddEvent(Msg.Connect, self.OnConnect)
end

function LoginCtrl:OnStart()
	if not next(LocalConfig) or not LocalConfig.Token or LocalConfig.Token == "" then
		UIMgr.Open(Main_Panel.LoginPanel)
	else
		if not LocalConfig.ip or not LocalConfig.port then
			UIMgr.Open(Main_Panel.LoginPanel)
		else
			NetWork.ConnectServer(LocalConfig.ip, LocalConfig.port)
		end
	end
end

----http获取token socket连接服务器
function LoginCtrl:CoConnect()
	local form = WWWForm()
    form:AddField("gameId",g_Config.gameID)
	
	local url = ""
	if self.m_loginType == LoginType.Wechat then
		form:AddField("openId",self:GetRandomGuestID())
		url = g_Config.wechatUrl
	elseif self.m_loginType == LoginType.Guest then
		form:AddField("guestId",self:GetRandomGuestID())
		url = g_Config.guestUrl
	end

    local www = WWW(url,form);
	coroutine.www(www);
	log('www.text:\n'..www.text)
    local recTbl = cjson.decode(www.text)
    LocalConfig.token = recTbl.token
	LocalConfig.ip = recTbl.socketServer.host
	LocalConfig.port = recTbl.socketServer.port
	-- LocalConfig.ip = "192.168.1.240"
	-- LocalConfig.port = "5012"
	
	util.SaveFile(g_Config.configFileName)

	NetWork.ConnectServer(LocalConfig.ip, LocalConfig.port)
end

function LoginCtrl:OnWechatLogin()
	self.m_loginType = LoginType.Wechat
	SDKMgr.AuthorizeWeiChat()
end

function LoginCtrl:OnGuestLogin()
	self.m_loginType = LoginType.Guest
	self:OnLogin()
end

function LoginCtrl:OnLogin( )
	if not g_Config.single then
		UIMgr.Open(Common_Panel.WaitPanel)
		coroutine.start(self.CoConnect, self)
	else
		local lobbyCtrl = CtrlMgr.Get(Main_Ctrl.LobbyCtrl)
		lobbyCtrl:OnStart()
		UIMgr.Close(Main_Panel.LoginPanel)
	end
end

function LoginCtrl:OnLoginCallback(tbl)
	PlayerMgr.AddMainPlayer(tbl.userId, tbl)
	local lobbyCtrl = CtrlMgr.Get(Main_Ctrl.LobbyCtrl)
	lobbyCtrl:OnStart()
	UIMgr.Close(Main_Panel.LoginPanel)
	UIMgr.Close(Common_Panel.WaitPanel)
end

function LoginCtrl:GetRandomGuestID()
		
	math.randomseed(tostring(os.time()):reverse():sub(1, 6))
    local guestId = ""
    for i=1,25 do
        guestId = guestId..(math.random(1,9))
    end
	
	return guestId
end

function LoginCtrl:OnConnect()
	-- log("连接服务器成功--------")
	NetWork.SendMsg(proto.login, {token = LocalConfig.token})
end

