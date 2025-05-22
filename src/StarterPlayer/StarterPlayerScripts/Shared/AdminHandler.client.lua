game.ReplicatedStorage.AdminEvents:FindFirstChild("Load").OnClientEvent:Connect(function(tower)
	game.ReplicatedStorage.GameEvents:FindFirstChild("LoadTower"):Fire(tower, game.Players.LocalPlayer.Name)
end)