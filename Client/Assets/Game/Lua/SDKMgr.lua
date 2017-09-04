-- SDKMgr.lua
-- Author : Dzq
-- Date : 2017-08-23
-- Last modification : 2017-08-23
-- Desc: SDK管理类

module(..., package.seeall)

function OnStart( )
	log("SDKMgr -------")
end

function AuthorizeWeiChat()
	SDKManager.instance:Authorize(22)
end

function OnAuthResult(reqID, state, type, result)
	logError(' OnAuthResult --  state -- '..tostring(state)..' type -- '..tostring(type)..' result -- '..tostring(result))
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
