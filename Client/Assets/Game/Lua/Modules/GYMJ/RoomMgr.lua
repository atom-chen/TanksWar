-- RoomMgr.lua
-- Author : Dzq
-- Date : 2017-09-28
-- Last modification : 2017-09-28
-- Desc: 涡阳麻将 房间管理类 处理房间内逻辑 各个模块房间不同

local _M = { }

_M.m_roomId = false

function _M.Init()
	-- log("RoomMgr init ----- ")
	local my = PlayerMgr.GetMyself()

	local cards = {
		handCards = {1,2,3,4,5,6,3,2,3,4,2},
		putCards = {8,2,5,4,7,6,2,3,4,2,2,3,4},
		chiCards = {3,4,5,7,7},
	}
	
	my:InitCards(cards)
end

function _M.CreateRoom(roomId)
	m_roomId = roomId
end

function _M.GetRoomID()
	return m_roomId
end

_G["RoomMgr"] = _M