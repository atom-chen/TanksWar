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
	self:AddEvent(Msg.Connect, self.OnConnect, self)
end

function LoginCtrl:OnStart()
	if not next(LocalConfig) or not LocalConfig.token or LocalConfig.token == "" then
		UIMgr.Open(Main_Panel.LoginPanel)
	else
		if not LocalConfig.ip or not LocalConfig.port then
			UIMgr.Open(Main_Panel.LoginPanel)
		else
			UIMgr.Open(Common_Panel.WaitPanel)
			NetWork.ConnectServer(LocalConfig.ip, LocalConfig.port)
		end
	end
end

----http获取token socket连接服务器
function LoginCtrl:CoConnect()

	local sendData = {}
	
    sendData.gameId = g_Config.gameID
	local url = ""
	if self.m_loginType == LoginType.Wechat then
		local info = SDKMgr.WechatInfo
		url = g_Config.wechatUrl
		if Platform.Iphone then
			sendData.openId = info.uid
			sendData.sys = ios
		elseif Platform.Android then
			sendData.openId = info.openID
			sendData.sys = "android"
		end

		sendData.accessToken = info.token
		sendData.packageName = g_Config.packageName
	elseif self.m_loginType == LoginType.Guest then
		sendData.guestId = self:GetRandomGuestID()
		url = g_Config.guestUrl
	end

	local content = cjson.encode(sendData)
	local encrypt_data = XXTEA.EncryptToBase64String(content, Game.XXTEAKey)

	log("加密数据--"..encrypt_data)

	local form = WWWForm()
    form:AddField("info", Game.GameFlag..encrypt_data)

    local www = WWW(url,form);
	coroutine.www(www);

	if www.error then
		logError('error: '..tostring(www.error)..'\n www.text: '..www.text)
	end
	log("www-- "..www.text)
    local recTbl = cjson.decode(www.text)
	local res = XXTEA.DecryptBase64StringToString(recTbl.info, Game.XXTEAKey)
    local recData = cjson.decode(res)
    LocalConfig.loginType = self.m_loginType
    LocalConfig.token = recData.token
    LocalConfig.ip = recData.socketServer.host
	LocalConfig.port = recData.socketServer.port
	-- LocalConfig.ip = "192.168.1.231"
	-- LocalConfig.port = "5012"
	
	-- 保存文件手机上路径不对 不允许写入 需要改路径
	util.SaveFile(g_Config.configFileName, LocalConfig)

	NetWork.ConnectServer(LocalConfig.ip, LocalConfig.port)
end

function LoginCtrl:OnWechatLogin()
	self.m_loginType = LoginType.Wechat
	--先认证 再请求token 后连接
	if not SDKMgr.IsClientValid(PlatformType.WeChat) then
		UIMgr.Open(Common_Panel.TipsPanel, Lang.wechatClientTips)
		return
	end
	SDKMgr.Authorize(PlatformType.WeChat)
end

function LoginCtrl:OnGuestLogin()
	self.m_loginType = LoginType.Guest
	--直接连接 动态生成guestid
	self:OnLogin()
end

function LoginCtrl:OnLogin()
	if not g_Config.single then
		UIMgr.Open(Common_Panel.WaitPanel)
		-- coroutine.start(self.CoConnect, self)
		coroutine.start(function ()
			self:CoConnect()
	    end)
	else
		local lobbyCtrl = CtrlMgr.Get(Main_Ctrl.LobbyCtrl)
		lobbyCtrl:OnStart()
		UIMgr.Close(Main_Panel.LoginPanel)
	end
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
	log("OnConnect OK --->")
	coroutine.start(function()
		local sendData = {token = LocalConfig.token}
	    local res = NetWork.Request(proto.login, sendData)
	    if res.code == 0 then

	        local data = res.data
	        if data.guestId then
	        	LocalConfig.guestId = data.guestId
	        	util.SaveFile(g_Config.configFileName, LocalConfig)
	        end

	        PlayerMgr.AddMainPlayer(data.userId, data)
	        local lobbyCtrl = CtrlMgr.Get(Main_Ctrl.LobbyCtrl)
	        lobbyCtrl:OnStart()

	        --自动登录时没有打开登录界面
	        local panel = UIMgr.Get(Main_Panel.LoginPanel)
	        if panel:IsOpen() then
	        	panel:Close()
	        end
		elseif res.code == 1 then
			logWarn("登录失败--"..res.msg)
			UIMgr.Open(Main_Panel.LoginPanel)
	    else
	        UIMgr.Open(Common_Panel.TipsPanel, res.msg)
	    end

	    UIMgr.Close(Common_Panel.WaitPanel)
	end)
end

