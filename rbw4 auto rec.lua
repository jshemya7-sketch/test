game.Players.LocalPlayer.Character.HumanoidRootPart.CustomPhysicalProperties = PhysicalProperties.new(0.5, 0.300000012, 0.5, 1, 1)    

local bb=game:service'VirtualUser'
game:service'Players'.LocalPlayer.Idled:connect(function()
	bb:CaptureController()bb:ClickButton2(Vector2.new())
end)

local players = game.Players
local replicated = game.ReplicatedStorage
local runservice = game:GetService("RunService")

local event = replicated.GameEvents.ClientAction

local player = players.LocalPlayer
local char = player.Character

local Distance = 7


local goals

repeat wait() until char.MyHoop.Value ~= nil

do
	local myhoop = char.MyHoop.Value
	local hoopName = string.sub(tostring(myhoop),1,5)
	local hoopNumber = string.sub(tostring(myhoop),6,6)

	if hoopNumber == "2" then
		hoopNumber = "1"
	elseif hoopNumber == "1" then
		hoopNumber = "2"
	end

	for i, v in pairs(workspace:GetChildren()) do
		if v.Name == (hoopName .. hoopNumber) then
			for key, value in pairs(v:GetChildren()) do
				if value.Name == "Goal" then
					goals = value
				end
			end
		end
	end

end

player.CharacterAdded:Connect(function(CHAR)
	char = CHAR
end)

local function XZ(V)
	return Vector3.new(V.X, 0, V.Z)
end

local function MoveTo(POS)
	local humanoid = char.Humanoid


	humanoid:MoveTo(POS)
end

local args = {
	[1] = "Jump"
}
local args1 = {
	[1] = "Sprint",
	[2] = true
}

function getnearestnonteammate()
	local target = nil
	local distance = math.huge

	for i,v in next, game.Players:GetPlayers() do
		if v and v.Character and v~=game.Players.LocalPlayer and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") and  v.Character:FindFirstChildOfClass("Humanoid").Health>0 and not v.Character:FindFirstChild("Highlight") then
			local plrdist = game.Players.LocalPlayer:DistanceFromCharacter(v.Character:FindFirstChildOfClass('Humanoid').RootPart.CFrame.p)
			if plrdist < distance then
				target = v
				distance = plrdist
			end
		end
	end

	return target
end

local function Defend()
	local OppositePlayer = getnearestnonteammate().Character
	local MyDistance = (char.HumanoidRootPart.Position - OppositePlayer.HumanoidRootPart.Position).Magnitude
	if math.round(MyDistance) <= math.huge then

		local goal = goals
		local _root = OppositePlayer.HumanoidRootPart

		local path = (XZ(goal.Position) - XZ(_root.Position)).unit
		local pos = _root.Position + (path * Distance)

		local HoopDistance = (OppositePlayer.HumanoidRootPart.Position - goal.Position).Magnitude


		if math.round(MyDistance) <= 5 then
			if (OppositePlayer:FindFirstChild("ShotMeterTiming")) then 
				args = {
					[1] = "Jump"
				}
				args1 = {
					[1] = "Sprint",
					[2] = true
				}


				if (OppositePlayer:FindFirstChild("ShotMeterTiming").Value >= 0) then
					event:FireServer(unpack(args1))
					event:FireServer(unpack(args))
					args1 = {
						[1] = "Sprint",
						[2] = false
					}
					event:FireServer(unpack(args1))
					args1 = {
						[1] = "Sprint",
						[2] = true
					}
				end
			end
		end

		if OppositePlayer:FindFirstChild("ShotMeterTiming") then
			if HoopDistance > 20 and math.round(MyDistance) >= 0 then
				args1 = {
					[1] = "Sprint",
					[2] = true
				}
				event:FireServer(unpack(args1))
				pos = _root.Position + (path)
			elseif HoopDistance < 20 and math.round(MyDistance) >= 0 then
				args1 = {
					[1] = "Sprint",
					[2] = true
				}
				event:FireServer(unpack(args1))
				pos = _root.Position + (path * 2)
			end
		else
			args1 = {
				[1] = "Sprint",
				[2] = false
			}
			event:FireServer(unpack(args1))
			pos = _root.Position + (path * Distance)
		end

		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
		MoveTo(pos)
	end
end

local runloop

runLoop = game:GetService("RunService").RenderStepped:Connect(function()
	if 10240522770 == game.PlaceId then
		Defend()
		event:FireServer("Guard", true)
	else
		runLoop:Disconnect()
	end
end)