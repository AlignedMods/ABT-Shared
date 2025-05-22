--[[
lolsquid0 2022

A debug handler which marks all invalid CanFlip parts bright red, deletes their CanFlip value and logs an error in the console
Made to prevent unintended bugginess with CanFlip parts

Disable if this causes too many issues
]]

local partsFound = 0

function highlight(part, errorType, tip)
	partsFound += 1
	part.Color = Color3.new(1, 0, 0)
	part.Material = Enum.Material.Slate
	part.CanFlip:Destroy()
	print(errorType .. " CanFlip part at [" .. tostring(part.Position) .. "]. " .. tip)
end

for _, i in pairs(workspace:GetDescendants()) do
	if i:FindFirstChild("CanFlip") then
		if i:IsA("BasePart") then
			if i:IsA("Part") then
				local rotX, rotY, rotZ = i.CFrame:ToOrientation()
				if i.Shape ~= Enum.PartType.Block then
					highlight(i, "Round", "Only use the CanFlip value on blocks.")
				elseif rotX ~= 0 or rotZ ~= 0 then
					highlight(i, "Misoriented", "X and Z orientation should be set to zero.")
				end
			else
				highlight(i, "Invalid", "Only use the CanFlip value on blocks.")
			end	
		end
	end
end

if partsFound > 0 then
	print("CanClip debug finished! " .. partsFound .. " invalid parts found.")
end