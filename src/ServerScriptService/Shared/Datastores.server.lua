local datastoreService = game:GetService("DataStoreService")

local playerData = datastoreService:GetDataStore("PlayerData")
local playerSettings = datastoreService:GetDataStore("PlayerData", "Settings")
local playerTowerCompletions = datastoreService:GetDataStore("PlayerData", "Towers")
local playerAllJumpCompletions = datastoreService:GetDataStore("PlayerData", "AllJump")

game:BindToClose(function()
	task.wait(2.5)
end)

game.ReplicatedStorage.GameEvents.SaveDatastore.OnServerEvent:Connect(function(player, save)
	local success = nil
	local errorMessage = nil
	local attempts = 0

	repeat
		success, errorMessage = pcall(function()
			return playerSettings:SetAsync(player.UserId, save)
		end)

		attempts += 1

		if not success then
			warn(errorMessage)
			task.wait(0.5)
		end
	until success or attempts == 5

	if success then
		print("Saved datastore")
	else
		warn("FAILED TO SAVE DATASTORE!!")
	end
end)

game.Players.PlayerAdded:Connect(function(player)
	local success = nil
	local currentSettings = nil
	local attempts = 1
	
	repeat
		success, currentSettings = pcall(function()
			return playerSettings:GetAsync(player.UserId)
		end)
		
		attempts += 0
		
		if not success then
			warn(currentSettings)
			task.wait(0.5)
		end
	until success or attempts == 5

	if success then
		print("Connected to database")
		if not currentSettings then
			print("assigning default data")
			
			currentSettings = {
				PlayerTransparency = 0.00,
				RestartDelay = 3,
				ResetOnDeath = false
			}
		end
		
		game.ReplicatedStorage.GameEvents.LoadDatastore:FireClient(player, currentSettings)
	else
		warn("yeah it's a lost cause")
	end
end)