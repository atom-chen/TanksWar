-- TableItem.lua
-- Author : Dzq
-- Date : 2017-10-11
-- Last modification : 2017-10-11
-- Desc: 牌桌上的人信息 Item
TableItem = Class(BaseItem);

function TableItem:Ctor()
    self.m_comp.imgHead = ImageEx
    self.m_comp.txtMoney = TextEx
    self.m_comp.imgLU = ImageEx
    self.m_comp.imgLB = ImageEx
    self.m_comp.imgRU = ImageEx
    self.m_comp.imgRB = ImageEx
    self.m_comp.txtName = TextEx

    self.m_comp.btnHead = ButtonEx
    self.m_comp.readyHandle = StateHandle

    self.m_comp.imgLeave = ImageEx

    self.m_comp.btnReady = ButtonEx
    self.m_comp.score = UIArtFont

    self.m_sit = PlayerSit.None

    self.m_player = false

end


function TableItem:OnInit(param)
	self.m_sit = param
	-- --事件注册
 	self.m_comp.btnHead:AddLuaClick(self.OnClickItem, self)
    self.m_comp.btnReady:AddLuaClick(self.OnClickReady, self)
   
	self.m_comp.imgLU.gameObject:SetActive(false)
    self.m_comp.imgLB.gameObject:SetActive(false)
    self.m_comp.imgRU.gameObject:SetActive(false)
    self.m_comp.imgRB.gameObject:SetActive(false)
    self.m_comp.score.gameObject:SetActive(false)
    self.m_comp.readyHandle:SetStateEx(0)

end

function TableItem:SetInfo(player)
	self.m_comp.txtName.text = player:GetName()
	self.m_comp.txtMoney.text = player:GetGold()
    if player:GetReady() == 1 then
        self.m_comp.readyHandle:SetStateEx(1)
        -- util.Log("TableItem:SetInfo --- "..1)
    else
        self.m_comp.readyHandle:SetStateEx(0)
        -- util.Log("TableItem:SetInfo --- "..0)
    end

    self.m_comp.imgLeave.gameObject:SetActive(not player:GetIsOnline())

    self.m_player = player

end

function TableItem:ShowScore(score)
    self.m_comp.score.gameObject:SetActive(true)
    if score > 0 then
        self.m_comp.score:SetNum("+"..score, false)
    else
        self.m_comp.score:SetNum(score, false)
    end
    coroutine.start(function() 
        coroutine.wait(ViewCfg.ScoreShowTime)
        self.m_comp.score.gameObject:SetActive(false)
    end)
end

function TableItem:OnClickItem()
    
end

function TableItem:OnClickReady()
    if self.m_player then
        coroutine.start(function ()
            local tbl = NetWork.Request(proto.fy_ready)
            if tbl.code == 0 then
                local recvData = tbl.data
                log("ready --- -- "..tostring(recvData))
                return
            else
                UIMgr.Open(Common_Panel.TipsPanel, tbl.msg)
                return
            end 
        end)
                
    else
        log("没有初始化玩家")
    end

end

function TableItem:UpdateInfo(state)
    if PlayState.Ready == state  then
        self.m_comp.imgLU.gameObject:SetActive(false)
        self.m_comp.imgLB.gameObject:SetActive(false)
        self.m_comp.imgRU.gameObject:SetActive(false)
        self.m_comp.imgRB.gameObject:SetActive(false)
        self.m_comp.readyHandle.gameObject:SetActive(true)
    elseif PlayState.Playing == state  then
        self.m_comp.readyHandle.gameObject:SetActive(false)
    end

end

function TableItem:OnStateChange(state)
    
end
