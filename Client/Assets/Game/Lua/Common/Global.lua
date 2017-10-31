-- Global.lua
-- Author : Dzq
-- Date : 2017-05-24
-- Last modification : 2017-05-24
-- Desc: 全局

require "Common.Config"
require "Common.Functions"
require "Common.Class"
require "Common.BaseCtrl"
require "Common.BasePanel"
require "Common.BaseItem"
require "Common.BasePlayer"
require "Common.BaseContainer"
require "Common.util"
require "Common.Lang"

require "CtrlMgr"
require "UIMgr"
require "SDKMgr"
require "PlayerMgr"
require "SceneMgr"

ActivityCfg = require "Config.ActivityCfg"
GameCfg = require "Config.GameCfg"
RuleCfg = require "Config.RuleCfg"
SettingCfg = require "Config.SettingCfg"
ShareCfg = require "Config.ShareCfg"
ShopCfg = require "Config.ShopCfg"
ViewCfg = require "Config.ViewCfg"
OpenCfg = require "Config.OpenModuleCfg"
RoomCfg = require "Config.RoomCfg"
RoleCfg = require "Config.RoleCfg"

gyCfg= require "cs-common.gymahjong.config"
fyCfg= require "cs-common.fymahjong.config"


NetWork = require "NetWork"

require "Common.MsgDef"

--网络消息
proto = require "cs-common.protocal"
Bit = require "cs-common.bit"
CommonUtil = require "cs-common.utils"

Event = require 'Common.events'
cjson = require "cjson"

Util = Util;
AppConst = AppConst;
LuaHelper = LuaHelper;
ByteBuffer = ByteBuffer;

--framework
gameMgr = LuaHelper.GetGameManager();
resMgr = LuaHelper.GetResManager();
panelMgr = LuaHelper.GetPanelManager();
soundMgr = LuaHelper.GetSoundManager();
networkMgr = LuaHelper.GetNetManager();

--unity
WWW = UnityEngine.WWW;
WWWForm = UnityEngine.WWWForm;
GameObject = UnityEngine.GameObject;
Transform = UnityEngine.Transform;
RectTransform = UnityEngine.RectTransform;
SceneManager = UnityEngine.SceneManagement.SceneManager
UIText = UnityEngine.UI.Text
UIImage = UnityEngine.UI.Image
UIButton = UnityEngine.UI.Button 
UIToggle = UnityEngine.UI.Toggle
UIScrollRect = UnityEngine.UI.ScrollRect
UISlider = UnityEngine.UI.Slider
UIToggleGroup = UnityEngine.UI.ToggleGroup
UIScrollbar = UnityEngine.UI.Scrollbar



--custom
TextEx = TextEx
ImageEx = ImageEx
ButtonEx = StateHandle
UIGroup = UIGroup
CenterChild = CenterOnChild
XXTEA = Xxtea.XXTEA

LocalConfig = {}

--当前使用的协议类型--
TestProtoType = ProtocalType.BINARY;
