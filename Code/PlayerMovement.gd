class_name PlayerMovement
extends RefCounted

#-----Variables-----#
#Getter Variables (will be sourced from PlayerBrain)
var _Player: CharacterBody3D 
var _Camera: Camera3D
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
#Normal
var Sprinting:=false
var Crouching:=false
var Standing:=true

#-----Getter Function-----#
#sourced from PlayerBrain
func VarHandler(PNode:CharacterBody3D,Cam:Camera3D,ColSta:CollisionShape3D,ColCro:CollisionShape3D,Sp:float,Vl:float,JumpVl:float,Dd:float,Sm:float,Cm:float,Ch:float,S:float)->void:
	_Player=PNode;_Camera=Cam;_ColliderStanding=ColSta;_ColliderCrouch=ColCro;_ColliderCrouch.disabled=true;_Speed=Sp; _Velocity=Vl;_JumpVelocity=JumpVl;_DashDistance=Dd;_SprintMultiplier=Sm;_CrouchMultiplier=Cm;_CrouchHeight=Ch;_Stamina=S

#-----Logic Functions-----#

func InputHandler(Delta: float) -> void:
	#These lines get movement inputs and move the character
	var DirectionInput:=Input.get_vector("MoveLeft","MoveRight","MoveForward","MoveBackward")
	var _Direction:=(_Player.transform.basis*Vector3(DirectionInput.x,0,DirectionInput.y)).normalized()
	#This if statement applies movement if buttons are pressed
	if _Direction:
		_Player.velocity.x=_Direction.x*_Speed
		_Player.velocity.z=_Direction.z*_Speed
		#Added sprinting and and crouching speed multipliers
		if Sprinting==true and !Crouching:
			_Player.velocity.x=_Direction.x*(_Speed*_SprintMultiplier)
			_Player.velocity.z=_Direction.z*(_Speed*_SprintMultiplier)
		elif Crouching==true:
			_Player.velocity.x=_Direction.x*(_Speed*_CrouchMultiplier)
			_Player.velocity.z=_Direction.z*(_Speed*_CrouchMultiplier)
	#This else statement applies Smoothing. Credits to LesusX.
	else:
		_Player.velocity.x=lerp(_Player.velocity.x,_Direction.x*_Speed,Delta*_Velocity)
		_Player.velocity.z=lerp(_Player.velocity.z,_Direction.z*_Speed,Delta*_Velocity)
	#Will call move_and_slide inside the PlayerBrain script.
	#_Player.move_and_slide() #didnt add it first, the character wouldn't move. added it in: problem solved.

func GravityHandler(Delta:float) -> void:
	#The lines check to see if the player is not on the floor, then apply gravity to them if true.
	Gravity=_Player.get_gravity()
	if _Player.is_on_floor()==false:
		_Player.velocity.y+=Gravity.y*Delta

func JumpHandler(event:InputEvent)->void:
	if event.is_action_pressed("Jump") and _Player.is_on_floor():
		_Player.velocity.y=_JumpVelocity

func SprintHandler(event:InputEvent)->void:
	if event.is_action_pressed("MoveFast"):
		Sprinting=true
	if event.is_action_released("MoveFast"):
		Sprinting=false

func HeightHandler(event:InputEvent)->void:
	#note: arguments given to classes/funcs are not for beauty, use them bro (the crouching system was fucked up and unreliable because i would forget to use event. instead of Input.)
	if event.is_action_pressed("Crouch"):
		if Standing==true:
			#added a variable to use if needed (used in speed multiplier)
			Standing=!Standing
			Crouching=!Crouching
			_ColliderStanding.hide();_ColliderStanding.disabled=true
			_ColliderCrouch.show();_ColliderCrouch.disabled=false
			_Camera.position.y=0.2
		else:
			Standing=!Standing
			Crouching=!Crouching
			_ColliderStanding.show();_ColliderStanding.disabled=false
			_ColliderCrouch.hide();_ColliderCrouch.disabled=true
			_Camera.position.y=0.7
