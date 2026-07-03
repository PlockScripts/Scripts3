local Translator = {}

local Loaded = false
local Language = {}

function Translator.Init(Settings)

    if Loaded then
        return
    end

    Loaded = true

    if not Settings or not Settings.Translator then
        return
    end

local CountryFile = "PlayerCountry.txt"
local TranslatorURL = "https://raw.githubusercontent.com/newredzv3/Scripts/refs/heads/main/Translator/BloxFruits/"

_G.RedzTranslator = nil

local HttpService = game:GetService("HttpService")
local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")

local Plr = Players.LocalPlayer

local function Request(url)
	if syn and syn.request then
		return syn.request({
			Url = url,
			Method = "GET"
		}).Body
	elseif http_request then
		return http_request({
			Url = url,
			Method = "GET"
		}).Body
	elseif request then
		return request({
			Url = url,
			Method = "GET"
		}).Body
	else
		return game:HttpGet(url)
	end
end

local function GetCountry()
	local Country = "US"

	if isfile and isfile(CountryFile) then
		Country = readfile(CountryFile)
	else
		pcall(function()
			Country = LocalizationService:GetCountryRegionForPlayerAsync(Plr)
		end)

		if not Country or Country == "" then
			Country = "US"
		end

		if writefile then
			writefile(CountryFile, Country)
		end
	end

	if Country == "US" then
		Country = "BR"
	end

	return Country
end

if Settings.Translator then
	local Country = GetCountry()

	local Map = {
		BR = "Portuguese.json",
		PT = "Portuguese.json",
		TH = "Thai.json",
		VN = "Vietnamese.json"
	}

	local File = Map[Country]

	if File then
		local success, data = pcall(function()
			return HttpService:JSONDecode(Request(TranslatorURL .. File))
		end)

		if success and type(data) == "table" then
			_G.RedzTranslator = data
		end
	end
end

end

function Translator.Translate(Text)

    if not next(Language) then
        return Text
    end

    local Value = Language[Text]

    if type(Value) == "table" then
        return Value[1]
    end

    return Value or Text

end

function Translator.TranslateDescription(Name, Desc)

	if _G.RedzTranslator and name then
		local v = _G.RedzTranslator[name]

		if v and type(v) == "table" then
			if v[2] then
				return v[2]
			end
		end
	end

	return desc
end

function Translator.HookTab(Tab)
	if not Tab then
		return
	end

	local function FixConfig(config)
		if not config or type(config) ~= "table" then
			return config
		end

		local OriginalName = config.Name or config.Title or config[1]

		if config.Name then
			config.Name = Translate(config.Name)
		end

		if config.Title then
			config.Title = Translate(config.Title)
		end

		if config.Desc then
			config.Desc = TranslateDescription(OriginalName, config.Desc)
		end

		if config.Description then
			config.Description = TranslateDescription(OriginalName, config.Description)
		end

		if not config.Description and OriginalName then
			local translatedDescription = TranslateDescription(OriginalName)

			if translatedDescription then
				config.Description = translatedDescription
			end
		end

		if config[1] and type(config[1]) == "string" then
			config[1] = Translate(config[1])
		end

		return config
	end

	local oldAddToggle = Tab.AddToggle
	if oldAddToggle then
		Tab.AddToggle = function(self, config)
			return oldAddToggle(self, FixConfig(config))
		end
	end

	local oldAddButton = Tab.AddButton
	if oldAddButton then
		Tab.AddButton = function(self, config)
			return oldAddButton(self, FixConfig(config))
		end
	end

	local oldAddDropdown = Tab.AddDropdown
	if oldAddDropdown then
		Tab.AddDropdown = function(self, config)
			return oldAddDropdown(self, FixConfig(config))
		end
	end

	local oldAddParagraph = Tab.AddParagraph
	if oldAddParagraph then
		Tab.AddParagraph = function(self, config)
			return oldAddParagraph(self, FixConfig(config))
		end
	end

	local oldAddSection = Tab.AddSection
	if oldAddSection then
		Tab.AddSection = function(self, config)
			if type(config) == "string" then
				config = Translate(config)
			elseif type(config) == "table" and config[1] then
				config[1] = Translate(config[1])
			end

			return oldAddSection(self, config)
		end
	end

	local oldAddSlider = Tab.AddSlider
	if oldAddSlider then
		Tab.AddSlider = function(self, config)
			return oldAddSlider(self, FixConfig(config))
		end
	end
end
end

function Translator.HookLibrary(Library)

    local Old = Library.MakeTab

    Library.MakeTab = function(self, Config)

        if Config and Config[1] then
            Config[1] = Translator.Translate(Config[1])
        end

        local Tab = Old(self, Config)

        Translator.HookTab(Tab)

        return Tab
    end

end

return Translator
