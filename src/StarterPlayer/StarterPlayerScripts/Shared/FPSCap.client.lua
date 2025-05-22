local runService = game:GetService("RunService")
local uis = game:GetService("UserInputService")

maxFPS = 360

uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	
	if input.KeyCode == Enum.KeyCode.G then
		if maxFPS == 60 then
			maxFPS = 360
		else
			maxFPS = 60
		end

		print(maxFPS)
		
		while true do

			local t0 = tick()
			runService.Heartbeat:Wait()
			repeat until (t0 + 1/maxFPS) < tick()
		end
	end
end)