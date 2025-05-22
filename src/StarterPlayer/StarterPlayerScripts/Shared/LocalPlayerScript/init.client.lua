-- script made by Aligned (@LeoIsnVeryEpic) and insipred from the JToH kit "LocalPartScript"
-- the original JToH kit one is really bad btw so that's why i made this

-- Variables

local rs = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local plr = game.Players.LocalPlayer

local currentTower = plr.PlayerScripts:WaitForChild("LoadedTower")
local loadLobby = plr.PlayerScripts:WaitForChild("LoadLobby")
local loadDefualt = plr.PlayerScripts:WaitForChild("LoadByDefualt")
local scriptTable = {}

local clientObjects = Instance.new("Folder", workspace)
clientObjects.Name = "ClientParts"

local configurableProperties = { -- this is a list of every property you can change with lightingChangers
	["ColorCorrectionEffect"] = { "Brightness", "Contrast", "Saturation", "TintColor" },
	["BlurEffect"] = { "Size" },
	["Lighting"] = { "Ambient", "OutdoorAmbient", "FogEnd", "FogStart", "FogColor", "ClockTime", "Brightness" },
	["BloomEffect"] = { "Intensity", "Size", "Threshold" },
	["DepthOfFieldEffect"] = { "FarIntensity", "FocusDistance", "InFocusRadius", "NearIntensity" },
}

local defaultProperties = {}

for effect, properties in pairs(configurableProperties) do
	local defaultPropertyTable = {}
	if effect == "Lighting" then
		for _, p in pairs(properties) do
			defaultPropertyTable[p] = game.Lighting[p]
		end
	else
		if game.Lighting:FindFirstChild("LC" .. effect) == nil then
			local lcEffect = Instance.new(effect, game.Lighting)
			lcEffect.Name = "LC" .. effect

			if effect == "BlurEffect" then
				lcEffect.Size = 0
			elseif effect == "DepthOfFieldEffect" then
				lcEffect.FarIntensity = 0
				lcEffect.NearIntensity = 0
			elseif effect == "BloomEffect" then
				lcEffect.Intensity = 1
				lcEffect.Size = 24
				lcEffect.Threshold = 2
			end

			for _, p in pairs(properties) do
				defaultPropertyTable[p] = lcEffect[p]
			end
		end
	end
	defaultProperties[effect] = defaultPropertyTable
end

-- Functions

function RemoveDuplicateCOs()
	for _, i in pairs(clientObjects:GetDescendants()) do
		if i.Parent and i.Name == "ClientObject" then
			for _, j in pairs(i.Parent:GetDescendants()) do
				if j.Name == "ClientObject" and j ~= i then
					warn("Script found a double ClientObject value in " .. i.Name .. "!")
					j:Destroy()
				end
			end
		end
	end
end

function MoveClientObjects()
	for _, instance in pairs(workspace:GetDescendants()) do
		if instance.Name == "ClientSidedObjects" and instance:IsA("Folder") then
			local parentFolder = Instance.new("Folder", rs)
			parentFolder.Name = instance.Parent.Name

			instance.Parent = parentFolder
		end
	end
end

function LightingChange(config)
	if configurableProperties[config.Type] == nil then
		return
	end -- if the type of configuration isn't customazible then we should return

	local lightingInstance = (config.Type == "Lighting" and game.Lighting) or game.Lighting["LC" .. config.Type]
	local infoTable = {}

	if config.Configuration == "Default" then
		config.Configuration = defaultProperties[config.Type]
	end
	if config.TweenInfo == nil then
		config.TweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
	end

	for property, value in pairs(config.Configuration) do
		if typeof(value) == "string" or typeof(value) == "boolean" then
			lightingInstance[property] = value
		else
			infoTable[property] = value
		end
	end

	ts:Create(lightingInstance, config.TweenInfo, infoTable):Play()
end

function ResetLighting()
	for effectType, _ in pairs(configurableProperties) do
		task.spawn(function()
			LightingChange({
				Type = effectType,
				Configuration = "Default",
			})
		end)
	end
end

function ApplyPart(instance)
	if instance.Name == "ClientObjectScript" then
		if not scriptTable then
			return
		end
		table.insert(scriptTable, instance)
	end

	if instance:IsA("BasePart") then
		if instance:FindFirstChild("SetCollisionGroup") and instance.SetCollisionGroup:IsA("StringValue") then
			task.spawn(function()
				instance.CollisionGroup = instance.SetCollisionGroup.Value
			end)
		else
			instance.CollisionGroup = "ClientObjects"
		end
	end

	if instance:FindFirstChild("Invisible") or instance.Name == "Lighting Changer" then
		instance.Transparency = 1
	end
end

local function addChildren(part, newpart)
	part.ChildAdded:Connect(function(v)
		local clone = v:Clone()
		clone.Parent = newpart
		addChildren(v, clone)
		ApplyPart(part)
	end)
end

local function AddPart(instance)
	if instance.Name == "ClientObject" and instance.Parent ~= nil then
		local clone = instance.Parent:Clone()
		clone.Parent = clientObjects
		addChildren(instance, clone)
		ApplyPart(clone)
		for _, w in pairs(clone:GetDescendants()) do
			ApplyPart(w)
		end
	end
end

function LoadTower(towerName, playerName)
	if playerName ~= plr.Name then
		return
	end
	if currentTower.Value == nil and currentTower.Value ~= "Lobby" then
		return
	end

	print(towerName)

	UnloadTower()

	currentTower.Value = towerName

	if towerName ~= "Lobby" then
		_G.StartTimer()
	else
		_G.ResetTimer()
	end

	local runScript = script.ScriptRunner:Clone()
	runScript.Name = "TowerPlaceScriptLoader"

	if plr.Character:FindFirstChild("TowerPlaceScriptLoader") then
		plr.Character:FindFirstChild("TowerPlaceScriptLoader"):Destroy()
	end

	runScript.Parent = game.Players.LocalPlayer.Character

	runScript.Enabled = true

	local remote = Instance.new("BindableEvent")
	remote.Name = "ExecuteFunction"
	remote.Parent = runScript

	local coFolder = rs:FindFirstChild(towerName).ClientSidedObjects

	if coFolder == nil then
		warn("NO CLIENT OBJECT FOLDER IN " .. towerName .. "!")
	end

	for _, instance in pairs(coFolder:GetDescendants()) do
		AddPart(instance)
	end

	wait() -- idk why this is here but it was here before and i'm not removing it
	for _, scr in pairs(scriptTable) do
		spawn(function()
			runScript:WaitForChild("ExecuteFunction"):Fire(scr)
		end)
	end

	if towerName ~= "Lobby" and plr.Character.PrimaryPart ~= nil and loadDefualt.Value == "Lobby" then
		plr.Character:SetPrimaryPartCFrame(workspace.Towers:FindFirstChild(towerName).Spawn.CFrame)
	end

	table.clear(scriptTable)
end

function UnloadTower()
	-- yup the code for unloading is in here now!!

	clientObjects:ClearAllChildren()
	ResetLighting()
	table.clear(scriptTable)

	for _, d in pairs(plr.PlayerGui:WaitForChild("EffectGUI"):GetDescendants()) do
		if d:IsA("Frame") and d.Name ~= "List" and d.Name ~= "KeyList" then
			d:Destroy()
		end
	end

	if loadLobby.Value == true then
		currentTower.Value = tostring(nil)
	end
end

function ReloadTower(player)
	if player ~= plr then
		return
	end

	loadLobby.Value = false
	game.ReplicatedStorage.GameEvents.LoadCharacter:FireServer()
end

function InitCharacter(char)
	if not char then
		return
	end

	for _, instance in pairs(char:GetChildren()) do
		if instance:IsA("BasePart") then
			instance.CollisionGroup = "Player"
		end
	end
	char.ChildAdded:connect(function(instance)
		if instance:IsA("BasePart") then
			instance.CollisionGroup = "Player"
		end
	end)

	game.StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.EmotesMenu, false)

	MoveClientObjects()

	if loadLobby.Value == true then
		LoadTower(loadDefualt.Value, char.Name)
	else
		if currentTower.Value == "" then
			LoadTower("Lobby", char.Name)
		else
			LoadTower(currentTower.Value, char.Name)
		end

		if _G.playerSettings.ResetOnDeath then
			loadLobby.Value = false
		else
			loadLobby.Value = true
		end
	end

	print("Character Loaded, LoadLobby value is " .. tostring(loadLobby.Value))
end

function InitPlayer(player)
	local function InitOtherCharacters(char)
		if not char then
			return
		end

		for _, instance in pairs(char:GetChildren()) do
			if instance:IsA("BasePart") then
				instance.CollisionGroup = "OtherPlayers"
			end
		end

		char.ChildAdded:connect(function(instance)
			if instance:IsA("BasePart") then
				instance.CollisionGroup = "OtherPlayers"
			end
		end)
	end

	player.CharacterAdded:Connect(InitOtherCharacters)
	InitOtherCharacters(player.Character)
end

-- Events

game.Players.PlayerAdded:Connect(InitPlayer)
for _, player in pairs(game.Players:GetPlayers()) do
	if player == game.Players.LocalPlayer then
		continue
	end

	InitPlayer(player)
end

game.Players.PlayerRemoving:Connect(function(player)
	if player ~= plr then
		return
	end

	rs.GameEvents.SaveDatastore:FireServer(_G.playerSettings)
end)

plr.CharacterAdded:Connect(InitCharacter)
InitCharacter(plr.Character)
plr.CharacterRemoving:Connect(UnloadTower)

rs.GameEvents:FindFirstChild("LoadTower").Event:Connect(LoadTower)
rs.ChangeLighting.Event:Connect(LightingChange)
rs.GameEvents:FindFirstChild("ReloadTower").Event:Connect(ReloadTower)

rs.GameEvents:FindFirstChild("CheckLoadedTower").OnClientInvoke = function()
	return currentTower.Value
end
