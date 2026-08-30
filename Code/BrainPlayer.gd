extends Node3D
@export_category("Player Movement Properties")
@export var Velocity:float=5
@export var SprintMultiplier:float=1.25
@export var CrouchMultiplier:float=0.75
@export var CrouchHeight:float=0.5
@export var HealthPoints:float=3
@export var Stamina:float=10
@export var DashDistance:float=5
@export_category("Camera Movement Properties")
@export var Camera:Camera3D
@export var PlayerBody:PhysicsBody3D
@export var RotationSpeed:float=10
@export var RotationMultiplier:float=5
@export var VerticalClamp:float=85
