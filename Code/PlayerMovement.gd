class_name PlayerMovement
extends RefCounted

#-----Variables-----#
#Getter Variables (will be sourced from PlayerBrain)
var _Player: CharacterBody3D 
var Gravity: Vector3
var _Speed:float
var _Velocity:float
var _JumpVelocity:float
var _DashDistance:float
var _SprintMultiplier:float
var _CrouchMultiplier:float
var _CrouchHeight:float
var _Stamina:float
var _ColliderStanding:CollisionShape3D
var _ColliderCrouch:CollisionShape3D

#-----Getter Function-----#
#sourced from PlayerBrain
func VarHandler(PNode:CharacterBody3D,ColSta:CollisionShape3D,ColCro:CollisionShape3D,Sp:float,Vl:float,JumpVl:float,Dd:float,Sm:float,Cm:float,Ch:float,S:float)->void:
	_Player=PNode;_ColliderStanding=ColSta;_ColliderCrouch=ColCro;_ColliderCrouch.disabled=true;_Speed=Sp; _Velocity=Vl;_JumpVelocity=JumpVl;_DashDistance=Dd;_SprintMultiplier=Sm;_CrouchMultiplier=Cm;_CrouchHeight=Ch;_Stamina=S

#-----Logic Functions-----#

func InputHandler(Delta: float) -> void:
	#These lines get movement inputs and move the character
	var DirectionInput:=Input.get_vector("MoveLeft","MoveRight","MoveForward","MoveBackward")
	var _Direction:=(_Player.transform.basis*Vector3(DirectionInput.x,0,DirectionInput.y)).normalized()
	
	#This if statement applies movement if buttons are pressed
	if _Direction:
		_Player.velocity.x=_Direction.x*_Speed
		_Player.velocity.z=_Direction.z*_Speed
	#This else statement applies Smoothing. Credits to LesusX.
	else:
		_Player.velocity.x=lerp(_Player.velocity.x,_Direction.x*_Speed,Delta*_Velocity)
		_Player.velocity.z=lerp(_Player.velocity.z,_Direction.z*_Speed,Delta*_Velocity)
	
	#Will call move_and_slide inside the PlayerBrain script.
	#_Player.move_and_slide() #didnt add it first, the character wouldn't move. added it in: problem solved.

func HeightHandler(Standing:bool)->void:
	#i first settled for a single collider solution about crouching (changing the height) but it would fail because of how jolt physics handles collider sizes. switched over to a 2 collider solution.
	#i would only use hide and show methods but it wouldn't work: a little google search revealed to me that hide/show does not affect the collider's functionality and instead toggling the "disabled" option within the collider's properties does.
	if Standing==true:
		_ColliderStanding.hide();_ColliderStanding.disabled=true
		_ColliderCrouch.show();_ColliderCrouch.disabled=false
	else:
		_ColliderStanding.show();_ColliderStanding.disabled=false
		_ColliderCrouch.hide();_ColliderCrouch.disabled=true


func GravityHandler(Delta:float) -> void:
	#The lines check to see if the player is not on the floor, then apply gravity to them if true.
	Gravity=_Player.get_gravity()
	if _Player.is_on_floor()==false:
		_Player.velocity.y+=Gravity.y*Delta
