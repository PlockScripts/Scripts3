



local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalizationService = game:GetService("LocalizationService")
local UserInputService = game:GetService("UserInputService")
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local vu2 = game:GetService("VirtualInputManager")
local vu3 = game:GetService("LocalizationService")
local vu4 = game:GetService("CollectionService")
local vu5 = game:GetService("ReplicatedStorage")
local vu6 = game:GetService("VirtualUser")
local vu7 = game:GetService("HttpService")
local v8 = game:GetService("RunService")
local vu9 = game:GetService("Lighting")
local vu10 = game:GetService("Players")
local vu11 = game:GetService("CoreGui")
local vu12 = workspace.CurrentCamera
local vu13 = v8.Stepped
local vu14 = vu10.LocalPlayer
local vu15 = vu14:WaitForChild("Data")
vu15:WaitForChild("LastSpawnPoint")
vu15:WaitForChild("SpawnPoint")
local vu16 = vu15:WaitForChild("Fragments")
local vu17 = vu15:WaitForChild("Subclass")
local vu18 = vu15:WaitForChild("FruitCap")
local vu19 = vu15:WaitForChild("Level")
local vu20 = vu15:WaitForChild("Beli")
local vu21 = workspace:WaitForChild("Map")
local vu22 = workspace:WaitForChild("NPCs")
local vu23 = workspace:WaitForChild("Boats")
local vu24 = workspace:WaitForChild("SeaBeasts")
local vu25 = workspace:WaitForChild("Enemies")
local vu26 = workspace:WaitForChild("Characters")
local vu27 = workspace:WaitForChild("_WorldOrigin")
local vu28 = vu27:WaitForChild("Locations")
vu27:WaitForChild("PlayerSpawns")
local vu29 = vu5:WaitForChild("Remotes")
local vu30 = vu5:WaitForChild("Modules")
local vu31 = vu30:WaitForChild("Net")
local vu82 = nil
local vu464 = function() return false end
local Workspace = game:GetService("Workspace")
local FishReplicated = RS:WaitForChild("FishReplicated")
local FishingRequest = FishReplicated:WaitForChild("FishingRequest")
local Net = RS:WaitForChild("Modules"):WaitForChild("Net")
local CraftRemote = Net:WaitForChild("RF/Craft")
local JobsRemote = Net:WaitForChild("RF/JobsRemoteFunction")
local ToolAbilities = Net:WaitForChild("RF/JobToolAbilities")
local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage");
local UserInputService = game:GetService("UserInputService");
local RunService = game:GetService("RunService");
local Players = game:GetService("Players");
local Player = Players.LocalPlayer;
local Plr = Players.LocalPlayer
local plr = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local _ENV = (getgenv or getrenv or getfenv)()
local Connections = {}
Settings = Settings or {}
local Settings = _ENV.rz_settings or {
SmoothMode = false
}

local CoreGui = (gethui and gethui()) or game:GetService("CoreGui")

local function DistanceFromMyCharacter(Position)
local Character = Player.Character

if not Character or not Character.PrimaryPart then  
	return math.huge  
end  
  
local TargetPosition  
  
if typeof(Position) == "Instance" then  
	if Position:IsA("BasePart") then  
		TargetPosition = Position.Position  
	elseif Position:IsA("Model") and Position.PrimaryPart then  
		TargetPosition = Position.PrimaryPart.Position  
	else  
		return math.huge  
	end  
elseif typeof(Position) == "Vector3" then  
	TargetPosition = Position  
else  
	return math.huge  
end  
  
return (Character.PrimaryPart.Position - TargetPosition).Magnitude
end
     local Managers = {} do
     Managers.EspManager = (function()
     local EspManager = {}
          EspManager.__index = EspManager
          EspManager.__newindex = function(self, index, value)
if index == "Enabled" then
task.spawn(self.ToggleEsp, self, value)
else
rawset(self, index, value)
end
end

local CoreGuiEspFolder = Instance.new("Folder", CoreGui) do  
		CoreGuiEspFolder.Name = "redzHub-EspFolder"  
		  
		local _EspFolder = CoreGui:FindFirstChild(CoreGuiEspFolder.Name)  
		  
		if _EspFolder and _EspFolder ~= CoreGuiEspFolder then  
			_EspFolder:Destroy()  
		end  
	end  
	  
	local EspTemplate = Instance.new("BoxHandleAdornment") do  
		local BoxHandleAdornment = EspTemplate  
		BoxHandleAdornment.Size = Vector3.new(1, 0, 1, 0)  
		BoxHandleAdornment.AlwaysOnTop = true  
		BoxHandleAdornment.ZIndex = 10  
		BoxHandleAdornment.Transparency = 0  
		  
		local BillboardGui = Instance.new("BillboardGui", BoxHandleAdornment)  
		BillboardGui.Size = UDim2.new(0, 100, 0, 150)  
		BillboardGui.StudsOffset = Vector3.new(0, 2, 0)  
		BillboardGui.AlwaysOnTop = true  
		  
		local TextLabel = Instance.new("TextLabel", BillboardGui)  
		TextLabel.BackgroundTransparency = 1  
		TextLabel.Position = UDim2.new(0, 0, 0, -50)  
		TextLabel.Size = UDim2.new(0, 100, 0, 100)  
		TextLabel.TextSize = 10  
		TextLabel.TextStrokeTransparency = 0  
		TextLabel.TextYAlignment = Enum.TextYAlignment.Bottom  
		TextLabel.Text = "..."  
		TextLabel.ZIndex = 15  
		TextLabel.RichText = true  
	end  
	  
	local DefaultEspColor = Color3.fromRGB(255, 255, 255)  
	local HumHealth = "%s<font color='rgb(160, 160, 160)'> [ %im ]</font>\n<font color='rgb(25, 240, 25)'>[%i/%i]</font>"  
	local CreatedEsps = {}  
    EspManager.CreatedEsps = CreatedEsps  
	local function GetBasePart(Instance)  
		if Instance:IsA("BasePart") then  
			return Instance  
		elseif Instance:IsA("Model") then  
			return Instance.PrimaryPart or Instance:GetPivot()  
		elseif Instance.Parent:IsA("Model") then  
			return Instance.Parent.PrimaryPart or Instance.Parent:GetPivot()  
		end  
	end  
	  
	function EspManager:SetCustomEspDisplay(Action)  
		self.CustomEspDisplay = Action  
		return self  
	end  
	  
	function EspManager:SetObjects(Objects)  
		self.GetObjectsAction = Objects  
		return self  
	end  
	  
	function EspManager:GetInstance(Action)  
		self.OnlyOneInstanceAction = Action  
		return self  
	end  
	  
	function EspManager:SetInstanceName(Instance, Name)  
		self.EspsNames[Instance] = Name  
		return self  
	end  
	  
	function EspManager:SetAllInstancesName(Name)  
		self.CustomInstanceName = Name  
		return self  
	end  
	  
	function EspManager:WaitChildsAdded()  
		self._WaitChildsAdded = true  
		return self  
	end  
	  
	function EspManager:SetEspColor(Action)  
		self.EspColor = Action  
		return self  
	end  
	  
	function EspManager:SetAlwaysValidate()  
		self.AlwaysValidateInstance = true  
		return self  
	end  
	  
	function EspManager:Validator(Action)  
		self.ValidateInstance = Action  
		return self  
	end  
	  
	function EspManager:ChangeEspSize(Size)  
		self.EspSize = Size  
		  
		for i = 1, #CreatedEsps do  
			for _, Esp in pairs(CreatedEsps[i].EspObjects) do  
				Esp.BoxHandleAdornment.BillboardGui.TextLabel.TextSize = Size  
			end  
		end  
		  
		return self  
	end  
	  
	function EspManager:StartRunningEsp(Esp)  
		local Instance = Esp.Instance  
		local BoxHandleAdornment = Esp.BoxHandleAdornment  
		local TextLabel = BoxHandleAdornment.BillboardGui.TextLabel  
		local Folder = self.EspFolder  
		local IsModel = Instance:IsA("Model")  
		local CachedBasePart = nil  
		  
		while task.wait(Settings.SmoothMode and 0.25 or 0) do  
			if not BoxHandleAdornment or not BoxHandleAdornment.Parent then  
				return self:Clear(Esp)  
			elseif self.AlwaysValidateInstance and not self.ValidateInstance(Instance) then  
				return self:Clear(Esp)  
			elseif not Instance:IsDescendantOf(workspace) and not Instance:IsDescendantOf(ReplicatedStorage) then  
				return self:Clear(Esp)  
			end  
			  
			CachedBasePart = CachedBasePart or GetBasePart(Instance)  
			  
			if not CachedBasePart then  
				return self:Clear(Esp)  
			end  
			  
			local Distance = math.floor((DistanceFromMyCharacter(CachedBasePart)) / 5)  
			local Humanoid = IsModel and Instance:FindFirstChildOfClass("Humanoid")  
			  
			if Humanoid then  
				TextLabel.Text = HumHealth:format(Instance.Name, Distance, math.floor(Humanoid.Health), math.floor(Humanoid.MaxHealth))  
			elseif self.CustomEspDisplay then  
				TextLabel.Text = self.CustomEspDisplay(Instance, Distance)  
			else  
				local Name = self.CustomInstanceName or self.EspsNames[Instance] or Instance.Name  
				TextLabel.Text = ("%s < %i >"):format(Name, Distance)  
			end  
		end  
	end  
	  
	function EspManager:Create(Instance)  
		if self.EspObjects[Instance] then return end  
		  
		local Esp = {  
			Instance = Instance,  
			BoxHandleAdornment = nil  
		}  
		  
		local BoxHandleAdornment = EspTemplate:Clone()  
		local BillboardGui = BoxHandleAdornment.BillboardGui  
		local TextLabel = BillboardGui.TextLabel  
		  
		BillboardGui.Adornee = (Instance:IsA("BasePart") or Instance:IsA("Model")) and Instance or Instance.Parent  
		TextLabel.TextColor3 = type(self.EspColor) == "function" and self.EspColor(Instance) or self.EspColor or DefaultEspColor  
		TextLabel.Text = self.CustomInstanceName or "..."  
		TextLabel.TextSize = self.EspSize or TextLabel.TextSize  
		BoxHandleAdornment.Parent = self.EspFolder  
		  
		self.EspObjects[Instance] = Esp  
		Esp.BoxHandleAdornment = BoxHandleAdornment  
		  
		task.spawn(self.StartRunningEsp, self, Esp)  
		  
		return Esp  
	end  
	  
	function EspManager:Clear(Esp)  
		if Esp then  
			self.EspObjects[Esp.Instance] = nil  
			if Esp.BoxHandleAdornment then Esp.BoxHandleAdornment:Destroy() end  
		else  
			table.clear(self.EspObjects)  
			self.EspFolder:ClearAllChildren()  
		end  
	end  
	  
	function EspManager:ToggleEsp(Value)  
		local Environment = "redzHub_Esp_" .. self.SpecialTag  
		_ENV[Environment] = Value  
  
		if not Value then  
			return self:Clear()  
		end  
  
		while _ENV[Environment] do  
			local ObjectsAction = self.GetObjectsAction  
	  
			if self.OnlyOneInstanceAction then  
				local Instance = self.OnlyOneInstanceAction()  
		  
				if Instance then  
					self:Create(Instance)  
				end  
		  
			elseif ObjectsAction then  
				local Instances  
		  
				if typeof(ObjectsAction) == "function" then
					Instances = ObjectsAction()
				elseif typeof(ObjectsAction) == "Instance" then
					Instances = ObjectsAction:GetChildren()
				else
					Instances = ObjectsAction
					end

				if type(Instances) ~= "table" then
					Instances = {}
				end
		  
				local Validate = self.ValidateInstance  
				local CreatedEsps = self.EspObjects  
				local CreatedNew = false  
		  
				for i = 1, #Instances do  
					local Instance = Instances[i]  
			  
					if not CreatedEsps[Instance] and (not Validate or Validate(Instance)) then  
						CreatedNew = true  
						self:Create(Instance)  
					end  
				end  
		  
				if not CreatedNew and self._WaitChildsAdded and typeof(ObjectsAction) == "Instance" then  
					ObjectsAction.ChildAdded:Wait()  
				end  
			end  
	  
			task.wait(0.25)  
		end  
	end  
	  
	function EspManager.new(Tag)  
		local EspFolder = Instance.new("Folder", CoreGuiEspFolder)  
		EspFolder.Name = Tag  
		  
		local self = setmetatable({  
			SpecialTag = Tag,  
			EspObjects = {},  
			EspsNames = {},  
			EspFolder = EspFolder  
		}, EspManager)  
		  
		table.insert(CreatedEsps, self)  
		  
		return self  
	end  
	  
	return EspManager  
  end)()
 end
local PlayerESP = Managers.EspManager.new("Players")

PlayerESP:SetObjects(function()
local PlayersTable = {}

for _,v in pairs(game:GetService("Players"):GetPlayers()) do  
	if v ~= Player and v.Character then  
		table.insert(PlayersTable, v.Character)  
	end  
end  

return PlayersTable

end)

PlayerESP:Validator(function(Character)
return Character
and Character:FindFirstChild("HumanoidRootPart")
and Character:FindFirstChildOfClass("Humanoid")
end)
local FruitESP = Managers.EspManager.new("Fruits")

local CachedFruits = {}

local function IsHeld(tool)
	local parent = tool.Parent
	return parent and parent:FindFirstChildOfClass("Humanoid") ~= nil
end

local function GetHandle(tool)
	local handle = tool:FindFirstChild("Handle")
	if handle and handle:IsA("BasePart") then
		return handle
	end

	if tool:IsA("Model") then
		return tool.PrimaryPart or tool:FindFirstChildWhichIsA("BasePart")
	end

	return nil
end

local function UpdateFruits()
	table.clear(CachedFruits)

	for _, v in pairs(workspace:GetChildren()) do
		if v:IsA("Tool") and v.Name:find("Fruit") then
			if not Players:GetPlayerFromCharacter(v.Parent) and not IsHeld(v) then
				local handle = GetHandle(v)
				if handle then
					table.insert(CachedFruits, v)
				end
			end
		end
	end
end

UpdateFruits()

workspace.ChildAdded:Connect(function(v)
	if v:IsA("Tool") and v.Name:find("Fruit") then
		task.wait(0.1)
		UpdateFruits()
	end
end)

workspace.ChildRemoved:Connect(function(v)
	if v:IsA("Tool") and v.Name:find("Fruit") then
		UpdateFruits()
	end
end)

FruitESP:SetObjects(function()
	return CachedFruits
end)

FruitESP:Validator(function(Fruit)
	if not Fruit or not Fruit.Parent then return false end
	if Players:GetPlayerFromCharacter(Fruit.Parent) then return false end
	if IsHeld(Fruit) then return false end

	return GetHandle(Fruit) ~= nil
end)

FruitESP:SetEspColor(Color3.fromRGB(200, 0, 0))

FruitESP:SetCustomEspDisplay(function(Fruit, Distance)
	local handle = GetHandle(Fruit)
	if not handle then return end

	local char = Players.LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")

	if not hrp then
		return ("Fruit [ %s ] < ?m >"):format(Fruit.Name:gsub(" Fruit", ""))
	end

	local dist = (hrp.Position - handle.Position).Magnitude
	dist = math.floor(dist / 5)

	return ("Fruit [ %s ] < %im >"):format(Fruit.Name:gsub(" Fruit", ""), dist)
end)

local BerryESP = Managers.EspManager.new("Berries")

BerryESP:SetObjects(function()
	return CollectionService:GetTagged("BerryBush")
end)

BerryESP:SetAlwaysValidate()

BerryESP:Validator(function(Bush)
	if not Bush or not Bush.Parent then
		return false
	end

	local BerryName

	for _, Value in pairs(Bush:GetAttributes()) do
		if typeof(Value) == "string" and Value ~= "" then
			BerryName = Value
			break
		end
	end

	if not BerryName then
		return false
	end

	local Parent = Bush.Parent

	if not Parent then
		return false
	end

	for _, Child in ipairs(Parent:GetChildren()) do
		if Child:IsA("BasePart") then
			return true
		end
	end

	return false
end)

BerryESP:SetEspColor(function()
	return Color3.fromRGB(255,255,0)
end)

BerryESP:SetCustomEspDisplay(function(Bush, Distance)
	local BerryName = "Unknown"

	for _, Value in pairs(Bush:GetAttributes()) do
		if typeof(Value) == "string" and Value ~= "" then
			BerryName = Value
			break
		end
	end

	return string.format(
		"%s < %im >",
		BerryName,
		math.floor(Distance)
	)
end)

local ChestESP = Managers.EspManager.new("ChestESP")

ChestESP:SetObjects(function()
    return game:GetService("CollectionService"):GetTagged("_ChestTagged")
end)

ChestESP:Validator(function(Chest)
    return Chest and Chest.Parent and not Chest:GetAttribute("IsDisabled")
end)

ChestESP:SetEspColor(function(Chest)
    local Name = string.lower(Chest.Name)

    if Name:find("chest3") then
        return Color3.fromRGB(0, 255, 255)
    elseif Name:find("chest2") then
        return Color3.fromRGB(255, 255, 0)
    else
        return Color3.fromRGB(150, 150, 150)
    end
end)

ChestESP:SetCustomEspDisplay(function(Chest, Distance)
    local Name = Chest.Name

    if Name:find("Chest3") then
        Name = "Chest 3"
    elseif Name:find("Chest2") then
        Name = "Chest 2"
    else
        Name = "Chest 1"
    end

    return string.format("%s\n%d M", Name, Distance)
end)

local IslandsESP = Managers.EspManager.new("IslandsESP")

IslandsESP:SetObjects(function()
    return workspace._WorldOrigin.Locations:GetChildren()
end)

IslandsESP:SetEspColor(function()
    return Color3.fromRGB(0, 255, 255)
end)

IslandsESP:SetCustomEspDisplay(function(Island, Distance)
    return string.format("%s < %d >", Island.Name, Distance)
end)

local MyBoatESP = Managers.EspManager.new("MyBoatESP")

local function IsMyBoat(Boat)
    local Owner = Boat:FindFirstChild("Owner")
    if Owner then
        return Owner.Value.Name == Player.Name
    end
    return false
end

MyBoatESP:GetInstance(function()
    local Character = Player.Character
    if Character and Character:FindFirstChild("Humanoid") then
        local SeatPart = Character.Humanoid.SeatPart
        if SeatPart and SeatPart.Name == "VehicleSeat" then
            return SeatPart.Parent
        end
    end
    
    for _, Boat in ipairs(vu23:GetChildren()) do
        if IsMyBoat(Boat) then
            return Boat
        end
    end
end)

MyBoatESP:Validator(function(Boat)
    return Boat
        and Boat.Parent
        and Boat:IsDescendantOf(vu23)
end)

MyBoatESP:SetEspColor(function()
    return Color3.fromRGB(255, 255, 0)
end)

MyBoatESP:SetCustomEspDisplay(function(Boat, Distance)
    local Health = Boat:FindFirstChild("Health")
    
    if Health then
        local currentHealth = Health.Value or 0
        local maxHealth = Health:GetAttribute('MaxHealth') or currentHealth
        
        return string.format(
            "<font color='rgb(255,255,150)'>My Boat</font> <font color='rgb(255,200,0)'>[ %im ]</font>\n<font color='rgb(25,240,25)'>[%i/%i]</font>",
            Distance,
            math.floor(currentHealth),
            math.floor(maxHealth)
        )
    end
    
    return string.format(
        "<font color='rgb(255,255,150)'>My Boat</font> <font color='rgb(255,200,0)'>[ %im ]</font>",
        Distance
    )
end)

local LSDESP = Managers.EspManager.new("LegendarySwordDealerESP")

LSDESP:SetObjects(function()
    return workspace.NPCs:GetChildren()
end)

LSDESP:Validator(function(NPC)
    return NPC
        and NPC.Parent
        and NPC.Name == "Legendary Sword Dealer"
end)

LSDESP:SetEspColor(function()
    return Color3.fromRGB(80, 245, 245)
end)

LSDESP:SetCustomEspDisplay(function(NPC, Distance)
    return string.format(
        "%s\n%d M",
        NPC.Name,
        Distance
    )
end)

local FlowerESPManager = Managers.EspManager.new("FlowerESP")

FlowerESPManager:SetObjects(function()
    local Flowers = {}

    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == "Flower1" or v.Name == "Flower2" then
            table.insert(Flowers, v)
        end
    end

    return Flowers
end)

FlowerESPManager:SetEspColor(function(Flower)
    if Flower.Name == "Flower1" then
        return Color3.fromRGB(0, 0, 255)
    elseif Flower.Name == "Flower2" then
        return Color3.fromRGB(255, 0, 0)
    end

    return Color3.fromRGB(255, 255, 255)
end)

FlowerESPManager:SetCustomEspDisplay(function(Flower, Distance)
    local Name = Flower.Name

    if Name == "Flower1" then
        Name = "Blue Flower"
    elseif Name == "Flower2" then
        Name = "Red Flower"
    end

    return string.format(
        "%s\n%d Distance",
        Name,
        Distance
    )
end)

FlowerESPManager:SetAlwaysValidate()

FlowerESPManager:Validator(function(Flower)
    return Flower
        and Flower.Parent
        and (Flower.Name == "Flower1" or Flower.Name == "Flower2")
end)

return {
    Managers = Managers,
    PlayerESP = PlayerESP,
    FruitESP = FruitESP,
    BerryESP = BerryESP,
    ChestESP = ChestESP,
    IslandsESP = IslandsESP,
    MyBoatESP = MyBoatESP,
    LSDESP = LSDESP,
    FlowerESPManager = FlowerESPManager
}
