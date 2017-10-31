

SettingPanel = Class(BasePanel);

local bgMicBar 
local audioBar
local isDialectValue

function SettingPanel:Ctor()

	self.m_comp.btnQieHuan = ButtonEx
	self.m_comp.btnExit    = ButtonEx
	self.m_comp.btnKeFu    = ButtonEx
	self.m_comp.btnYinSi   = ButtonEx
	self.m_comp.btnFuWu    = ButtonEx

	self.m_comp.BGMusic    = Transform
	self.m_comp.Audio      = Transform
	self.m_comp.IsDialect  = Transform
	self.m_comp.IsShock    = Transform
     
    self.m_comp.imgMscDi    = ImageEx
    self.m_comp.imgAudioDi    = ImageEx

end
       
function SettingPanel:OnInit()
    
    --设置按钮
	self.m_comp.btnQieHuan:AddLuaClick(self.OnClickQH, self)
    self.m_comp.btnExit:AddLuaClick(self.OnClickExit, self)
    self.m_comp.btnKeFu:AddLuaClick(self.OnClickKefu, self)
    self.m_comp.btnYinSi:AddLuaClick(self.OnClickYS, self)
    self.m_comp.btnFuWu:AddLuaClick(self.OnClickFW, self)
    

    --音乐 音效
    bgMicBar = self.m_comp.BGMusic:GetComponentInChildren(typeof(UIScrollbar))
    audioBar = self.m_comp.Audio:GetComponentInChildren(typeof(UIScrollbar))

    --震动与方言
    local dialectTog = self.m_comp.IsDialect:GetComponentInChildren(typeof(ButtonEx))
    local shockTog =  self.m_comp.IsShock:GetComponentInChildren(typeof(ButtonEx))
    dialectTog:AddLuaClickEx(self.OnChangeDialect,self)
    shockTog:AddLuaClickEx(self.OnChangeShock,self)

end

function SettingPanel:OnShowDeal()
    
	log("SettingPanel:OnShowDeal -- ")
    
end


function SettingPanel:OnUpdate()

    --处理音效和背景音乐值


    self.m_comp.imgMscDi.fillAmount = bgMicBar.value
    self.m_comp.imgAudioDi.fillAmount = audioBar.value

end


function SettingPanel:OnChangeDialect(tog)
	-- body
	-- log("SettingPanel:OnChangeDialect  ------   "..tog.m_curState)
	 if tog.m_curState==0 then
        log("  SettingPanel:OnChangeDialect   打开方言 ")
     elseif tog.m_curState==1 then
         log("  SettingPanel:OnChangeDialect   关闭方言 ")
     end

end

function SettingPanel:OnChangeShock(tog)
	-- body
	 if tog.m_curState==0 then
         log("  SettingPanel:OnChangeShock   打开震动 ")
     elseif tog.m_curState==1 then
         log("  SettingPanel:OnChangeShock   关闭震动 ")
	 end
end

--按钮事件  切换
function SettingPanel:OnClickQH()
   UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

--退出
function SettingPanel:OnClickExit()
    UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

--客服
function SettingPanel:OnClickKefu()
    UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

--隐私
function SettingPanel:OnClickYS()
    UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end

--服务
function SettingPanel:OnClickFW()
    UIMgr.Open(Common_Panel.TipsPanel, Lang.notOpen)
end