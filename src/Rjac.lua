--[[
	Made by: GiantDefender427

	Devforum Post: https://devforum.roblox.com/t/rjac-rotating-joints-according-to-camera/1601251
]]

--[=[
	@class RjacProfile

	RjacProfile is an object used to rotate the character body parts according to camera direction.
]=]
local RjacProfile = {}

-- Properties

--[=[
	@prop Character Model
	@within RjacProfile
	A Model controlled by the Player that contains a Humanoid, body parts, scripts and other objects.
]=]
RjacProfile.Character = nil

--[=[
	@prop Configurations table
	@within RjacProfile
	Configurations for rotating, joint offsets, multipliers.
]=]
RjacProfile.Configurations = {}

--[=[
	@prop Enabled bool
	@within RjacProfile
	Determines whether body parts will be rotated.
]=]
RjacProfile.Enabled = false

--[=[
	@prop Player Player
	@within RjacProfile
	Player/owner of the RjacProfile.
]=]
RjacProfile.Player = nil

--[=[
	@prop TiltDirection Vector3
	@within RjacProfile
	Angle according to which the body parts are to be rotated.
]=]
RjacProfile.TiltDirection = Vector3.new(0, 0, 0)

--[=[
	Add body joint to the list of joints which are to be rotated.

	@param BodyPart string -- Name of the body part.
	@param BodyJoint string -- Name of the body joint.
	@param MultiplierVector Vector3 -- Multiplier by which the joint will be multiplied in rotations.
]=]
function RjacProfile:AddBodyJoint(BodyPart, BodyJoint, MultiplierVector)
	for _,v in pairs(self.Configurations) do
		if v.BodyPart == BodyPart and v.BodyJoint == BodyJoint then
			return
		end
	end
	local Configuration = {
		BodyPart = BodyPart,
		BodyJoint = BodyJoint,
		JointOffset = CFrame.new(),
		MultiplierVector = MultiplierVector,
	}
	table.insert(self.Configurations, Configuration)
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

--[=[
	Destroy the object completely.
]=]
function RjacProfile:Destroy()
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

--[=[
	Starter function to assemble the whole profile for functionality
]=]
function RjacProfile:Initiate()
	self.Character = self.Player.Character
	self.Player.CharacterAdded:Connect(function(Character)
		self:onCharacterAdded(Character)
	end)
end

--[=[
	Function ran when a new character is added for the player

	@param Character Model -- A Model controlled by the Player that contains a Humanoid, body parts, scripts and other objects.
]=]
function RjacProfile:onCharacterAdded(Character)
	-- Wait till the character appearance has fully loaded for proper joint offsets
	Character:WaitForChild("Humanoid")
	self.Character = Character
	self:ResetJointOffsets()
end

--[=[
	Remove body joint from the list of joints which are to be rotated.

	@param BodyPart string -- Name of the body part.
	@param BodyJoint string -- Name of the body joint.
]=]
function RjacProfile:RemoveBodyJoint(BodyPart, BodyJoint)
	local Configuration
	for i,v in pairs(self.Configurations) do
		if v.BodyPart == BodyPart and v.BodyJoint == BodyJoint then
			Configuration = v
			table.remove(self.Configurations, i)
			break
		end
	end
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

--[=[
	Reset joint offset configurations.
]=]
function RjacProfile:ResetJointOffsets()
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

--[=[
	Update body multiplier vector configuration.
	
	@param BodyPart string -- Name of the body part.
	@param BodyJoint string -- Name of the body joint.
	@param MultiplierVector Vector3 -- Multiplier by which the joint will be multiplied in rotations.
]=]
function RjacProfile:UpdateBodyJointMultiplierVector(BodyPart, BodyJoint, MultiplierVector)
	for _,v in pairs(self.Configurations) do
		if v.BodyPart == BodyPart and v.BodyJoint == BodyJoint then
			v.MultiplierVector = MultiplierVector
			break
		end
	end
end

--[=[
	Update body joint offset configuration.

	@param BodyPart string -- Name of the body part.
	@param BodyJoint string -- Name of the body joint.
	@param JointOffset CFrame -- Offset by which the joint will be rotated.
]=]
function RjacProfile:UpdateBodyJointOffset(BodyPart, BodyJoint, JointOffset)
	for _,v in pairs(self.Configurations) do
		if v.BodyPart == BodyPart and v.BodyJoint == BodyJoint then
			v.JointOffset = JointOffset
			break
		end
	end
end

--[=[
	Rotate the body joints of the character once.
]=]
function RjacProfile:UpdateCharacter()
	if not self.Enabled then return end
	if not self.Character then
		warn("Character does not exist for Player:", self.Player.Name)
		return
	end
	for _,v in pairs(self.Configurations) do
		-- Drops unnecesarry errors when character is being removed or player is leaving, kind of stupid to add "if"s every now and then, "pcall" is better
		pcall(function()
			local JointValue = CFrame.Angles(math.asin(self.TiltDirection.Y) * v.MultiplierVector.X, -math.asin(self.TiltDirection.X) * v.MultiplierVector.Y, math.asin(self.TiltDirection.Z) * v.MultiplierVector.Z)
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

--[=[
	Update tilt direction which affects the rotation of body parts.

	@param CameraCFrame CFrame -- CFrame of the Player camera.
]=]
function RjacProfile:UpdateTiltDirection(CameraCFrame)
	if not self.Character then
		warn("Character does not exist for Player:", self.Player.Name)
		return
	end
	local TiltDirection = self.Character.HumanoidRootPart.CFrame:toObjectSpace(CameraCFrame).LookVector
	-- If TiltDirection.Y is less than -0.965, character shows weird behaviour
	if TiltDirection.Y < -0.965 then
		TiltDirection = Vector3.new(TiltDirection.X, -0.965, TiltDirection.Z)
	end
	self.TiltDirection = TiltDirection
end

--[=[
	@class RjacModule

	Used as a constructor for RjacProfile
]=]
local RjacModule = {}
--[=[
	Constructor for RjacProfile
	
	@param ProfileInfo table -- The data which will be overwrite the default properties of the class.
	@return RjacProfile -- Returns the RjacProfile which has been created according to the provided ProfileInfo
]=]
function RjacModule:New(ProfileInfo)
	ProfileInfo = ProfileInfo or {}
	setmetatable(ProfileInfo, RjacProfile)
	RjacProfile.__index = RjacProfile
	return ProfileInfo
end

return RjacModule