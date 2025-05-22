--[[
lolsquid0 2021-2022
Credit to Jukereise for original script
Altered to resemble OG corner clipping and fix a few bugs/nitpicks
]]

local runService = game:GetService("RunService")
local plr = game.Players.LocalPlayer
local cam = workspace.CurrentCamera

local hrp

--R6/R15 detection

plr.CharacterAdded:Connect(function()
	if plr.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15 then
		hrp = plr.Character.UpperTorso
	else
		hrp = plr.Character.Torso
	end
end)

--PARAMETERS (current values are what I've found work best to emulate corner clipping):

local cDepth = 0.05 --dictates how far inward from the corner you can stand while clipping, which helps with flatwall clip (unit: studs, range 0 to inf)
local cRatio = 0.6875 --dictates how far along a part you clip, entered as a ratio between the travelled distance and the part's size. (unit: ratio, range 0 to 1)
local cRange = math.pi / 4 --dictates the margin of error from a 180-degree turn you can have while clipping (unit: radians, range 0 to pi)
local hRange = math.atan(2 / 3) --dictates how easy it is (the range width) to perform a horizontal/one-directional clip (unit: radians, range 0 to pi/4)

--Sign function (returns sign of a value)

function sign(x)
	return x > 0 and 1 or (x < 0 and -1 or 0)
end

--Flip function, altered to support horizontal clipping as well as diagonal clipping

function flip()
	if hrp then
		local touch = hrp:FindFirstChild("TouchInterest")
		if not touch then
			hrp.Touched:Connect(function() end)
		end
		for _, t in pairs(hrp:GetTouchingParts()) do
			if t:FindFirstChild("CanFlip") and t.CanCollide and t.Anchored then
				local offsetFromPart = t.CFrame:ToObjectSpace(hrp.CFrame)
				local cameraOffset = cam.CFrame.Position - hrp.CFrame.Position
				local cornerOffsetX = math.abs(offsetFromPart.X) - (t.Size.X / 2)
				local cornerOffsetZ = math.abs(offsetFromPart.Z) - (t.Size.Z / 2)
				if cornerOffsetX > -cDepth and cornerOffsetZ > -cDepth then
					local ClipAngle = math.atan(cornerOffsetZ / cornerOffsetX)
					local cDist = -cRatio + 0.5
					if ClipAngle < hRange and ClipAngle > 0 or cornerOffsetZ < 0 then
						hrp.CFrame = t.CFrame
							* CFrame.new(
								(t.Size.X * cDist * sign(offsetFromPart.X)),
								offsetFromPart.Y,
								offsetFromPart.Z
							)
						cam.CFrame = cam.CFrame.Rotation + (hrp.CFrame.Position + cameraOffset)
					elseif ClipAngle > ((math.pi / 2) - hRange) and ClipAngle < math.pi / 2 or cornerOffsetX < 0 then
						hrp.CFrame = t.CFrame
							* CFrame.new(
								offsetFromPart.X,
								offsetFromPart.Y,
								(t.Size.Z * cDist * sign(offsetFromPart.Z))
							)
						cam.CFrame = cam.CFrame.Rotation + (hrp.CFrame.Position + cameraOffset)
					elseif ClipAngle > hRange and ClipAngle < ((math.pi / 2) - hRange) then
						hrp.CFrame = t.CFrame
							* CFrame.new(
								(t.Size.X * cDist * sign(offsetFromPart.X)),
								offsetFromPart.Y,
								(t.Size.Z * cDist * sign(offsetFromPart.Z))
							)
						cam.CFrame = cam.CFrame.Rotation + (hrp.CFrame.Position + cameraOffset)
					end
				end
				break
			end
		end
	end
end

--RoC function which fires the flip function if it detects a sudden (one-frame) change of the right magnitude in the player's y-rotation
--Meant to be a more faithful alternative to the flip script's [F] keybind

local minusOne = 0
local current = 0
local timer = 0

runService.RenderStepped:Connect(function()
	if hrp then
		minusOne = current
		local PlrOrX, PlrOrY, PlrOrZ = hrp.CFrame:ToOrientation()
		current = PlrOrY
		if math.abs(current - minusOne) > math.pi - cRange and math.abs(current - minusOne) < math.pi + cRange then
			flip()
		end
	end
end)
