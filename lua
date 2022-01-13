local module = {}
local ts = require(game:GetService("ReplicatedStorage").Tween)

local destroyTime = 6
local destroyTime2 = 5
local db = true

local ingore = {}


local bloodDrops = {}

local function Cast(Origin, Direction)

		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = ingore
		raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		local Hit = workspace:Raycast(Origin, Direction, raycastParams)

		if Hit ~= nil then
			if Hit.Instance:IsA("BasePart") and Hit.Instance.CanCollide == true then
				if Hit.Instance:FindFirstAncestorWhichIsA("Model"):FindFirstChildOfClass("Humanoid")  then print(Hit.Instance.Parent.Name) return end
				return Hit.Instance, Hit.Position, Hit.Normal
			end
		end
	
end



function bloodDrops.addDrops(self)
	self.Segements = self.Segements or 5
		
	local loops = {
		
		Loop = true,
		
	}
	
	self.loop1 = loops.Loop
	
	

		for i = 1, self.Segements do wait()

			local bloodDrop = script:WaitForChild("BloodDrop"):Clone()
			local HRP = self.Target:WaitForChild("HumanoidRootPart")
			self.BloodColor = self.BloodColor or Color3.fromRGB(77, 0, 0)
			bloodDrop.Parent = workspace.Debris
			game.Debris:AddItem(bloodDrop,4)
			bloodDrop.CFrame = HRP.CFrame * CFrame.Angles(math.random(-20,20),math.random(-20,20),math.random(-20,20))
			bloodDrop.Anchored = false
			bloodDrop.CanCollide = false
			bloodDrop.Color = self.BloodColor
			local Velocity = Instance.new("BodyVelocity")
			Velocity.Parent = bloodDrop
			Velocity.Name = "BloodVelocity"
			Velocity.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
			Velocity.Velocity = bloodDrop.CFrame.UpVector * 45
			game.Debris:AddItem(Velocity, .15)

			self.destroy = function()
				spawn(function()

					wait(self.destroyTime or 3)
					if self ~= nil then

						bloodDrop:Destroy()
					else

						warn("Blood Drop is nil now, (Cant destroy)")
					end
				end)
			end



		self.heartBeat = game:GetService("RunService").Heartbeat
		local connection

		connection = game:GetService("RunService").Heartbeat:Connect(function()
	
					self.Unit = self.Unit or .75
			
					local hit, RayPosition, Normal = Cast(bloodDrop.Position, bloodDrop.Velocity.Unit*self.Unit)
					

					if hit then  		
				spawn(function()
					pcall(function()
						self.hit = hit
						self.Size = self.Size or 1
				game.Debris:AddItem(bloodDrop,5)
						local bloodfloorcf = (CFrame.new(RayPosition, RayPosition - Normal)) * CFrame.new(0, 0/2,0) --* CFrame.Angles(math.rad(-90),0,0)
						local bloodfloor = script:WaitForChild("BloodFloor"):Clone()

						bloodfloor.Parent = workspace.Debris
						bloodfloor.CFrame = bloodfloorcf
						bloodfloor.Color = self.BloodColor

						local tween = require( game:GetService("ReplicatedStorage"):WaitForChild("Tween") )

						tween:Create(bloodfloor,1.5,"Cubic",{Size = Vector3.new(4.158, 4.217, .24) * self.Size})
						self.destroybloodfloor = function()
							spawn(function()

								wait(destroyTime2)
								tween:Create(bloodfloor,1.5,"Circular",{Size =Vector3.new(0,0,0)})
								game.Debris:AddItem(bloodfloor,1.5)

							end)

						end
						warn(self and "Blood floor added")
						self.destroybloodfloor()
						wait()

					end)

				end)
					end


			end)


			self.DestroyTime = destroyTime or 6
			self.destroy()
			warn(self.Target.Name.." is bleeding.")

		end

	
	loops.Loop = true
end

function module:BloodDrop(properties)
	pcall(function()
		function self.checkForFolder()

			if properties then

				local folder = game.Workspace:FindFirstChild("BloodDrops") or Instance.new("Folder")
				folder.Parent = game.Workspace
				folder.Name = "BloodDrops"

				self = properties
				return self
			else

				self = "You didnt add properties."
				return self
			end
		end

		if properties.Target ~= nil then

			self = self.checkForFolder()

			if type(self) == "string" then
				warn(self or "You didnt add properties.")

			else
				warn("Starting to add blood.")
				self.Target = properties.Target
				bloodDrops.addDrops(self)
			end
		else

			self = self
			return
		end
	end)

end

module.BleedEffect = function(PartToWeld, BleedTime, Size1, Size2, Size3, Size4, Size5, Size6, BloodType, BloodDirection)
	coroutine.resume(coroutine.create(function()
		-- Variables
		local properties2 = {}
		properties2.BleedTime = BleedTime or 3
		properties2.Size1 = Size1 or 3
		properties2.Size2 = Size2 or 5
		properties2.Size3 = Size1 or 3
		properties2.Size4 = Size2 or 5
		properties2.Size5 = Size5 or 1
		properties2.Size6 = Size6 or 7
		properties2.BloodDirection = BloodDirection or "Front"
		
		properties2.BloodType = BloodType or "Normal"
	
			local BloodEffect2 = script:WaitForChild("BloodEffect2"):Clone()
			BloodEffect2.Parent = workspace.Debris
			if properties2.BloodDirection == "Front" then
				BloodEffect2.CFrame = PartToWeld.CFrame * CFrame.new(0,0,-1.25) * CFrame.Angles(math.rad(90),0,0)
			elseif properties2.BloodDirection == "Left" then
				BloodEffect2.CFrame = PartToWeld.CFrame * CFrame.new(0,.65,0) * CFrame.Angles(0,0,math.rad(-90))
		
			end
		
			BloodEffect2:WaitForChild("Blood1").Enabled = true
			-- change Size
			BloodEffect2:WaitForChild("Blood1").Width0 = properties2.Size5
			BloodEffect2:WaitForChild("Blood1").Width1= properties2.Size6

		-- weld blood to the part
		local Weld = Instance.new("WeldConstraint")
		Weld.Parent = BloodEffect2
		Weld.Part0 = BloodEffect2
		Weld.Part1 = PartToWeld

		-- destroy blood effect

		coroutine.resume(coroutine.create(function()
			wait(properties2.BleedTime)
			BloodEffect2:Destroy()
		end))

		return
	end))
end

return module
