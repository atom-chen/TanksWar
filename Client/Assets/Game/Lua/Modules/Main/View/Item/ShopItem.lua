

ShopItem = Class(BaseItem);

function ShopItem:Ctor()
	-- self.m_comp.text = TextEx
    self.m_comp.imgZuanIcon = ImageEx
    self.m_comp.txtZuanCount = UIText
    self.m_comp.txtPice = UIText
    self.m_comp.txtGiveDes = UIText
end

function ShopItem:OnInit(param)
	-- self.m_comp.text.text = tostring('text - '..param)
	-- log(" ShopItem:OnInit ---------- "..param.id)

    --设置数据
    local  sprite = "ui_Main_Shop_"..param.icon
    self.m_comp.imgZuanIcon:Set(sprite)
    self.m_comp.txtGiveDes.text = param.giveDes
    self.m_comp.txtZuanCount.text = param.count.." 玉"
    self.m_comp.txtPice.text = "￥ "..param.pice

end


