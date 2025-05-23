game.StarterPlayer.CharacterUseJumpPower = true
game.StarterPlayer.AutoJumpEnabled = false
game.StarterGui.ScreenOrientation = Enum.ScreenOrientation.LandscapeSensor

phs = game:GetService("PhysicsService")

local def='Default'
local plr='Player'
local cos='ClientObjects'
local otherplrs='OtherPlayers'
local collidewplrs='OnlyCollideWithPlayers'
local nocollidewplrs='DoNotCollideWithPlayers'
local nocollidewself='DoNotCollideWithSelf'
local collidewplrs2='OnlyCollideWithPlayers2'
local nevercollide='NeverCollide'
local funitem='FunItem'
local alwayscollide='AlwaysCollide'
phs:RegisterCollisionGroup(plr)
phs:RegisterCollisionGroup(otherplrs)
phs:RegisterCollisionGroup(collidewplrs)
phs:RegisterCollisionGroup(nocollidewplrs)
phs:RegisterCollisionGroup(nocollidewself)
phs:RegisterCollisionGroup(collidewplrs2)
phs:RegisterCollisionGroup(cos)
phs:RegisterCollisionGroup(nevercollide)
phs:RegisterCollisionGroup(funitem)
phs:RegisterCollisionGroup(alwayscollide)
phs:CollisionGroupSetCollidable(plr,otherplrs,false)
phs:CollisionGroupSetCollidable(cos,otherplrs,false)
phs:CollisionGroupSetCollidable(collidewplrs,otherplrs,false)
phs:CollisionGroupSetCollidable(nocollidewplrs,otherplrs,false)
phs:CollisionGroupSetCollidable(collidewplrs,def,false)
phs:CollisionGroupSetCollidable(collidewplrs,nocollidewplrs,false)
phs:CollisionGroupSetCollidable(collidewplrs,cos,false)
phs:CollisionGroupSetCollidable(collidewplrs,otherplrs,false)
phs:CollisionGroupSetCollidable(plr,nocollidewplrs,false)
phs:CollisionGroupSetCollidable(nocollidewself,nocollidewself,false)
phs:CollisionGroupSetCollidable(collidewplrs2,def,false)
phs:CollisionGroupSetCollidable(collidewplrs2,nocollidewplrs,false)
phs:CollisionGroupSetCollidable(collidewplrs2,cos,false)
phs:CollisionGroupSetCollidable(collidewplrs2,otherplrs,false)
phs:CollisionGroupSetCollidable(collidewplrs2,collidewplrs,false)
phs:CollisionGroupSetCollidable(def,nocollidewself,true)
phs:CollisionGroupSetCollidable(cos,nocollidewself,true)
phs:CollisionGroupSetCollidable(plr,nocollidewself,true)
phs:CollisionGroupSetCollidable(def,nevercollide,false)
phs:CollisionGroupSetCollidable(plr,nevercollide,false)
phs:CollisionGroupSetCollidable(cos,nevercollide,false)
phs:CollisionGroupSetCollidable(funitem,nevercollide,false)
phs:CollisionGroupSetCollidable(otherplrs,nevercollide,false)
phs:CollisionGroupSetCollidable(nocollidewplrs,nevercollide,false)
phs:CollisionGroupSetCollidable(collidewplrs,nevercollide,false)
phs:CollisionGroupSetCollidable(collidewplrs2,nevercollide,false)
phs:CollisionGroupSetCollidable(nevercollide,nevercollide,false)
phs:CollisionGroupSetCollidable(nocollidewself,nevercollide,false)
phs:CollisionGroupSetCollidable(funitem,otherplrs,false)
phs:CollisionGroupSetCollidable(funitem,plr,false)
phs:CollisionGroupSetCollidable(funitem,cos,false)
phs:CollisionGroupSetCollidable(funitem,collidewplrs,false)
phs:CollisionGroupSetCollidable(funitem,collidewplrs2,false)
phs:CollisionGroupSetCollidable(funitem,nocollidewplrs,false)
phs:CollisionGroupSetCollidable(funitem,nocollidewself,false)
phs:CollisionGroupSetCollidable(alwayscollide,otherplrs,false) --guess it doesnt always collide
phs:CollisionGroupSetCollidable(alwayscollide,nevercollide,false)

--game.Players.PlayerAdded:Connect(function(p)
--	phs:CreateCollisionGroup(p.Name)
--	phs:CollisionGroupSetCollidable(p.Name,p.Name,true)
--	for i,v in pairs(game.Players:GetChildren()) do
--		if v ~= p then
--			phs:CollisionGroupSetCollidable(p.Name,v.Name,false)
--		end
--	end
--	p.CharacterAdded:connect(function(c)
--		for i,v in pairs(c:GetChildren()) do
--			if v:IsA("BasePart") then
--				phs:SetPartCollisionGroup(v,p.Name)
--			end
--		end
--		c.ChildAdded:connect(function(v)
--			if v:IsA("BasePart") then
--				phs:SetPartCollisionGroup(v,p.Name)
--			end
--		end)
--	end)
--end)
--
--game.Players.PlayerRemoving:Connect(function(p)
--	phs:RemoveCollisionGroup(p.Name)
--end)