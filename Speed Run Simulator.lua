local Players = game:GetService("Players")
local player = Players.LocalPlayer


local function getHRP()
	return player.Character:WaitForChild("HumanoidRootPart")
end

function contains(val, tbl)
    for _, v in ipairs(tbl) do
        if v == val then
            return true
        end
    end
    return false
end

local scripts = {}
scripts.Collect = {}

scripts.Collect.InteractablesX = {
	workspace.GameAssets.GlobalAssets,
	workspace.GameAssets.Maps.Spawn.Map.Interactables,
	}
scripts.Collect.Interactables = {
	workspace.GameAssets.GlobalAssets,
	workspace.GameAssets.Maps.Spawn.Map.Interactables,
	workspace.GameAssets.Maps.AdventureTime.Map.Interactables,
	workspace.GameAssets.Maps.Candyland.Map.Interactables,
	workspace.GameAssets.Maps.Desert.Map.Interactables,
	workspace.GameAssets.Maps.Graveyard.Map.Interactables,
	workspace.GameAssets.Maps.Heaven.Map.Interactables,
	workspace.GameAssets.Maps.Iceland.Map.Interactables,
	workspace.GameAssets.Maps.Jungle.Map.Interactables,
	workspace.GameAssets.Maps.Lavaland.Map.Interactables,
	workspace.GameAssets.Maps.Medieval.Map.Interactables,
	workspace.GameAssets.Maps.Moon.Map.Interactables,
	workspace.GameAssets.Maps.Ocean.Map.Interactables,
	workspace.GameAssets.Maps.SkyIslands.Map.Interactables,
	workspace.GameAssets.Maps.VIP.Map.Interactables,
	workspace.GameAssets.Maps["Wild West"].Map.Interactables,
	workspace.GameAssets.GlobalAssets.EventAssets.Summer
	}
scripts.Collect.TargetFolders = {"Orbs", "OrbSpawns", "Ramps"}
scripts.Collect.thread = nil
function scripts.Collect.Touch(Slowdown)
	for _1, map_interactables in ipairs(scripts.Collect.Interactables) do
		for _2, target in ipairs(scripts.Collect.TargetFolders) do
			if map_interactables:FindFirstChild(target) ~= nil then
				for _4, interactable in ipairs(map_interactables:FindFirstChild(target):GetChildren()) do
					if interactable and getHRP() then
						if interactable.Name == "Orb" or interactable.Name == "PurpleOrb" or interactable.Name == "Ring" then
							firetouchinterest(interactable, getHRP(), 0)
						elseif interactable.Name == "SummerOrb" then
							firetouchinterest(interactable["Orb.1"], getHRP(), 0)
						end
						if Slowdown then
							task.wait(0.1)
						end
					end
				end
			end
		end
	end
end


function scripts.Collect.loop(enabled)
    if enabled then
        -- Start loop if not already running
        if scripts.Collect.thread == nil then
            scripts.Collect.thread = task.spawn(function()
                while true do
                    task.wait(0.1)
                    scripts.Collect.Touch()
                end
            end)
        end
	end

    -- Disable loop
    if scripts.Orbs.thread and not enabled then
        task.cancel(scripts.Orbs.thread)
        scripts.Orbs.thread = nil
    end
end

scripts.Pets = {}
scripts.Pets.GenerateActive = false
function scripts.Pets.Generate(count,sleep)
	scripts.Pets.GenerateActive = true
	for counter = 1,count do
		for counter1 = 1,2 do
			for counter2 = 1,2 do
				for counter3 = 1,2 do
					for counter4 = 1,2 do
						for counter5 = 1,2 do
							game:GetService("ReplicatedStorage").Remotes.CanBuyEgg:InvokeServer('Earth Butterfly',false)
						end
						scripts.Pets.Upgrade("Earth Butterfly",sleep)
					end
					scripts.Pets.Upgrade("Earth ButterflyG",sleep)
				end
				scripts.Pets.Upgrade("Earth ButterflyD",sleep)
			end
			scripts.Pets.Upgrade("Earth ButterflyE",sleep)
		end
		scripts.Pets.Upgrade("Earth ButterflyR",sleep)
--		task.wait(0.1)
--		scripts.Pets.UI_Cleanup()
	end
	scripts.Pets.GenerateActive = false
end
function scripts.Pets.Upgrade(text,sleep)
	wait(sleep)
	game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpgradePet"):FireServer(text)
	local deleted = 0
	for _, item in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.PetUI.SelectionPanel.ScrollingFrame:GetChildren()) do
		if item.Name == text then
			item:Destroy()
			deleted = deleted + 1
			if deleted == 2 then
				break
			end
		end
	end
end	

function scripts.Pets.UI_Cleanup()
	local dirty_names = {
		"Earth Butterfly",
		"Earth ButterflyG",
		"Earth ButterflyD",
		"Earth ButterflyE",
		"Earth ButterflyR"
	}
	for _, item in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.PetUI.SelectionPanel.ScrollingFrame:GetChildren()) do
		if contains(item.Name,dirty_names) then
			item:Destroy()
		end
	end
end

function scripts.Pets.UI_Cleanup_full()
	for _, item in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.PetUI.SelectionPanel.ScrollingFrame:GetChildren()) do
		if item.Name ~= "UIGridLayout" and item.Name ~= "CopyFrame" then
			item:Destroy()
		end
	end
end

function scripts.Pets.Equipped()
	local count = 0
	local s = game:GetService("Players").LocalPlayer.EquippedPets3.Value
	for _ in s:gmatch("'(.-)'") do
    	count = count + 1
	end
	return count
end

function scripts.Pets.Owned()
	local count = 0
	for i, v in ipairs(scripts.Pets.Getlist()) do
    	count = count + 1
	end
	return count
end

function scripts.Pets.Getlist()
    -- Remove the surrounding brackets
    str = game:GetService("Players").LocalPlayer.Pets2.Value:gsub("^%[", ""):gsub("%]$", "")

    local result = {}

    -- Match items inside single quotes
    for item in str:gmatch("\"([^\"]*)\"") do
        table.insert(result, item)
    end

    return result
end

function scripts.Pets.BulkDelete()
	 for i, v in ipairs(scripts.Pets.Getlist()) do
	 	task.wait(0)
		print(v)
		game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("DeletePet"):FireServer(v)
	end
	scripts.Pets.UI_Cleanup_full()
end

--scripts.Orbs.loop(true)
--wait(10)
--scripts.Orbs.loop(false)
--scripts.Collectibles.CollectAll()
--game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("AddSpeed"):FireServer()
--game:GetService("ReplicatedStorage").Remotes.CanBuyEgg:InvokeServer('Earth Butterfly',false)
--scripts.Pets.Generate(1,0.05)

--game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("UpgradePet"):FireServer("Earth Butterfly") G/D/E/R
--game:GetService("Players").LocalPlayer.PlayerGui.MainUI.PetUI.PetsEquipped.Value change this for inf equipped pets
--game:GetService("Players").LocalPlayer.EquippedPets3.Value is always correct
--print(scripts.Pets.Equipped())
--scripts.Collect.Touch(false)

local UI = {}

function UI.FlashText(element, thread, ftext, text)
    if not thread then
        thread = task.spawn(function()
            element:Set(ftext)
            task.wait(2)
            element:Set(text)
            UI.BulkDeleteThread = nil
        end)
    end
end

function UI.ConvertS_to_D_H_M_S(seconds)
	local days
	local hours
	local minutes
	if seconds then
		if math.floor(seconds/60) > 0 then
			minutes = math.floor(seconds/60)
			seconds = seconds%60
		end
	end
	if minutes then
		if math.floor(minutes/60) > 0 then
			hours = math.floor(minutes/60)
			minutes = minutes%60
		end
	end
	if hours then
		if math.floor(hours/24) > 0 then
			days = math.floor(hours/24)
			hours = hours%24
		end
	end
	return {days=days,hours=hours,minutes=minutes,seconds=seconds}
end

function UI.ConvertS_to_String(seconds)
	local text = ""
	local t = UI.ConvertS_to_D_H_M_S(seconds)
	if t.days ~= nil and t.days ~= 0 then
		text = text..t.days.." day"
		if t.days>1 then
			text=text.."s"
		end
		if t.hours ~= 0 or t.minutes ~= 0 or t.seconds ~= 0 then
			text = text..", "
		end
	end
	if t.hours ~= nil and t.hours ~= 0 then
		text = text..t.hours.." hour"
		if t.hours>1 then
			text=text.."s"
		end
		if t.minutes ~= 0 or t.seconds ~= 0 then
			text = text..", "
		end
	end
	if t.minutes ~= nil and t.minutes ~= 0 then
		text = text..t.minutes.." minute"
		if t.minutes>1 then
			text=text.."s"
		end
		if t.seconds ~= 0 then
			text = text..", "
		end
	end
	if t.seconds ~= nil and t.seconds ~= 0 then
		text = text..t.seconds.." second"
		if t.seconds>1 then
			text= text.."s"
		end
	end
	return text
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "ernest's script",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Rayfield Interface Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Rayfield", -- for mobile users to unhide Rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from emitting warnings when the script has a version mismatch with the interface.

   -- ScriptID = "sid_xxxxxxxxxxxx", -- Your Script ID from developer.sirius.menu — enables analytics, managed keys, and script hosting

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "E's wonderful scripts - Speed Run Simulator(1)", -- Create a custom folder for your hub/game
      FileName = "Big Hub"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include Discord.gg/. E.g. Discord.gg/ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the Discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique, as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that the system will accept, can be RAW file links (pastebin, github, etc.) or simple strings ("hello", "key22")
   }
})








local Tab1 = Window:CreateTab("Pets") -- Title, Image
local Tab2 = Window:CreateTab("Farm") -- Title, Image

local Section = Tab1:CreateSection("Spawner")
local LabelPets = Tab1:CreateLabel("Available", nil, Color3.fromRGB(0,255,0), false) -- Title, Icon, Color, IgnoreTheme
UI.PetsConfirm = {}
UI.PetsConfirm.pressed = false
UI.PetsConfirm.Input = 0
UI.PetsConfirm.FlashThread = nil
UI.PetsConfirm.WarnThread = nil
UI.PetsConfirm.Input = nil
UI.PetsConfirm.Lock = false
UI.PetsConfirm.ETA = ""

local PetsInput = Tab1:CreateInput({
   Name = "Pet Generation\n(Dark Earth Butterflies)",
   CurrentValue = "",
   PlaceholderText = "   ",
   Info = "How much Dark Earth Butterflies to spawn",
   RemoveTextAfterFocusLost = true,
   Flag = "PetsInput",
   --Callback = UI.PetsConfirm.ValidateInput(Text)
   Callback = function(Text)
   if UI.PetsConfirm.Lock then
	   return
   end
   UI.PetsConfirm.ValidateInput(Text)
   end
})
local PetsConfirm = Tab1:CreateButton({
   Name = "Start",
   --Callback = UI.PetsConfirm.Handler()
   Callback = function()
   if UI.PetsConfirm.Lock then
	   return
   end
   if not UI.PetsConfirm.Input then
	   UI.PetsConfirm.FlashWarning("Please enter a number!")
   else
	   UI.PetsConfirm.ConfirmWarning()
   end
   end
})


local Section2 = Tab1:CreateSection("Bulk Actions")
UI.BulkDelete = {}

UI.BulkDelete.AwaitingConfirm = false
UI.BulkDelete.ConfirmThread = nil
UI.BulkDelete.CompletedThread = nil

UI.BulkDelete.Button = Tab1:CreateButton({
    Name = "Delete All Pets",
    Callback = function()
        if UI.BulkDelete.AwaitingConfirm then
            UI.BulkDelete.AwaitingConfirm = false
			task.cancel(UI.BulkDelete.ConfirmThread)
			UI.BulkDelete.ConfirmThread = 1
			UI.BulkDelete.Button:Set("Deletion successful!")
			scripts.Pets.BulkDelete()
			UI.BulkDelete.CompletedThread = task.delay(1,function()
				UI.BulkDelete.Button:Set("Delete All Pets")
				UI.BulkDelete.ConfirmThread = nil
			end)
        else
			if not UI.BulkDelete.ConfirmThread then
				UI.BulkDelete.AwaitingConfirm = true
				UI.BulkDelete.Button:Set("Confirm?")
				UI.BulkDelete.ConfirmThread =  task.delay(2, function()
					if UI.BulkDelete.AwaitingConfirm then
						UI.BulkDelete.AwaitingConfirm = false
						UI.BulkDelete.Button:Set("Delete All Pets")
						UI.BulkDelete.ConfirmThread = nil
					end
				end)
			end
        end
    end
})





function UI.PetsConfirm.FlashWarning(inp)
	if not UI.PetsConfirm.FlashThread then
		if UI.PetsConfirm.WarnThread then
			task.cancel(UI.PetsConfirm.WarnThread)
			UI.PetsConfirm.WarnThread = nil
		end
		UI.PetsConfirm.FlashThread = task.spawn(function()
			UI.PetsConfirm.ETAString = ""
			UI.PetsConfirm.Lock = true
			LabelPets:Set(inp, nil, Color3.fromRGB(255,0,0), false) -- Title, Icon, Color, IgnoreTheme
			task.wait(1.5)
			LabelPets:Set("Available", nil, Color3.fromRGB(0,255,0), false) -- Title, Icon, Color, IgnoreTheme
			UI.PetsConfirm.Lock = false
			UI.PetsConfirm.FlashThread = nil
		end)
	end
end

function UI.PetsConfirm.ConfirmWarning()
	if not UI.PetsConfirm.WarnThread then
		UI.PetsConfirm.WarnThread = task.spawn(function()
			LabelPets:Set("Confirm?"..UI.PetsConfirm.ETAString, nil, Color3.fromRGB(255,255,0), false) -- Title, Icon, Color, IgnoreTheme
			task.wait(3)
			LabelPets:Set("Ready      "..UI.PetsConfirm.ETAString, nil, Color3.fromRGB(0,0,255), false) -- Title, Icon, Color, IgnoreTheme
			UI.PetsConfirm.WarnThread = nil
		end)
	else
		task.cancel(UI.PetsConfirm.WarnThread)
		UI.PetsConfirm.WarnThread = nil
		UI.PetsConfirm.Sequence()
	end
end

function UI.PetsConfirm.ValidateInput(Text)
	if Text == "" then
		UI.PetsConfirm.Input = nil
		LabelPets:Set("Available", nil, Color3.fromRGB(0,255,0), false)
		return
	end
	conv = tonumber(Text)
	if conv == nil then
		UI.PetsConfirm.FlashWarning("Must be a number!")
		UI.PetsConfirm.Input = nil
	elseif conv % 1 ~= 0 then
		UI.PetsConfirm.FlashWarning("No decimals!")
		UI.PetsConfirm.Input = nil
	elseif conv < 1 then
		UI.PetsConfirm.FlashWarning("Must be positive!")
		UI.PetsConfirm.Input = nil
	else
		UI.PetsConfirm.Input = Text
		local s = ""
		if tonumber(UI.PetsConfirm.Input)>1 then
			s = "s"
		end
		if UI.PetsConfirm.WarnThread then
			task.cancel(UI.PetsConfirm.WarnThread)
			UI.PetsConfirm.WarnThread = nil
		end
		UI.PetsConfirm.ETAString = " | ETA for "..UI.PetsConfirm.Input.." pet"..s.." is "..UI.ConvertS_to_String(math.floor((UI.PetsConfirm.Input)*4.9+32*(UI.PetsConfirm.Input)*player:GetNetworkPing()+0.5)).."."
		LabelPets:Set("Ready      "..UI.PetsConfirm.ETAString, nil, Color3.fromRGB(0,0,255), false) 
	end
end

function UI.PetsConfirm.GetActualPets(PetName)
	local count = 0
	for i, v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.PetUI.SelectionPanel.ScrollingFrame:GetChildren()) do
		if v.Name == PetName or PetName == nil then
			count = count+1
		end
	end
	return count
end


function UI.PetsConfirm.Sequence()
	UI.PetsConfirm.Lock = true
	local WantedPets = UI.PetsConfirm.Input
	local CurrentPets = UI.PetsConfirm.GetActualPets("Earth ButterflyB")
	local ExpectedPets = UI.PetsConfirm.Input + CurrentPets
	local text
	UI.PetsConfirm.Input = nil
	task.spawn(function()
		scripts.Pets.Generate(WantedPets,0.05)
	end)
	while scripts.Pets.GenerateActive do
		local OldPetsDone = 0
		local PetsDone = UI.PetsConfirm.GetActualPets("Earth ButterflyB") - CurrentPets
		if PetsDone ~= OldPetsLeft then
			LabelPets:Set("Progress: ("..PetsDone.."/"..WantedPets..") pets. "..UI.ConvertS_to_String(math.floor((WantedPets-PetsDone)*4.9+32*(WantedPets-PetsDone)*player:GetNetworkPing()+0.5)).." remaining.", nil, Color3.fromRGB(0,0,255), false)
			OldPetsDone = PetsDone
		end
		task.wait(0.5)
	end
	UI.PetsConfirm.Lock = false
	LabelPets:Set("Available", nil, Color3.fromRGB(0,255,0), false)
end

Rayfield:Notify({
   Title = "Successfully loaded menu content.",
   Content = "Yay!",
   Duration = 6.5,
   --Image = 4483362458,
})
