
require "Common/functions"

require "3rd/pblua/login_pb"
require "3rd/pbc/protobuf"

local sproto = require "3rd/sproto/sproto"
local core = require "sproto.core"
local print_r = require "3rd/sproto/print_r"

local msgTool = require "cs-common/msgtool"

Network = {};
local this = Network;

local transform;
local gameObject;
local islogging = false;

this.IsConnect = false
this.heat_time = 0
this.lost_time = 0

function Network.Start() 
    -- log("Network.Start!!");
    Event.AddListener(Msg.Connect, this.OnConnect); 
    Event.AddListener(Msg.Exception, this.OnException); 
    Event.AddListener(Msg.Disconnect, this.OnDisconnect); 
end

--Socket消息--
function Network.OnSocket(key, buffer)
    if tostring(key) == Msg.Message then
        local str = buffer:ReadStringEx()
        local id, data = msgTool.decode(str)
        log('RecvMsg : \n'..str)
        Event.Brocast(tostring(id), data)
    else
        Event.Brocast(tostring(key), buffer)
    end
    
end

function Network.ConnectServer(ip, port)
    AppConst.SocketPort = port;
    AppConst.SocketAddress = ip;
    networkMgr:SendConnect();
end

--当连接建立时--
function Network.OnConnect()
    this.IsConnect = true
    this.heat_time = Time.time
	Game.OnConnected()
end

--异常断线--
function Network.OnException() 
    islogging = false; 
    NetManager:SendConnect();
    this.IsConnect = false
   	logError("OnException------->>>>");
end

--连接中断，或者被踢掉--
function Network.OnDisconnect() 
    islogging = false; 
    this.IsConnect = false
    logError("OnDisconnect------->>>>");
end

function Network.SendMsg( proto, data )
    local str = msgTool.encode(proto, data)
    log("sendMsg : \n"..str)
    networkMgr:SendMsg(str);
end

--卸载网络监听--
function Network.Unload()
    Event.RemoveListener(Msg.Connect);
    Event.RemoveListener(Msg.Exception);
    Event.RemoveListener(Msg.Disconnect);
    -- log('Unload Network...');
end

function Network.Update()
    if g_Config.single then
        return
    end
    
    if this.IsConnect and Time.time - this.heat_time > TimeOutSec  then
        -- log("发送心跳包------- ")
        this.heat_time = Time.time
        -- this.SendMsg()
    end
    
    if not this.IsConnect and Time.time - this.lost_time > TimeOutSec then
        this.lost_time = Time.time
        -- log("断线重连-------- ")
    end
end

return Network