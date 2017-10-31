
JoinPanel = Class(BasePanel);
local  idLen = 6    --房间号长度
local  inputNum = nil

local this

function JoinPanel:Ctor()
    self.m_comp.InputGrid = Transform
    self.m_comp.ShowGrid = Transform
    this = self
end

function JoinPanel:OnInit()
	--  给输入框添加点击事件
    
    for i=1,self.m_comp.InputGrid.childCount do
     	local btn =self.m_comp.InputGrid:GetChild(i-1):GetComponent("StateHandle")
        btn:AddLuaClickEx(self.OnInput, self)
     end
    self:AddEvent(Msg.InputKey, self.OnKeyInput, self)
end

--输入按钮监听注册
function JoinPanel:OnInput(btn)
    if btn.gameObject.name == "btnNum1" then
        self:AddNum(1)
    elseif btn.gameObject.name == "btnNum2" then
        self:AddNum(2)
    elseif btn.gameObject.name == "btnNum3" then
    	self:AddNum(3)
	elseif btn.gameObject.name == "btnNum4" then
		self:AddNum(4)
	elseif btn.gameObject.name == "btnNum5" then
		self:AddNum(5)
	elseif btn.gameObject.name == "btnNum6" then
		self:AddNum(6)
	elseif btn.gameObject.name == "btnNum7" then
		self:AddNum(7)
	elseif btn.gameObject.name == "btnNum8" then
		self:AddNum(8)
	elseif btn.gameObject.name == "btnNum9" then
		self:AddNum(9)
	elseif btn.gameObject.name == "btnNumReEnter" then
		self:ReenterNunm()
	elseif btn.gameObject.name == "btnNum0" then
		self:AddNum(0)
	elseif btn.gameObject.name == "btnNumDelete" then	
		self:DeletNum()
	end

     self:ShowRoomNum()
end

function JoinPanel:OnKeyInput(key)
    if not this:IsOpen() then
        return
    end
    if key >= 48 and key <= 57 then
        this:AddNum(key - 48)
    end

    if key >= 256 and key <= 265 then
        this:AddNum(key - 256)
    end

    if key == 8 then
        this:DeletNum()
    end

    if key == 127 or key == 266 then
        this:ReenterNunm()
    end
    this:ShowRoomNum()
end

local InputNumArr={}
function JoinPanel:AddNum(indexId)
    if #InputNumArr > idLen then
        return
    end

    if  #InputNumArr< idLen then
    	 InputNumArr[#InputNumArr+1]  = tostring(indexId)        
    end

    if #InputNumArr == idLen then
        local strNum=""
        for i=1,#InputNumArr do
            strNum=strNum..tostring(InputNumArr[i])
        end
        local id = tonumber(strNum)
        self.m_ctrl:JoinRoom(id)
    end
end


-- 删除数字
function JoinPanel:DeletNum()
     InputNumArr[#InputNumArr]=nil
end

--重新输入
function  JoinPanel:ReenterNunm()
	for i=1,#InputNumArr do
		InputNumArr[i]=nil
	end	
end

function JoinPanel:ShowRoomNum()
    for i=1,idLen do
    	local image = self.m_comp.ShowGrid:GetChild(i-1):GetChild(1):GetComponent("ImageEx")
    	if image ==nil then
    		log("没有寻找到Image组件")
    		return
    	end
    	if InputNumArr[i]~=nil then
          	 local spriteName = "ui_Main_Join_show"..InputNumArr[i]
             image:Set(spriteName)
        else
        	 image:Set("ui_Main_Join_empty")
        end
    end
end

function JoinPanel:OnOpen( )
end

