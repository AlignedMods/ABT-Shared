game.ReplicatedStorage.GameEvents.SendMessage.OnClientEvent:Connect(function(msg)
	game.TextChatService.TextChannels.RBXGeneral:DisplaySystemMessage("[SYSTEM]: " .. msg)
end)