-- Global.lua
-- Author : Dzq
-- Date : 2017-05-24
-- Last modification : 2017-05-24
-- Desc: 全局

require "Config"
require "Functions"
require "Class"
require "BaseCtrl"
require "BasePanel"
require "BaseItem"
require "BasePlayer"
require "Common/util"
require "Lang"

require "CtrlMgr"
require "UIMgr"
require "SDKMgr"
require "PlayerMgr"
require "SceneMgr"

require "ActivityCfg"
require "GameCfg"
require "RuleCfg"
require "SettingCfg"
require "ShareCfg"
require "SceneCfg"


NetWork = require "NetWork"

require "MsgDef"

Event = require 'events'
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
UIText = UnityEngine.UI.Text
UIImage = UnityEngine.UI.Image
UIButton = UnityEngine.UI.Button 
UIToggle = UnityEngine.UI.Toggle
UIScrollRect = UnityEngine.UI.ScrollRect
UISlider = UnityEngine.UI.Slider
UIToggleGroup = UnityEngine.UI.ToggleGroup
UIScrollbar = UnityEngine.UI.Scrollbar

--custom
UITextEx = UI.TextEx
UIImageEx = UI.ImageEx
UIButtonEx = UI.StateHandle
UIGroup = UI.UIGroup

LocalConfig = {}

--当前使用的协议类型--
TestProtoType = ProtocalType.BINARY;
