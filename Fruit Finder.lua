repeat wait()
until game:IsLoaded()

wait(3)

if game.PlaceId == 4593893037 then
	game:GetService("TeleportService"):Teleport(2753915549, game.Players.LocalPlayer)
	return
end

local fruit = workspace:FindFirstChild("Fruit ")

if fruit then
	print("Fruit Detected")
else
	print("Fruit Not Detected")
	game:GetService("TeleportService"):Teleport(4593893037, game.Players.LocalPlayer)
	return
end

local workspace_connection

local function showText(text, time)
	game.Players.LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("Radar").Text = text
	game.Players.LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("Radar").Visible = true
	task.wait(time)
	game.Players.LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("Radar").Visible = false
end

local function playSound(asset_id, pb_speed)
	local sound = Instance.new("Sound", workspace)
	sound.SoundId = asset_id
	sound.Volume = 1
	sound.PlaybackSpeed = pb_speed
	sound:Play()

	sound.Ended:Connect(function()
		sound:Destroy()
	end)
end

local function createSwitch()
	local settings_button = game.Players.LocalPlayer.PlayerGui.Main.Settings
	if settings_button:FindFirstChild("NotifierSwitch") then
		settings_button.NotifierSwitch:Destroy()
	end

	local switch = settings_button.DmgCounterButton:Clone()
	switch.Notify.Text = "Shows spawned fruits localization"
	switch.TextLabel.Text = "Notifier (OFF)"
	switch.Position = UDim2.new(-1.2, 0, -4.03, 0)
	switch.Size = UDim2.new(5, 0, 0.8, 0)
	switch.Name = "NotifierSwitch"

	switch.Parent = settings_button

	settings_button.Activated:Connect(function()
		if switch.Visible then
			switch.Visible = false
		else
			switch.Visible = true
		end
	end)

	return switch
end

local function enableNotifier(fruit)
	local fruit_name
	fruit_name = "A fruit"

	local fruit_child = fruit:WaitForChild("Handle")

	for _, descendant in ipairs(fruit:GetChildren()) do
		if descendant:IsA("MeshPart") and string.sub(descendant.Name, 1, 7) == "Meshes/" then
			local i, j = string.find(descendant.Name, '_')
			fruit_name = string.sub(descendant.Name, 8, i - 1)

			if string.lower(fruit_name) == "magu" then
				fruit_name = "Magma"
			elseif string.lower(fruit_name) == "smouke" then
				fruit_name = "Smoke"
			elseif string.lower(fruit_name) == "quaketest" then
				fruit_name = "Quake"
			end

			fruit_name = fruit_name:gsub("^%l", string.upper) .. " fruit"

			fruit_name = fruit_name:gsub("%d+", '')
			break
		end
	end
	
	playSound("rbxassetid://3997124966", 4)
	game.Players.LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("Radar").Visible = true
	local fruit_alive = true
	
	local h = Instance.new("Highlight")
	h.FillTransparency = 0.75
	h.FillColor = Color3.fromRGB(255, 0, 0)
	h.OutlineColor =  Color3.fromRGB(255, 255, 255)
	h.OutlineTransparency = 0
	h.Parent = fruit
	
	while fruit_alive and workspace_connection do
		game.Players.LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("Radar").Text = "FRUIT DETECTED: (" .. fruit_name .. ") " .. math.floor((game.Players.LocalPlayer.Character:WaitForChild("UpperTorso").Position - fruit_child.Position).Magnitude * 0.15) .. "m away."

		task.wait(0.2)
		fruit_alive = workspace:FindFirstChild(fruit.Name)
	end

	if not fruit_alive then
		playSound("rbxassetid://4612375233", 1)
		showText("Fruit despawned/collected", 3)		
		wait(10)
		game:GetService("TeleportService"):Teleport(4593893037, game.Players.LocalPlayer)
		return
	end
end

local switch = createSwitch()

local function onSwitchClick()
	if workspace_connection then
		workspace_connection:Disconnect()
		workspace_connection = nil

		switch.TextLabel.Text = "Notifier (OFF)"
	else
		switch.TextLabel.Text = "Notifier (ON)"

		workspace_connection = workspace.ChildAdded:Connect(function(child)
			if child.Name == "Fruit " then
				task.spawn(enableNotifier, child)
			end
		end)

		local fruit = workspace:FindFirstChild("Fruit ")

		if fruit then
			task.spawn(enableNotifier, fruit)

			local screen_gui = Instance.new("ScreenGui")
			screen_gui.DisplayOrder = 999999999
			screen_gui.IgnoreGuiInset = false
			screen_gui.ResetOnSpawn = false
			screen_gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			screen_gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

			local frame = Instance.new("Frame")
			frame.AnchorPoint = Vector2.new(0.9750000238418579, 0.5)
			frame.BackgroundColor3 = Color3.new(1, 1, 1)
			frame.BorderColor3 = Color3.new(0, 0, 0)
			frame.BorderSizePixel = 0
			frame.Position = UDim2.new(0.975000024, 0, 0.5, 0)
			frame.Size = UDim2.new(0.115000002, 0, 0.0549999997, 0)
			frame.Visible = true
			frame.Parent = screen_gui

			local uicorner = Instance.new("UICorner")
			uicorner.Parent = frame

			local uigradient = Instance.new("UIGradient")
			uigradient.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(0.0784314, 0.0784314, 0.0784314)),
				ColorSequenceKeypoint.new(0.5, Color3.new(0.196078, 0.196078, 0.196078)),
				ColorSequenceKeypoint.new(0.919, Color3.new(0.196078, 0.196078, 0.196078)),
				ColorSequenceKeypoint.new(1, Color3.new(0.0784314, 0.0784314, 0.0784314))
			})
			uigradient.Rotation = 45
			uigradient.Parent = frame

			local text_button = Instance.new("TextButton")
			text_button.Font = Enum.Font.SourceSansBold
			text_button.Text = "SKIP"
			text_button.TextColor3 = Color3.new(1, 1, 1)
			text_button.TextSize = 30
			text_button.AnchorPoint = Vector2.new(0.5, 0.5)
			text_button.BackgroundColor3 = Color3.new(1, 1, 1)
			text_button.BackgroundTransparency = 1
			text_button.BorderColor3 = Color3.new(0, 0, 0)
			text_button.BorderSizePixel = 0
			text_button.Position = UDim2.new(0.5, 0, 0.5, 0)
			text_button.Size = UDim2.new(1, 0, 1, 0)
			text_button.Visible = true
			text_button.Parent = frame
			text_button.MouseButton1Click:Connect(function()
				game:GetService("TeleportService"):Teleport(4593893037, game.Players.LocalPlayer)
				return
			end)

			local uistroke = Instance.new("UIStroke")
			uistroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			uistroke.Color = Color3.new(1, 1, 1)
			uistroke.Thickness = 2.5
			uistroke.Parent = frame
		end
	end
end

onSwitchClick()
switch.Activated:Connect(onSwitchClick)
