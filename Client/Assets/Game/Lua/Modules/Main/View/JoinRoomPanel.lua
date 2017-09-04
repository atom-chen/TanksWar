
JoinRoomPanel = Class(BasePanel);
local  idLen = 6    --房间号长度
local  inputNum = nil

function JoinRoomPanel:Ctor()
	
	
    self.m_comp.InputGrid = Transform
    self.m_comp.ShowGrid=Transform
end

function JoinRoomPanel:OnInit()
	--  给输入框添加点击事件
    
    for i=1,self.m_comp.InputGrid.childCount do

     	local btn =self.m_comp.InputGrid:GetChild(i-1):GetComponent("StateHandle")
        
        btn:AddLuaClickEx(self.Ontest, self)

     end

end

--输入按钮监听注册
function JoinRoomPanel:Ontest(btn)
    if btn.gameObject.name == "btnNum (1)" then
        self:AddNum(1)
    elseif btn.gameObject.name == "btnNum (2)" then
        self:AddNum(2)
    elseif btn.gameObject.name == "btnNum (3)" then
    	self:AddNum(3)
	elseif btn.gameObject.name == "btnNum (4)" then
		self:AddNum(4)
	elseif btn.gameObject.name == "btnNum (5)" then
		self:AddNum(5)
	elseif btn.gameObject.name == "btnNum (6)" then
		self:AddNum(6)
	elseif btn.gameObject.name == "btnNum (7)" then
		self:AddNum(7)
	elseif btn.gameObject.name == "btnNum (8)" then
		self:AddNum(8)
	elseif btn.gameObject.name == "btnNum (9)" then
		self:AddNum(9)
	elseif btn.gameObject.name == "btnNum (10)" then
		 log("    重新输入  ------  ")
		self:ReenterNunm()
	elseif btn.gameObject.name == "btnNum (0)" then
		self:AddNum(0)
	elseif btn.gameObject.name == "btnNum (11)" then	
		 log("    删除 ---------- ")
		self:DeletNum()
	end

     self:ShowRoomNum()
end

local InputNumArr={}
function JoinRoomPanel:AddNum(indexId)
	-- log("  长度   ： "..#InputNumArr  .. "  idLen "..idLen)
    if  #InputNumArr< idLen then
    	 InputNumArr[#InputNumArr+1]  = tostring(indexId)        
    end

    if #InputNumArr>=idLen then
         log("   请求加入房间  ")
    end
end

-- 删除数字
function JoinRoomPanel:DeletNum()
     InputNumArr[#InputNumArr]=nil
     -- log("  最后一个输入数字   ： ".. type(InputNumArr[#InputNumArr]) )
end

--重新输入
function  JoinRoomPanel:ReenterNunm()
	-- body
	for i=1,#InputNumArr do
		-- print(i)
		InputNumArr[i]=nil
	end	
end

function JoinRoomPanel:ShowRoomNum()
    for i=1,idLen do
    	local image = self.m_comp.ShowGrid:GetChild(i-1):GetComponent("ImageEx")
    	if image ==nil then
    		log("没有寻找到Image组件")
    		return
    	end
    	if InputNumArr[i]~=nil then
          	 local spriteName = "ui_Main_"..InputNumArr[i]
          	 -- log("   spriteName  :   "..spriteName)
             image:Set(spriteName)
        else
        	 image:Set("ui_Main_empty")
        end
    end
end

function JoinRoomPanel:OnOpen( )
   -- body
    log("   show   ---- 加入房间  ")
   
end

