--[[
	Made by: GiantDefender427

	Devforum Post: https://devforum.roblox.com/t/rjac-rotating-joints-according-to-camera/1601251
]]

----------
-- Rjac --
----------

--[=[
    @class Rjac

    This is the main Rjac class
]=]
local Rjac = {}

---------------
-- Variables --
---------------

--[=[
	@prop Player Player
	@within Rjac
	The player/owner of this profile
]=]
Rjac.Player = nil
--[=[
	@prop Character Model
	@within Rjac
	The character of the player/owner of this profile
]=]
Rjac.Character = nil

--[=[
	@prop Configurations table
	@within Rjac
	The configurations for the joints, which will be rotated
]=]
Rjac.Configurations = {}
--[=[
	@prop Direction Vector3
	@within Rjac
	The direction of the camera according to the Character's HumanoidRootPart
]=]
Rjac.Direction = Vector3.new(0, 0, 0)
--[=[
	@prop Enabled boolean
	@within Rjac
	Controls if the parts will rotate per frame
]=]
Rjac.Enabled = false

---------------
-- Functions --
---------------

-- Initiate

--[=[
    Basically start the processing of the Object.
]=]
function Rjac:Initiate()
	self.Character = self.Player.Character

	-- Character added

	self.Player.CharacterAdded:Connect(function(Character)
		self:CharacterAdded(Character)
	end)
end

-- Character added

--[=[
	Rotates the body joints once, according to the camera direction.
]=]

function Rjac:CharacterAdded(Character)
	Character:WaitForChild("Humanoid")
	self.Character = Character

	-- Replace body joint offsets

	for _,v in pairs(self.Configurations) do
		local BodyPart = self.Character:FindFirstChild(v.BodyPart)
		local BodyJoint
		if BodyPart then
			BodyJoint = BodyPart:FindFirstChild(v.BodyJoint)

			if BodyJoint then
				v.JointOffset = BodyJoint.C0
			end
		end
	end
end

-- Update character

--[=[
	Rotates the body joints once, according to the camera direction.
]=]
function Rjac:UpdateCharacter()
	if not self.Enabled then return end

	if not self.Character then
		warn("Character does not exist for Player:", self.Player.Name)
		return
	end

	for _,v in pairs(self.Configurations) do
		-- Drops unnecesarry errors when character is being removed or player is leaving, kind of stupid to add "if"s every now and then, "pcall" is better

		pcall(function()
			local JointValue = CFrame.Angles(math.asin(self.Direction.Y) * v.MultiplierVector.X, -math.asin(self.Direction.X) * v.MultiplierVector.Y, math.asin(self.Direction.Z) * v.MultiplierVector.Z)

			local BodyPart = self.Player.Character:FindFirstChild(v.BodyPart)
			local BodyJoint

			if BodyPart then
				BodyJoint = BodyPart:FindFirstChild(v.BodyJoint)

				if BodyJoint then
					BodyJoint.C0 = v.JointOffset * JointValue
				end
			end
		end)
	end
end

-- Update body position

--[=[
	Updates the direction of where the character is supposed to look at.

	@param CameraCFrame CFrame -- The camera CFrame of the player
]=]
function Rjac:UpdateDirection(CameraCFrame)
	if not self.Character then
		warn("Character does not exist for Player:", self.Player.Name)
		return
	end

	local Value = self.Character.HumanoidRootPart.CFrame:toObjectSpace(CameraCFrame).LookVector

	if Value.Y < -0.965 then
		Value = Vector3.new(Value.X, -0.965, Value.Z)
	end

	self.Direction = Value
end

-- Add/Remove body joint

do
	-- Add body joint

	--[=[
		Adds a body joint which will be affected by the Object.

		@param BodyPart string -- The name of the part which will be affected
		@param BodyJoint string -- The name of the joint which will be rotated
		@param MultiplierVector Vector3 -- The value which affects the rotations
	]=]
	function Rjac:AddBodyJoint(BodyPart, BodyJoint, MultiplierVector)
		for _,v in pairs(self.Configurations) do
			if v.BodyPart == BodyPart and v.BodyJoint == BodyJoint then
				return
			end
		end

		-- Create configuration

		local Configuration = {
			BodyPart = BodyPart,
			BodyJoint = BodyJoint,
			JointOffset = CFrame.new(),
			MultiplierVector = MultiplierVector,
		}

		-- Insert Configuration

		table.insert(self.Configurations, Configuration)

		-- Set joint offset

		if self.Character then
			local CharacterBodyPart = self.Character:FindFirstChild(Configuration.BodyPart)
			local CharacterBodyJoint
			if CharacterBodyPart then
				CharacterBodyJoint = CharacterBodyPart:FindFirstChild(Configuration.BodyJoint)

				if CharacterBodyJoint then
					self:UpdateBodyJointOffset(Configuration.BodyPart, Configuration.BodyJoint, CharacterBodyJoint.C0)
				end
			end
		end
	end

	-- Remove body joint

	--[=[
		Removes a body joint which will be affected by the Object.

		@param BodyPart string -- The name of the part which will be affected
		@param BodyJoint string -- The name of the joint which will be rotated
	]=]
	function Rjac:RemoveBodyJoint(BodyPart, BodyJoint)
		-- Remove and store configuration

		local Configuration

		for i,v in pairs(self.Configurations) do
			if v.BodyPart == BodyPart and v.BodyJoint == BodyJoint then
				Configuration = v
				table.remove(self.Configurations, i)
				break
			end
		end

		-- Reset joint offset in character

		if self.Character then
			local CharacterBodyPart = self.Character:FindFirstChild(Configuration.BodyPart)
			local CharacterBodyJoint
			if CharacterBodyPart then
				CharacterBodyJoint = CharacterBodyPart:FindFirstChild(Configuration.BodyJoint)

				if CharacterBodyJoint then
					CharacterBodyJoint.C0 = Configuration.JointOffset
				end
			end
		end
	end
end

-- Body joint properties

do
	-- Update body joint offset

	--[=[
		Updates the joint offset configuration of the given BodyJoint. Can be used when the character is being rotated but the body parts still need to face the camera direction.

		@param BodyPart string -- The name of the part which will be affected
		@param BodyJoint string -- The name of the joint which will be rotated
		@param JointOffset CFrame -- The offset by which the joint will be rotated
	]=]
	function Rjac:UpdateBodyJointOffset(BodyPart, BodyJoint, JointOffset)
		for _,v in pairs(self.Configurations) do
			if v.BodyPart == BodyPart and v.BodyJoint == BodyJoint then
				v.JointOffset = JointOffset
				break
			end
		end
	end

	-- Update body joint multiplier vector

	--[=[
		Adds a body joint which will be affected by the Object.

		@param BodyPart string -- The name of the part which will be affected
		@param BodyJoint string -- The name of the joint which will be rotated
		@param MultiplierVector Vector3 -- The value which affects the rotations
	]=]
	function Rjac:UpdateBodyJointMultiplierVector(BodyPart, BodyJoint, MultiplierVector)
		for _,v in pairs(self.Configurations) do
			if v.BodyPart == BodyPart and v.BodyJoint == BodyJoint then
				v.MultiplierVector = MultiplierVector
				break
			end
		end
	end
end

-- Destroy

--[=[
	Destroy the profile
]=]
function Rjac:Destroy()
	self.Enabled = false

	for i,v in pairs(self.Configurations) do
		if self.Character then
			local CharacterBodyPart = self.Character:FindFirstChild(v.BodyPart)
			local CharacterBodyJoint
			if CharacterBodyPart then
				CharacterBodyJoint = CharacterBodyPart:FindFirstChild(v.BodyJoint)

				if CharacterBodyJoint then
					CharacterBodyJoint.C0 = v.JointOffset
				end
			end
		end
	end

	for i,v in ipairs(self) do
		table.remove(self, i)
	end
end

-----------------
-- Rjac module --
-----------------

--[=[
    @class RjacModule

    This is the module which build the RjacProfile for the player
]=]
local RjacModule = {}

-----------------
-- Constructor --
-----------------

--[=[
	Create a new RjacProfile

	@param ProfileInfo table -- The data which will be overwritten while returning the class
	@return RjacProfile table -- Returns the RjacProfile which has been fully creating according to the provided ProfileInfo
]=]
function RjacModule:New(ProfileInfo)
	ProfileInfo = ProfileInfo or {}
	setmetatable(ProfileInfo, Rjac)
	Rjac.__index = Rjac
	return ProfileInfo
end

return RjacModule