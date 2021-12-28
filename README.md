New [website](https://giant427.github.io/Rjac/) built using [Moonwave](https://upliftgames.github.io/moonwave/)!!

# <center> Rjac </center>
<center> Rotating Joints According to Camera </center>

# What is Rjac?

Rjac (pronounced as "r-jack") is an object-oriented module used to rotate character body parts according to camera direction.

For example:

![Video 1](upload://1VTYjxHHwCMQzHaxWFfghBaafCZ.gif)

![Video 2](upload://iDVV9eEu6kI4FXl3SO5NsiKWriV.gif)

This mechanic is used in a **lot** of games. 
This is very simple to use with simplicity, flexibilty, and customization.

# How to use it?

As I said it's pretty simple to use but not very small, basic example:

```lua
local Player = game.Players.LocalPlayer
local Rjac = require(game.ReplicatedStorage:WaitForChild("Rjac"))

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

game:GetService("RunService").Heartbeat:Connect(function()
	Rjac:UpdateDirection(game.Workspace.CurrentCamera.CFrame)
	Rjac:UpdateCharacter()
end)
```

***

```lua
{
	BodyPart = "Head",
	BodyJoint = "Neck",
	MultiplierVector = Vector3.new(0.8, 0.8, 0),
},
```
Now let's break this down a bit and see what it means

`BodyPart` i.e `"Head"` is the name of the [`BasePart`](https://developer.roblox.com/en-us/api-reference/class/BasePart) in the `Character`, where I will find a [`Motor6D`](https://developer.roblox.com/en-us/api-reference/class/Motor6D), named the value of `BodyJoint` i.e `"Neck"`.
`MultiplierVector` is the [`Vector3`](https://developer.roblox.com/en-us/api-reference/datatype/Vector3), which determines by what value will the joint be rotated.

There is only one way of ***fully*** understanding how to use this, which is by experimenting a ***lot*** with the module itself.

Taking a look at the [Documentation](https://giant427.github.io/Rjac/api/Rjac) is ***heavily*** encouraged to use the module to its full potential.

# License 
## Mozilla Public License 2.0
Permissions of this weak copyleft license are conditioned on making available source code of licensed files and modifications of those files under the same license (or in certain cases, one of the GNU licenses). Copyright and license notices must be preserved. Contributors provide an express grant of patent rights. However, a larger work using the licensed work may be distributed under different terms and without source code for files added in the larger work.

Read the full document [here](https://github.com/Giant427/Rjac/blob/main/LICENSE).

# Installation

There are plenty of ways to install:

- [Roblox model](https://www.roblox.com/library/8353530615/Rjac) (recommended)
- [GitHub Repository File](https://github.com/Giant427/Rjac/blob/main/src/Rjac.lua)
- [GitHub Repository Roblox Place](https://github.com/Giant427/Rjac/blob/main/Rjac.rbxl)
- [GitHub Repository Roblox Model](https://github.com/Giant427/Rjac/blob/main/Rjac.rbxm)

*** 

Merry Christmas and Happy New Year everyone!!