class_name HostileBrain
extends RigidBody3D

#-----Variables-----#
#Editor-Accesible Variables (you'll thank yourself later)
@export_category("Dynamic Values")
@export var MaxHealth:float=3
@export var Health:float=3
@export var Damage:float=1.5
@export_category("Hostile Movement Properties")
@export var Speed:float=5
@export var Velocity:float=5
@export var DashDistance:float=5
@export var SprintMultiplier:float=1.25
@export var Stamina:float=10
