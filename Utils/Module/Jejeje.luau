local Module = {}
local _ENV = (getgenv or getrenv or getfenv)()
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Player = Players.LocalPlayer

local redz = redz or {}
redz.AutoAttack = redz.AutoAttack or false

local Settings = {
	Distance = 100,
	ClickDelay = 0
}

local function IsAlive(Character)
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	return Humanoid and Humanoid.Health > 0
end

local function GetTargets()
	local Targets = {}

	local Character = Player.Character
	if not Character then
		return Targets
	end

	local RootPart = Character:FindFirstChild("HumanoidRootPart")
	if not RootPart then
		return Targets
	end

	local Enemies = workspace:FindFirstChild("Enemies")
	if Enemies then
		for _, Enemy in ipairs(Enemies:GetChildren()) do
			local Head = Enemy:FindFirstChild("Head")
			local Humanoid = Enemy:FindFirstChildOfClass("Humanoid")

			if Head and Humanoid and Humanoid.Health > 0 and (Head.Position - RootPart.Position).Magnitude <= Settings.Distance then
				Targets[#Targets + 1] = {Enemy, Head}
			end
		end
	end

	local Characters = workspace:FindFirstChild("Characters")
	if Characters then
		for _, CharacterTarget in ipairs(Characters:GetChildren()) do
			if CharacterTarget ~= Character then
				local Head = CharacterTarget:FindFirstChild("Head")
				local Humanoid = CharacterTarget:FindFirstChildOfClass("Humanoid")

				if Head and Humanoid and Humanoid.Health > 0 and (Head.Position - RootPart.Position).Magnitude <= Settings.Distance then
					Targets[#Targets + 1] = {CharacterTarget, Head}
				end
			end
		end
	end

	for _, OtherPlayer in ipairs(Players:GetPlayers()) do
		if OtherPlayer ~= Player and OtherPlayer.Character then
			local TargetCharacter = OtherPlayer.Character
			local Head = TargetCharacter:FindFirstChild("Head")
			local Humanoid = TargetCharacter:FindFirstChildOfClass("Humanoid")

			if Head and Humanoid and Humanoid.Health > 0 and (Head.Position - RootPart.Position).Magnitude <= Settings.Distance then
				Targets[#Targets + 1] = {TargetCharacter, Head}
			end
		end
	end

	return Targets
end

local Modules = ReplicatedStorage:FindFirstChild("Modules")
local Net = Modules and Modules:FindFirstChild("Net")

local RegisterAttack = Net and Net:FindFirstChild("RE/RegisterAttack")
local RegisterHit = Net and Net:FindFirstChild("RE/RegisterHit")

local function AttackM1(Targets)
	if not RegisterAttack or not RegisterHit or #Targets == 0 then
		return
	end

	local Character = Player.Character
	if not Character then
		return
	end

	local Tool = Character:FindFirstChildOfClass("Tool")
	if not Tool or Tool.ToolTip == "Gun" then
		return
	end

	pcall(function()
		Tool:Activate()
	end)

	local BasePart = Targets[1][2]

	if Tool:FindFirstChild("LeftClickRemote") then
		for _, Target in ipairs(Targets) do
			local Enemy = Target[1]
			local RootPart = Enemy and Enemy:FindFirstChild("HumanoidRootPart")

			if RootPart then
				local Direction = (RootPart.Position - Character:GetPivot().Position).Unit

				pcall(function()
					Tool.LeftClickRemote:FireServer(Direction, 1)
				end)
			end
		end
	else
		pcall(function()
			RegisterAttack:FireServer(Settings.ClickDelay)
			RegisterHit:FireServer(BasePart, Targets)
		end)
	end
end

local function StartAttack()
	task.spawn(function()
		while task.wait(Settings.ClickDelay) do
			if not redz.AutoAttack then
				continue
			end

			local Character = Player.Character
			if not IsAlive(Character) then
				continue
			end

			local Targets = GetTargets()

			if #Targets > 0 then
				AttackM1(Targets)
			end
		end
	end)
end

function Module.SetAutoAttack(State)
	redz.AutoAttack = State == true
end

function Module.GetAutoAttack()
	return redz.AutoAttack
end

function Module.SetDistance(Distance)
	Settings.Distance = tonumber(Distance) or 100
end

function Module.Start()
	if Module.Started then
		return
	end

	Module.Started = true
	StartAttack()
end

Module.FastAttack = {
	Attack = AttackM1,
	GetTargets = GetTargets,
	SetAutoAttack = Module.SetAutoAttack,
	GetAutoAttack = Module.GetAutoAttack,
	SetDistance = Module.SetDistance
}

_ENV.rz_FastAttack = Module.FastAttack

return Module
