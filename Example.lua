local Meow = loadstring(game:HttpGet("https://raw.githubusercontent.com/SilosDev/MeowLib/refs/heads/main/Source"))()

local Window = Meow:Window({
	Title = "Meow Demo",
	Subtitle = "Modern UI library for Roblox.",
	Size = UDim2.fromOffset(868, 650),
	DragStyle = 1,
	DisabledWindowControls = {},
	ShowUserInfo = true,
	Keybind = Enum.KeyCode.RightControl,
	AcrylicBlur = true,
})

local globalSettings = {
	UIBlurToggle = Window:GlobalSetting({
		Name = "UI Blur",
		Default = Window:GetAcrylicBlurState(),
		Callback = function(bool)
			Window:SetAcrylicBlurState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " UI Blur",
				Lifetime = 5
			})
		end,
	}),
	NotificationToggler = Window:GlobalSetting({
		Name = "Notifications",
		Default = Window:GetNotificationsState(),
		Callback = function(bool)
			Window:SetNotificationsState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Enabled" or "Disabled") .. " Notifications",
				Lifetime = 5
			})
		end,
	}),
	ShowUserInfo = Window:GlobalSetting({
		Name = "Show User Info",
		Default = Window:GetUserInfoState(),
		Callback = function(bool)
			Window:SetUserInfoState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Showing" or "Hiding") .. " User Info",
				Lifetime = 5
			})
		end,
	})
}

local tabGroups = {
	TabGroup1 = Window:TabGroup()
}

local tabs = {
	Main = tabGroups.TabGroup1:Tab({ Name = "Demo", Image = "rbxassetid://18821914323" }),
	Settings = tabGroups.TabGroup1:Tab({ Name = "Settings", Image = "rbxassetid://10734950309" })
}

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
}

sections.MainSection1:Header({
	Name = "Button and Dialog"
})

sections.MainSection1:Button({
	Name = "Click me!",
	Callback = function()
		Window:Dialog({
			Title = Window.Settings.Title,
			Description = "This is an example dialog! You can place any message here.",
			Buttons = {
				{
					Name = "Confirm",
					Callback = function()
						print("Confirmed!")
					end,
				},
				{
					Name = "Cancel"
				}
			}
		})
	end,
})

sections.MainSection1:Header({
	Name = "Input Field"
})

sections.MainSection1:Input({
	Name = "Enter text",
	Placeholder = "Type something here...",
	AcceptedCharacters = "All",
	Callback = function(input)
		Window:Notify({
			Title = Window.Settings.Title,
			Description = "You entered: " .. input
		})
	end,
	onChanged = function(input)
		print("Current text: " .. input)
	end,
}, "Input")

sections.MainSection1:Header({
	Name = "Slider"
})

sections.MainSection1:Slider({
	Name = "Volume",
	Default = 50,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percent",
	Precision = 0,
	Callback = function(Value)
		print("Changed to ".. Value)
	end
}, "Slider")

sections.MainSection1:Header({
	Name = "Toggle"
})

sections.MainSection1:Toggle({
	Name = "Enable Feature",
	Default = false,
	Callback = function(value)
		Window:Notify({
			Title = Window.Settings.Title,
			Description = (value and "Enabled " or "Disabled ") .. "Feature"
		})
	end,
}, "Toggle")

sections.MainSection1:Header({
	Name = "Keybind"
})

sections.MainSection1:Keybind({
	Name = "Keyboard Shortcut",
	Blacklist = false,
	Callback = function(binded)
		Window:Notify({
			Title = "Meow",
			Description = "You pressed: "..tostring(binded.Name),
			Lifetime = 3
		})
	end,
	onBinded = function(bind)
		Window:Notify({
			Title = "Meow",
			Description = "Successfully bound: "..tostring(bind.Name),
			Lifetime = 3
		})
	end,
}, "Keybind")

sections.MainSection1:Header({
	Name = "Color"
})

sections.MainSection1:Colorpicker({
	Name = "Pick Color",
	Default = Color3.fromRGB(0, 255, 255),
	Callback = function(color)
		print("Color: ", color)
	end,
}, "Colorpicker")

local alphaColorPicker = sections.MainSection1:Colorpicker({
	Name = "Color with Transparency",
	Default = Color3.fromRGB(255,0,0),
	Alpha = 0,
	Callback = function(color, alpha)
		print("Color: ", color, " Alpha: ", alpha)
	end,
}, "TransparencyColorpicker")

sections.MainSection1:Header({
	Name = "Effects"
})

local rainbowActive
local rainbowConnection
local hue = 0

sections.MainSection1:Toggle({
	Name = "Rainbow Effect",
	Default = false,
	Callback = function(value)
		rainbowActive = value

		if rainbowActive then
			rainbowConnection = game:GetService("RunService").RenderStepped:Connect(function(deltaTime)
				hue = (hue + deltaTime * 0.1) % 1
				alphaColorPicker:SetColor(Color3.fromHSV(hue, 1, 1))
			end)
		elseif rainbowConnection then
			rainbowConnection:Disconnect()
			rainbowConnection = nil
		end
	end,
}, "RainbowToggle")

sections.MainSection1:Header({
	Name = "Dropdown"
})

local optionTable = {
	"Apple",
	"Banana",
	"Orange",
	"Grapes",
	"Pineapple",
	"Mango",
	"Strawberry",
	"Blueberry",
	"Watermelon",
	"Peach"
}

local Dropdown = sections.MainSection1:Dropdown({
	Name = "Select Fruit",
	Multi = false,
	Required = true,
	Options = optionTable,
	Default = 1,
	Callback = function(Value)
		print("Selected: ".. Value)
	end,
}, "Dropdown")

local MultiDropdown = sections.MainSection1:Dropdown({
	Name = "Multiple Selection",
	Search = true,
	Multi = true,
	Required = false,
	Options = optionTable,
	Default = {"Apple", "Orange"},
	Callback = function(Value)
		local Values = {}
		for Value, State in next, Value do
			table.insert(Values, Value)
		end
		print("Selected:", table.concat(Values, ", "))
	end,
}, "MultiDropdown")

sections.MainSection1:Button({
	Name = "Update Selection",
	Callback = function()
		Dropdown:UpdateSelection("Mango")
		MultiDropdown:UpdateSelection({"Banana", "Pineapple"})
	end,
})

sections.MainSection1:Divider()

sections.MainSection1:Header({
	Text = "Information"
})

sections.MainSection1:Paragraph({
	Header = "About Meow UI",
	Body = "Meow UI is a modern and easy-to-use interface library. It offers many elements for creating professional UIs."
})

sections.MainSection1:Label({
	Text = "The library was created with performance in mind."
})

sections.MainSection1:SubLabel({
	Text = "All animations are smooth and optimized."
})

Meow:SetFolder("Meow")
tabs.Settings:InsertConfigSection("Left")

Window.onUnloaded(function()
	print("Meow UI loaded and working!")
end)

tabs.Main:Select()
Meow:LoadAutoLoadConfig()
