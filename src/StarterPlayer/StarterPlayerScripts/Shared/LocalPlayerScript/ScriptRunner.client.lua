--script for running client objects, gets deleted with the character
--SHOULD fix memory leak issues in JToH

--nevermind lol coroutines could be used hahahahaha
--nevermind again i can't really find any use for coroutines here

if script.Name == "ScriptRunner" then
	script.Disabled = true
end

if script:FindFirstChild("ExecuteFunction") then
	script.ExecuteFunction.Event:Connect(function(func)
		if typeof(func) == "function" then
			func()
		elseif typeof(func) == "Instance" and func:IsA("ModuleScript") then
			require(func)()
		end
	end)
end
