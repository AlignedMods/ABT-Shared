game.Players.PlayerAdded:Connect(function(player)
	if player.Name == "LeoIsnVeryEpic" then
		player.CharacterAdded:Connect(function(char)
			for _,d in char:GetDescendants() do
				if d.Name == "Head" then
					--d.Transparency = 1
				elseif d.Name == "face" then
					--d:Destroy()
				end
			end
		end)
	end
	
	player.Chatted:Connect(function(msg)
		local splits = msg:split(" ")
		if splits[1] == "/load" then
			game.ReplicatedStorage.AdminEvents:FindFirstChild("Load"):FireClient(player, splits[2])
			print("Loading ".. splits[2])
		end
		
		if splits[1] == "/kill" then
			player:LoadCharacter()
		end
	end)
end)
