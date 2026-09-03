class_name PlayerBrain
extends CharacterBody3D

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
@export var Camera:Camera3D
@export var PlayerBody:CharacterBody3D
@export var RotationSpeed:float=10
@export var RotationMultiplier:float=5
@export var VerticalClamp:float=85

#to use / interactw with the functions from another script, instantiate them here (outside of any functions). also check out static variables.
var _PlayerMovement=PlayerMovement.new()

func _ready() -> void:
	#Setter Functions
	_PlayerMovement.PlayerHandler(self)
	_PlayerMovement.VarHandler(Speed,Velocity,JumpVelocity,DashDistance,SprintMultiplier,CrouchMultiplier,CrouchHeight,Stamina)

func _physics_process(delta: float) -> void:
	#Automated Functions Per-Frame
	_PlayerMovement.InputHandler(delta)
	_PlayerMovement.GravityHandler(delta)
