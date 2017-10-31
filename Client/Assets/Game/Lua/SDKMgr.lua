-- SDKMgr.lua
-- Author : Dzq
-- Date : 2017-08-23
-- Last modification : 2017-08-23
-- Desc: SDK管理类

module(..., package.seeall)

WeChatOpenID = ""
WechatInfo = false
function OnStart( )
	log("SDKMgr -------")
end

function Authorize(platFormType)
	SDKManager.instance:Authorize(platFormType)
end

function IsClientValid(platFormType)
	return SDKManager.instance:IsClientValid(platFormType)
end

function OnShareFriends(userID)
	local text = string.format(g_Config.shareText, userID)
	local title = g_Config.shareTitle
	local imgURL = g_Config.shareImgUrl
	local site = g_Config.shareSite
	local url = g_Config.shareFriendsUrl
	
	SDKManager.instance:ShareWeChatFriend(url, text, title, imgURL, site)

end

function OnShareMoments(userID)
	local text = string.format(g_Config.shareText, userID)
	local title = g_Config.shareTitle
	local imgURL = g_Config.shareImgUrl
	local site = g_Config.shareSite
	local url = g_Config.shareMomentsUrl
	
	SDKManager.instance:ShareWeChatMoments(url, text, title, imgURL, site)
end

function OnAuthResult(reqID, state, type, result, wechatStr)
    if wechatStr == "" then
    	UIMgr.Open(Common_Panel.TipsPanel, Lang.loginFaild)
    	logError("OnAuthResult--"..tostring(result))
    	return
    end
	WechatInfo = cjson.decode(wechatStr)
	-- logError("  cjson.decode(wechatStr)  ----  "..cjson.decode(wechatStr))
    WeChatOpenID = reqID
    local loginCtrl = CtrlMgr.Get(Main_Ctrl.LoginCtrl)
    loginCtrl:OnLogin()
end

function OnGetUserInfoResult(reqID, state, type, result)
	logError(' OnGetUserInfoResult --  state -- '..tostring(state)..' type -- '..tostring(type)..' result -- '..tostring(result))
end

function OnShareResult(reqID, state, type, result)
	logError(' OnShareResult --  state -- '..tostring(state)..' type -- '..tostring(type)..' result -- '..tostring(result))
end

function OnGetFriendsResult(reqID, state, type, result)
	logError(' OnGetFriendsResult --  state -- '..tostring(state)..' type -- '..tostring(type)..' result -- '..tostring(result))
end
