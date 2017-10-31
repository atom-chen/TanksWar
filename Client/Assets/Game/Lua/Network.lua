
require "Common.functions"

require "3rd.pblua.login_pb"
require "3rd.pbc.protobuf"

local sproto = require "3rd.sproto.sproto"
local core = require "sproto.core"
local print_r = require "3rd.sproto.print_r"

local msgTool = require "cs-common.msgtool"

Network = {};
local this = Network;

local transform;
local gameObject;
local islogging = false;

this.IsConnect = false
this.heat_time = 0
this.lost_time = 0
this.random_time = 0

this.sessionCo = {}
this.session = 0

function Network.Start() 
    log("Network.Start!!");
    Event.AddListener(Msg.Connect, this.OnConnect, this); 
    Event.AddListener(Msg.Exception, this.OnException, this); 
    Event.AddListener(Msg.Disconnect, this.OnDisconnect, this); 
end

--Socket消息--
function Network.OnSocket(key, buffer)
    -- log(" Network.OnSocket -------------   "..key.."   :  "..Msg.Message.. "  :  " ..type(buffer))
    if tostring(key) == Msg.Message then
        local str = buffer:ReadStringEx()
        local id, data, s = msgTool.decode(str)
        log('RecvMsg : \n'..str)
        if this.sessionCo[s] then
            coroutine.resume(this.sessionCo[s], cjson.encode(data)) ----resume 返回值不能是table？？？
        else
            Event.Brocast(tostring(id), data)
        end
    else
        Event.Brocast(tostring(key), buffer)
    end
end

function Network.ConnectServer(ip, port)
    AppConst.SocketPort = port;
    AppConst.SocketAddress = ip;
    logWarn("连接服务器：ip = "..AppConst.SocketAddress..'  port = '..port)
    networkMgr:SendConnect();
end

--当连接建立时--
function Network:OnConnect()
    this.IsConnect = true
    this.heat_time = Time.time
	Game.OnConnected()
end

--异常断线--
function Network:OnException() 
    islogging = false; 
    NetManager:SendConnect();
    this.IsConnect = false
   	logError("OnException------->>>>");
end

--连接中断，或者被踢掉--
function Network:OnDisconnect() 
    islogging = false; 
    this.IsConnect = false
    logError("OnDisconnect------->>>>");
end

function Network.SendMsg( protoId, data, session)
    data = data or {}
    session = session or -1
    local str = msgTool.encode(protoId, data, session)
    if protoId ~= proto.heart then
        log("sendMsg : \n"..str)
    end
    networkMgr:SendMsg(str);
end

function Network.Request(proto, data)
    this.session = this.session + 1
    Network.SendMsg(proto, data, this.session)
    this.sessionCo[this.session] = coroutine.running()
    return cjson.decode(coroutine.yield())
end
--卸载网络监听--
function Network.Unload()
    log('Unload Network...');
    Event.RemoveListener(Msg.Connect);
    Event.RemoveListener(Msg.Exception);
    Event.RemoveListener(Msg.Disconnect);
end

function Network.Update()
    if g_Config.single then
        return
    end
    
    if this.IsConnect and Time.time - this.heat_time > TimeOutSec  then
        -- log("发送心跳包------- ")
        this.heat_time = Time.time
        this.SendMsg(proto.heart)
    end
    
    if not this.IsConnect and (Time.time - this.lost_time) > this.random_time then
        this.lost_time = Time.time
        this.random_time = 3 + math.random(1,3) + math.random()
        -- log("断线重连-------- ")
    end
end

return Network