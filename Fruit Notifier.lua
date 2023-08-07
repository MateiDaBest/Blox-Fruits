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

local function createLed()
	local twitter_button = game.Players.LocalPlayer.PlayerGui.Main.Code
	if twitter_button:FindFirstChild("NotifierLed") then
		twitter_button.NotifierLed:Destroy()
	end

	local led = Instance.new("Frame")
	led.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	led.BackgroundTransparency = 0.3
	led.Position = UDim2.new(1.3, 0, 0.35, 0)
	led.Size = UDim2.new(0, 8, 0, 8)
	led.Name = "NotifierLed"
	led.Parent = twitter_button

	local border = Instance.new("UICorner", led)
	border.CornerRadius = UDim.new(1)

	twitter_button.Activated:Connect(function()
		if led.Visible then
			led.Visible = false
		else
			led.Visible = true
		end
	end)

	return led
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

	while fruit_alive and workspace_connection do
		game.Players.LocalPlayer.PlayerGui:WaitForChild("Main"):WaitForChild("Radar").Text = fruit_name .. " found at: " .. math.floor((game.Players.LocalPlayer.Character:WaitForChild("UpperTorso").Position - fruit_child.Position).Magnitude * 0.15) .. "m away"

		task.wait(0.2)
		fruit_alive = workspace:FindFirstChild(fruit.Name)
	end

	if not fruit_alive then
		playSound("rbxassetid://4612375233", 1)
		showText("Fruit despawned/collected", 3)
	end
end

local led = createLed()
local switch = createSwitch()

local function onSwitchClick()
	if workspace_connection then
		workspace_connection:Disconnect()
		workspace_connection = nil
		led.BackgroundColor3 = Color3.fromRGB(255, 0, 0)

		switch.TextLabel.Text = "Notifier (OFF)"
		showText("Notifier disabled successfully", 2)
	else
		led.BackgroundColor3 = Color3.fromRGB(0, 255, 0)

		switch.TextLabel.Text = "Notifier (ON)"
		showText("Notifier enabled successfully", 2)

		workspace_connection = workspace.ChildAdded:Connect(function(child)
			if child.Name == "Fruit " then
				task.spawn(enableNotifier, child)
			end
		end)

		local fruit = workspace:FindFirstChild("Fruit ")

		if fruit then
			task.spawn(enableNotifier, fruit)
		end
	end
end

onSwitchClick()
switch.Activated:Connect(onSwitchClick)
