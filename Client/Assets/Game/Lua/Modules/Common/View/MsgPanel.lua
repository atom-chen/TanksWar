-- MsgPanel.lua
-- Author : Dzq
-- Date : 2017-08-18
-- Last modification : 2017-08-18
-- Desc: 提示框确认框界面
-- 参数param内容
--[[
{
	msgType = 2,  1:确认单个按钮 2：确定取消两个按钮
	okTxt = "", 确认按钮文字
	cancelTxt = "", 取消按钮文字
	confirmTxt = "", 确认按钮文字
	onOk = onOk, 确定回调函数
	onCancel = onCancel, 取消回调函数
	onConfirm = onConfirm, 确认回调函数
	title = "标题文字",
	content = "提示文字",
	tbl = self, 	要回调给的table
	param = {},   额外参数 点击是会做为参数回调
}
]]

MsgPanel = Class(BasePanel);

function MsgPanel:Ctor()
	self.m_comp.objTitle = GameObject
	self.m_comp.txtTitle = UITextEx
	self.m_comp.txtContent = UITextEx
	self.m_comp.btnOK = UIButtonEx
	self.m_comp.btnOKTxt = UITextEx
	self.m_comp.btnCancel = UIButtonEx
	self.m_comp.btnCancelTxt = UITextEx
	self.m_comp.btnConfirm = UIButtonEx
	self.m_comp.btnConfirmTxt = UITextEx

	self.callTable = nil
	self.callFuncOK = nil
	self.callFuncCancel = nil
	self.callFuncConfirm = nil
	self.param = nil
end

function MsgPanel:OnInit()
	self.m_comp.btnOK:AddLuaClick(self.OnOkClick, self)
	self.m_comp.btnCancel:AddLuaClick(self.OnCancelClick, self)
	self.m_comp.btnConfirm:AddLuaClick(self.OnConfirmClick, self)
end

function MsgPanel:OnOpen(param)
	--设置标题
	if param.title then
		self.m_comp.objTitle:SetActive(true)
		self.m_comp.txtTitle.text = param.title
	else
		self.m_comp.objTitle:SetActive(false)
	end

	local msgType = param.msgType or 1
	if msgType == 1 then
		self.m_comp.btnOK.gameObject:SetActive(false)
		self.m_comp.btnCancel.gameObject:SetActive(false)
		self.m_comp.btnConfirm.gameObject:SetActive(true)

		self.m_comp.btnConfirmTxt.text = param.confirmTxt or "确认"
	else
		self.m_comp.btnOK.gameObject:SetActive(true)
		self.m_comp.btnCancel.gameObject:SetActive(true)
		self.m_comp.btnConfirm.gameObject:SetActive(false)

		self.m_comp.btnOKTxt.text = param.okTxt or "确定"
		self.m_comp.btnCancelTxt.text = param.cancelTxt or "取消"
	end

	self.m_comp.txtContent.text = param.content

	self.callTable = param.tbl
	self.callFuncOK = param.onOk
	self.callFuncCancel = param.onCancel
	self.callFuncConfirm = param.onConfirm
	self.param = param.param
end

function MsgPanel:OnOkClick()
	if self.callFuncOK then
		if self.callTable then
			self.callFuncOK(self.callTable, self.param)	
		else
			self.callFuncOK(self.param)	
		end
	end
	self:Close()
end

function MsgPanel:OnCancelClick()
	if self.callTable then
		self.callFuncCancel(self.callTable, self.param)	
	else
		self.callFuncCancel(self.param)	
	end
	self:Close()
end

function MsgPanel:OnConfirmClick()
	if self.callTable then
		self.callFuncConfirm(self.callTable, self.param)	
	else
		self.callFuncConfirm(self.param)	
	end
	self:Close()
end

function MsgPanel:OnClose()
	self.callTable = nil
	self.callFuncOK = nil
	self.callFuncCancel = nil
	self.callFuncConfirm = nil
	self.param = nil
end