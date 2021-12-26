# Documentation

## Properties

> [`Player`](https://developer.roblox.com/en-us/api-reference/class/Player) Player

> [`Model`](https://developer.roblox.com/en-us/api-reference/class/Model) Character

> `Boolean` Enabled

## Functions

> `Void` RjacProfile:Initiate() <br> <br>
Basically start the processing of the `Object`.

<br>

> `Void` RjacProfile:UpdateCharacter() <br> <br>
Rotates the body joints **once**, according to the camera direction.

<br>

> `Void` RjacProfile:UpdateBodyPosition([`CFrame`](https://developer.roblox.com/en-us/api-reference/datatype/CFrame) CameraCFrame) <br> <br>
Updates the value of where the character is supposed to look at.

<br>

> `Void` RjacProfile:AddBodyJoint([`String`](https://developer.roblox.com/en-us/articles/String) BodyPart, [`String`](https://developer.roblox.com/en-us/articles/String) BodyJoint, [`Vector3`](https://developer.roblox.com/en-us/api-reference/datatype/Vector3) MultiplierVector) <br> <br>
Adds a body joint which will be affected by the `Object`.

<br>

> `Void` RjacProfile:RemoveBodyJoint([`String`](https://developer.roblox.com/en-us/articles/String) BodyPart, [`String`](https://developer.roblox.com/en-us/articles/String) BodyJoint) <br> <br>
Removes the joint configuration from the loop and resets the offset of the joint.

<br>

> `Void` RjacProfile:UpdateBodyJointOffset([`String`](https://developer.roblox.com/en-us/articles/String) BodyPart, [`String`](https://developer.roblox.com/en-us/articles/String) BodyJoint, [`CFrame`](https://developer.roblox.com/en-us/api-reference/datatype/CFrame) JointOffset) <br> <br>
Updates the joint offset configuration of the given `BodyJoint`. Can be used when the character is being rotated but the body parts still need to face the camera direction.

<br>

> `Void` RjacProfile:UpdateBodyJointMultiplierVector([`String`](https://developer.roblox.com/en-us/articles/String) BodyPart, [`String`](https://developer.roblox.com/en-us/articles/String) BodyJoint, [`Vector3`](https://developer.roblox.com/en-us/api-reference/datatype/Vector3) MultiplierVector) <br> <br>
Updates the multiplier vector of the given `BodyJoint`. Not many use cases for this but just in case...

<br>

> `Void` RjacProfile:Destroy() <br> <br>
Simply removes all the contents of the profile.