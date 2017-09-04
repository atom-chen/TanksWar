-- for k,v in pairs(_G) do
-- 	print(k)
-- end
-- for k,v in pairs(_G["MsgPanel"]) do
-- 	print(k)
-- end

--错误日志--
function test(...) 
	print(select("3",...))
end

test(12,2,3)