local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local PhysicsService = game:GetService("PhysicsService")

local Player = Players.LocalPlayer
local _ENV = (getgenv or getrenv or getfenv)()

local PlayerTP = {}
PlayerTP.__index = PlayerTP

local ActiveTween = false
local TweenId = 0

local Settings = {
	TweenSpeed = 300,
	NoClip = true
}

local COLLISION_GROUP = "Players"

local function GetCharacter()
	if not Player.Character then
		Player.CharacterAdded:Wait()
	end

	Player.Character:WaitForChild("HumanoidRootPart")

	return Player.Character
end

local function ToggleNoClip(State)
	local Character = Player.Character

	if not Character then
		return
	end

	for _, v in pairs(Character:GetDescendants()) do
		if v:IsA("BasePart") then
			pcall(function()
				PhysicsService:SetPartCollisionGroup(v, State and COLLISION_GROUP or "Default")
			end)
		end
	end
end

function PlayerTP:GetHover(RootPart)
	local BV = RootPart:FindFirstChild("KAHover")

	if not BV then
		BV = Instance.new("BodyVelocity")
		BV.Name = "KAHover"
		BV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
		BV.P = 1e9
		BV.Velocity = Vector3.zero
		BV.Parent = RootPart
	end

	return BV
end

function PlayerTP:SetSpeed(Speed)
	Settings.TweenSpeed = tonumber(Speed) or Settings.TweenSpeed
end

function PlayerTP:GetSpeed()
	return Settings.TweenSpeed
end

function PlayerTP:IsTweening()
	return ActiveTween
end

function PlayerTP:Stop()
	ActiveTween = false
	TweenId += 1

	local Character = Player.Character

	if Character then
		local RootPart = Character:FindFirstChild("HumanoidRootPart")

		if RootPart then
			local Hover = RootPart:FindFirstChild("KAHover")

			if Hover then
				Hover:Destroy()
			end

			RootPart.AssemblyLinearVelocity = Vector3.zero
		end
	end

	ToggleNoClip(false)
end

RunService.Stepped:Connect(function()
	if not ActiveTween then
		return
	end

	if _ENV.OnFarm == false then
		PlayerTP:Stop()
		return
	end

	local Character = Player.Character

	if not Character then
		PlayerTP:Stop()
		return
	end

	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Character:FindFirstChild("HumanoidRootPart")

	if not Humanoid or not RootPart or Humanoid.Health <= 0 then
		PlayerTP:Stop()
		return
	end

	Humanoid:ChangeState(Enum.HumanoidStateType.Freefall)

	local Hover = PlayerTP:GetHover(RootPart)
	Hover.Velocity = Vector3.zero

	if Settings.NoClip then
		ToggleNoClip(true)
	end
end)

function PlayerTP:Teleport(TargetCFrame)
	self:Stop()

	local Character = GetCharacter()
	local Humanoid = Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Character:FindFirstChild("HumanoidRootPart")

	if not Humanoid or Humanoid.Health <= 0 then
		return false
	end

	if Humanoid.Sit then
		Humanoid.Sit = false
		return false
	end

	ActiveTween = true
	TweenId += 1

	local CurrentTweenId = TweenId

	task.spawn(function()
		if Settings.NoClip then
			ToggleNoClip(true)
		end

		local TargetPosition = TargetCFrame.Position
		local TargetY = TargetPosition.Y + 3

		while ActiveTween and CurrentTweenId == TweenId do
			if _ENV.OnFarm == false then
				PlayerTP:Stop()
				return
			end

			local CurrentPosition = RootPart.Position
			local Distance = (CurrentPosition - TargetPosition).Magnitude

			if Distance <= 5 then
				break
			end

			local Direction = Vector3.new(TargetPosition.X, TargetY, TargetPosition.Z) - CurrentPosition

			if Direction.Magnitude <= 0 then
				break
			end

			local Delta = task.wait()

			if not ActiveTween or CurrentTweenId ~= TweenId then
				return
			end

			Direction = Direction.Unit

			local MoveStep = Direction * Settings.TweenSpeed * Delta

			if MoveStep.Magnitude > Distance then
				MoveStep = Direction * Distance
			end

			RootPart.AssemblyLinearVelocity = Vector3.zero
			RootPart.CFrame = CFrame.new(CurrentPosition + MoveStep, TargetPosition)
		end

		if ActiveTween and CurrentTweenId == TweenId and _ENV.OnFarm ~= false then
			RootPart.CFrame = TargetCFrame
		end

		if CurrentTweenId == TweenId then
			PlayerTP:Stop()
		end
	end)

	return true
end

local function PlayerTPFunction(TargetCFrame)
	return PlayerTP:Teleport(TargetCFrame)
end

return PlayerTPFunction
