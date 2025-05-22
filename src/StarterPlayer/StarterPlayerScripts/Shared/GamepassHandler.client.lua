local marketplaceService = game:GetService("MarketplaceService")

local plr = game.Players.LocalPlayer
local tools = game.ReplicatedStorage.GamepassTools

plr.CharacterAdded:Connect(function()
	if marketplaceService:UserOwnsGamePassAsync(plr.UserId, 1096967429) then
		tools:WaitForChild("T-Pose"):Clone().Parent = plr.Backpack
	end
end)