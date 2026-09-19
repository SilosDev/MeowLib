local Meow = loadstring(game:HttpGet("https://raw.githubusercontent.com/SilosDev/MeowLib/refs/heads/main/Source"))()

local Window = Meow:Window({
	Title = "Meow Demo",
	Subtitle = "Nowoczesna biblioteka UI.",
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
				Description = (bool and "✨ Włączono" or "✨ Wyłączono") .. " UI Blur",
				Lifetime = 5
			})
		end,
	}),
	NotificationToggler = Window:GlobalSetting({
		Name = "Powiadomienia",
		Default = Window:GetNotificationsState(),
		Callback = function(bool)
			Window:SetNotificationsState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "Włączono" or "Wyłączono") .. " Powiadomienia",
				Lifetime = 5
			})
		end,
	}),
	ShowUserInfo = Window:GlobalSetting({
		Name = "Pokaż info użytkownika",
		Default = Window:GetUserInfoState(),
		Callback = function(bool)
			Window:SetUserInfoState(bool)
			Window:Notify({
				Title = Window.Settings.Title,
				Description = (bool and "👤 Widoczne" or "👤 Ukryte") .. " dane użytkownika",
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
	Settings = tabGroups.TabGroup1:Tab({ Name = "Ustawienia", Image = "rbxassetid://10734950309" })
}

local sections = {
	MainSection1 = tabs.Main:Section({ Side = "Left" }),
}

sections.MainSection1:Header({
	Name = "🎉 Przycisk i Dialog"
})

sections.MainSection1:Button({
	Name = "Kliknij mnie!",
	Callback = function()
		Window:Dialog({
			Title = Window.Settings.Title,
			Description = "To jest przykładowy dialog! Możesz tutaj umieścić dowolną wiadomość.",
			Buttons = {
				{
					Name = "Potwierdź",
					Callback = function()
						print("Potwierdzono!")
					end,
				},
				{
					Name = "Anuluj"
				}
			}
		})
	end,
})

sections.MainSection1:Header({
	Name = "📝 Pole Input"
})

sections.MainSection1:Input({
	Name = "Wpisz tekst",
	Placeholder = "Wpisz coś tutaj...",
	AcceptedCharacters = "All",
	Callback = function(input)
		Window:Notify({
			Title = Window.Settings.Title,
			Description = "Wpisany tekst: " .. input
		})
	end,
	onChanged = function(input)
		print("Aktualny tekst: " .. input)
	end,
}, "Input")

sections.MainSection1:Header({
	Name = "🎚️ Suwak"
})

sections.MainSection1:Slider({
	Name = "Głośność",
	Default = 50,
	Minimum = 0,
	Maximum = 100,
	DisplayMethod = "Percent",
	Precision = 0,
	Callback = function(Value)
		print("Zmieniono na ".. Value)
	end
}, "Slider")

sections.MainSection1:Header({
	Name = "🔘 Przełącznik"
})

sections.MainSection1:Toggle({
	Name = "Włącz funkcję",
	Default = false,
	Callback = function(value)
		Window:Notify({
			Title = Window.Settings.Title,
			Description = (value and "Włączono " or "Wyłączono ") .. "funkcję"
		})
	end,
}, "Toggle")

sections.MainSection1:Header({
	Name = "Keybind"
})

sections.MainSection1:Keybind({
	Name = "Skrót klawiszowy",
	Blacklist = false,
	Callback = function(binded)
		Window:Notify({
			Title = "Meow",
			Description = "Nacisnąłeś: "..tostring(binded.Name),
			Lifetime = 3
		})
	end,
	onBinded = function(bind)
		Window:Notify({
			Title = "Meow",
			Description = "Przypisano skrót: "..tostring(bind.Name),
			Lifetime = 3
		})
	end,
}, "Keybind")

sections.MainSection1:Header({
	Name = "Kolor"
})

sections.MainSection1:Colorpicker({
	Name = "Wybierz kolor",
	Default = Color3.fromRGB(0, 255, 255),
	Callback = function(color)
		print("Kolor: ", color)
	end,
}, "Colorpicker")

local alphaColorPicker = sections.MainSection1:Colorpicker({
	Name = "Kolor z przezroczystością",
	Default = Color3.fromRGB(255,0,0),
	Alpha = 0,
	Callback = function(color, alpha)
		print("Kolor: ", color, " Alfa: ", alpha)
	end,
}, "TransparencyColorpicker")

sections.MainSection1:Header({
	Name = "Efekty"
})

local rainbowActive
local rainbowConnection
local hue = 0

sections.MainSection1:Toggle({
	Name = "Tęczowy efekt",
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
	"Jabłko",
	"Banan",
	"Pomarańcza",
	"Winogrono",
	"Ananas",
	"Mango",
	"Truskawka",
	"Borówka",
	"Arbuz",
	"Brzoskwinia"
}

local Dropdown = sections.MainSection1:Dropdown({
	Name = "Wybierz owoc",
	Multi = false,
	Required = true,
	Options = optionTable,
	Default = 1,
	Callback = function(Value)
		print("Wybrano: ".. Value)
	end,
}, "Dropdown")

local MultiDropdown = sections.MainSection1:Dropdown({
	Name = "Wielokrotny wybór",
	Search = true,
	Multi = true,
	Required = false,
	Options = optionTable,
	Default = {"Jabłko", "Pomarańcza"},
	Callback = function(Value)
		local Values = {}
		for Value, State in next, Value do
			table.insert(Values, Value)
		end
		print("Wybrano:", table.concat(Values, ", "))
	end,
}, "MultiDropdown")

sections.MainSection1:Button({
	Name = "Zmień zaznaczenie",
	Callback = function()
		Dropdown:UpdateSelection("Mango")
		MultiDropdown:UpdateSelection({"Banan", "Ananas"})
	end,
})

sections.MainSection1:Divider()

sections.MainSection1:Header({
	Text = "Informacje"
})

sections.MainSection1:Paragraph({
	Header = "O Meow UI",
	Body = "Meow UI to nowoczesna i łatwa w użyciu biblioteka interfejsu. Oferuje wiele elementów do tworzenia profesjonalnych UI."
})

sections.MainSection1:Label({
	Text = "Biblioteka została stworzona z myślą o wydajności."
})

sections.MainSection1:SubLabel({
	Text = "Wszystkie animacje są płynne i zoptymalizowane."
})

Meow:SetFolder("Meow")
tabs.Settings:InsertConfigSection("Left")

Window.onUnloaded(function()
	print("Meow UI załadowana i działająca!")
end)

tabs.Main:Select()
Meow:LoadAutoLoadConfig()
