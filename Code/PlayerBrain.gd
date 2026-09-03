class_name PlayerBrain
extends CharacterBody3D

#-----Variables-----#
#Editor-Accesible Variables (you'll thank yourself later)
@export_category("Dynamic Values")
@export var MaxHealth:float=3
@export var Health:float=3
@export_category("Player Movement Properties")
@export var Speed:float=5
@export var Velocity:float=5
@export var JumpVelocity:float=5
@export var DashDistance:float=5
@export var SprintMultiplier:float=1.25
@export var CrouchMultiplier:float=0.75
@export var CrouchHeight:float=0.5
@export var Stamina:float=10
@export_category("Camera Movement Properties")
@export var RotationSpeed:float=10
@export var RotationSpeedMultiplier:float=5
@export_range(0,110,0.5) var RotationVerticalClamp:float=85

#-----Instanciation-----#
#to use / interactw with the functions from another script, instanciate them here (outside of any functions). also check out static variables.
var _PlayerMovement=PlayerMovement.new()
var _PlayerMovementLook=PlayerMovementLook.new()

#-----First-Time Call-----#

func _ready() -> void:
	#Setter Functions
	_PlayerMovement.VarHandler(self,Speed,Velocity,JumpVelocity,DashDistance,SprintMultiplier,CrouchMultiplier,CrouchHeight,Stamina)
	_PlayerMovementLook.VarHandler(self,%Camera3D,RotationSpeed,RotationSpeedMultiplier,RotationVerticalClamp)

#-----Per-Frame Call------#

func _physics_process(delta: float) -> void:
	#"Walking" Movement
	_PlayerMovement.InputHandler(delta)
	_PlayerMovement.GravityHandler(delta)
	#relocated "move_and_slide()" to this script after asking deepseek about the movement code and if the class it extends is the best choice for it, deepseek pointed out that the move_and_slide function should be called separately and not within "InputHandler" because it runs before "GravityHandler" which will cause a one frame delay.
	move_and_slide()
