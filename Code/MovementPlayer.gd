class_name PlayerMovement
extends RefCounted

#Variables
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

#Getter Functions
func PlayerHandler(PNode:CharacterBody3D) -> void:
	_Player=PNode
func VarHandler(Sp:float,Vl:float,JumpVl:float,Dd:float,Sm:float,Cm:float,Ch:float,S:float)->void:
	_Speed=Sp; _Velocity=Vl;_JumpVelocity=JumpVl;_DashDistance=Dd;_SprintMultiplier=Sm;_CrouchMultiplier=Cm;_CrouchHeight=Ch;_Stamina=S

#Logic Functions
func InputHandler(Delta: float) -> void:
	var DirectionInput:=Input.get_vector("MoveLeft","MoveRight","MoveForward","MoveBackward")
	var _Direction:=(_Player.transform.basis*Vector3(DirectionInput.x,0,DirectionInput.y)).normalized()
	if _Direction:
		_Player.velocity.x=_Direction.x*_Speed
		_Player.velocity.z=_Direction.z*_Speed
	else:
		_Player.velocity.x=lerp(_Player.velocity.x,_Direction.x*_Speed,Delta*_Velocity)
		_Player.velocity.z=lerp(_Player.velocity.z,_Direction.z*_Speed,Delta*_Velocity)
	_Player.move_and_slide() #didnt add it first, the character wouldn't move. added it in: problem solved.
func GravityHandler(Delta:float) -> void:
	Gravity=_Player.get_gravity()
	if _Player.is_on_floor()==false:
		_Player.velocity.y+=Gravity.y*Delta
	pass
