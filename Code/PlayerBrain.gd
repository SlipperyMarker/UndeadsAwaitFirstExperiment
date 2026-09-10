class_name PlayerBrain
extends CharacterBody3D

#-----Variables-----#
#Editor-Accesible Variables (you'll thank yourself later)
@export_category("Dynamic Values")
@export var MaxHealth:float=3
var Health:float
@export_category("Player Movement Properties")
@export var Speed:float=5
@export var Velocity:float=15
@export var JumpVelocity:float=5
@export var DashDistance:float=5
@export var SprintMultiplier:float=1.75
@export var CrouchMultiplier:float=0.75
@export var CrouchHeight:float=0.5
@export var Stamina:float=10
@export_category("Camera Movement Properties")
const RotationSpeed:float=0.001
@export_range(0.1,9.9) var RotationSpeedMultiplier:float=1
@export var RotationVerticalClamp:=deg_to_rad(85)
#temporary attack system properties
@export var AttackRangeSetter :float=50
@export var PlayerDamage:float = 3
var alive:=true
var damaged:=false
@export var DamageShield:float=2
#-----Instanciation-----#
#to use / interactw with the functions from another script, instanciate them here (outside of any functions). also check out static variables.
var _PlayerMovement=PlayerMovement.new()
var _PlayerMovementLook=PlayerMovementLook.new()
@onready var pistol=%pistal
#-----First-Time Call-----#

func _ready() -> void:
	#Setter Functions
	_PlayerMovement.VarHandler(self,%Camera3D,%CollisionShape3DStanding,%CollisionShape3DCrouch,Speed,Velocity,JumpVelocity,DashDistance,SprintMultiplier,CrouchMultiplier,CrouchHeight,Stamina) #physical movement
	_PlayerMovementLook.VarHandler(self,%Camera3D,RotationSpeed,RotationSpeedMultiplier,RotationVerticalClamp) #look around (mouse) movement
	#Goated heads up by Claude AI (told me about Groups without spoiling too much. thank you Claude)
	add_to_group("Player")
	#variable setup
	Health=MaxHealth
	var AttackRange:float=AttackRangeSetter*-1
	%RayCast3D.target_position.z=AttackRange

#-----Per-Frame Call------#

func _process(delta: float) -> void:
	#"Walking" Movement
	if alive:
		_PlayerMovement.InputHandler(delta)
		move_and_slide()
	_PlayerMovement.GravityHandler(delta)
	#relocated "move_and_slide()" to this script after asking deepseek about the movement code and if the class it extends is the best choice for it, deepseek pointed out that the move_and_slide function should be called separately and not within "InputHandler" because it runs before "GravityHandler" which will cause a one frame delay.

func _physics_process(delta: float) -> void:
	#Camera Movement (its a little bit bad, there's a "Rubber band" effect when you drag your mouse too hard / fast and hit the vertical degree limit: it overshoots then corrects its self its kinda annoying.)
	if alive:
		_PlayerMovementLook.MovementHandler()
	#temporary Enemy Attacker Handler
		if Input.is_action_just_pressed("Select"):
			%pistal._ShootingAnimation()
			if %RayCast3D.is_colliding() and (%pistal.Ammo>0 or %pistal.Reloading==false):
				var Collided:Node=%RayCast3D.get_collider()
				if Collided and is_instance_valid(Collided) and Collided.has_method("DamageMe"):
					Collided.DamageMe(PlayerDamage)

func _GetMaxAmmo()->String:
	return str(%pistal.MaxAmmo)
func _GetAmmo()->String:
	return str(%pistal.Ammo)

func DamageMe(EnemyDamage:float)->void:
	if !damaged and alive:
		print("attacked!")
		Health-=EnemyDamage
		damaged=true
		%Sprite2D.self_modulate=100
		await get_tree().create_timer(DamageShield).timeout
		damaged=false
	if Health<=0:
		%Sprite2D.self_modulate.a=255
		remove_from_group("Player")
		%pistal.aiming=false
		%pistal.Ammo=0
		KillMe()
func KillMe()->void:
	alive=false
	Input.mouse_mode=Input.MOUSE_MODE_VISIBLE

func _Healed()->void:
	%Sprite2D.self_modulate=0
#-----Per-Input Call-----#

func _unhandled_input(event: InputEvent) -> void:
	#Automated InputHandlers
	_PlayerMovementLook.MousePointerHandler(event)
	_PlayerMovementLook.InputHandlerMouse(event)
	_PlayerMovement.SprintHandler(event)
	_PlayerMovement.JumpHandler(event)
	_PlayerMovement.HeightHandler(event)
	%pistal._AimDownSights(event,alive)
	%pistal._ReloadAnimation(event,alive)
	if event.is_action_pressed("MoveFast") and %pistal.aiming:
		%pistal.aiming=false
