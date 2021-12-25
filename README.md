# Rjac 
Rotating Joints According to Camera

# What is Rjac?

Rjac (pronounced as "r-jack") is an object-oriented module used to rotate character body parts according to camera direction.

For example:

![Video 1](https://i.gyazo.com/67d32a30da5bdbfc2213c5ca99354a1a.gif)

![Video 2](https://i.gyazo.com/c51e27d0a2b4e8774e2e76e66b1ea0eb.gif)

This mechanic is used in a **lot** of games.

This is very simple to use with simplicity, flexibilty, and customization.

# How to use it?

First off you need to create a folder in `Workspace` and name it as `Rjac`.

As I said it's pretty simple to use but not very small:

```lua
local Player = game.Players.LocalPlayer
local Rjac = require(script.Parent:WaitForChild("Rjac"))

local RjacInfo = {}
RjacInfo.Player = Player
RjacInfo.Character = Player.Character

local Rjac = Rjac:New(RjacInfo)
Rjac.Enabled = true
Rjac:Initiate()

local Configurations = {
	{
		BodyPart = "Head",
		BodyJoint = "Neck",
		MultiplierVector = Vector3.new(0.8, 0.8, 0),
	},
	{
		BodyPart = "RightUpperArm",
		BodyJoint = "RightShoulder",
		MultiplierVector = Vector3.new(0.8, 0, 0),
	},
	{
		BodyPart = "LeftUpperArm",
		BodyJoint = "LeftShoulder",
		MultiplierVector = Vector3.new(0.8, 0, 0),
	},
	{
		BodyPart = "UpperTorso",
		BodyJoint = "Waist",
		MultiplierVector = Vector3.new(0.2, 0.2, 0),
	},
}

for _,v in pairs(Configurations) do
	Rjac:AddBodyJoint(v.BodyPart, v.BodyJoint, v.MultiplierVector)
end

while task.wait() do
	Rjac:UpdateBodyPosition(game.Workspace.CurrentCamera.CFrame)
	Rjac:UpdateCharacter()
end
```

# License 
## Mozilla Public License 2.0
Permissions of this weak copyleft license are conditioned on making available source code of licensed files and modifications of those files under the same license (or in certain cases, one of the GNU licenses). Copyright and license notices must be preserved. Contributors provide an express grant of patent rights. However, a larger work using the licensed work may be distributed under different terms and without source code for files added in the larger work.

Read the full document [here](https://github.com/Giant427/Rjac/blob/main/LICENSE).

# Installation

There are plenty of ways to install:

- [Roblox model](https://www.roblox.com/library/8353530615/Rjac)(recommended)
- [GitHub Repository File](https://github.com/Giant427/Rjac/blob/main/Rjac.lua)
- [GitHub Repository Roblox Place](https://github.com/Giant427/Rjac/blob/main/Rjac.rbxl)
- [GitHub Repository Roblox Model](https://github.com/Giant427/Rjac/blob/main/Rjac.rbxm)