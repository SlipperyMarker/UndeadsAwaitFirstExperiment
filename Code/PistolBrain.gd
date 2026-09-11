class_name PistolBrain
extends Node3D
@export var RecoilKickAmount := 0.35  # radians, how far it rolls per shot
@export var RecoilRecoverySpeed := 10.0  # higher = snaps back to rest faster
@export var RecoilKickAmountX := 0.05       # max X kick per shot
@export var HipPosition := Vector3(0, 0, 0)        # set to current resting local position
@export var ADSPosition := Vector3(0, -0.05, 0.15) # tweak in editor to line up sights
@export var ADSSpeed := 10.0
@export var ReloadDipAmount := 0.5      # radians, how far it dips
@export var ReloadDipSpeed := 8.0       # how fast it dips down and returns
@export var ReloadHoldTime := 1.0       # how long it stays dipped mid-reload
var reload_current_z := 0.0
var reload_target_z := 0.0
var recoil_current := 0.0
var recoil_current_x := 0.0
var aiming:=false
@export var MaxAmmo:int=20
var Ammo:int
var Reloading:=false
@export var EmptyDipAmount := 0.6
@export var EmptyDipAmountX := 0.1
@export var EmptyDipPositionY := -0.03
@export var EmptyDipSpeed := 6.0
var empty_current_z := 0.0
var empty_current_x := 0.0
var empty_current_pos_y := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Ammo=MaxAmmo
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var empty_target_z := EmptyDipAmount if is_empty() else 0.0
	var empty_target_x := EmptyDipAmountX if is_empty() else 0.0
	var empty_target_pos_y := EmptyDipPositionY if is_empty() else 0.0
	empty_current_z = lerp(empty_current_z, empty_target_z, EmptyDipSpeed * delta)
	empty_current_x = lerp(empty_current_x, empty_target_x, EmptyDipSpeed * delta)
	empty_current_pos_y = lerp(empty_current_pos_y, empty_target_pos_y, EmptyDipSpeed * delta)
	var target := ADSPosition if aiming else HipPosition
	target.y += empty_current_pos_y
	position = position.lerp(target, ADSSpeed * delta)
	rotation.z = recoil_current + reload_current_z + empty_current_z
	rotation.x = recoil_current_x + empty_current_x
	recoil_current = lerp(recoil_current, 0.0, RecoilRecoverySpeed * delta)
	recoil_current_x = lerp(recoil_current_x, 0.0, RecoilRecoverySpeed * delta)
	reload_current_z = lerp(reload_current_z, reload_target_z, ReloadDipSpeed * delta)
	

func _ShootingAnimation()->void:
	if not is_empty() and not Reloading:
		recoil_current += randf_range(RecoilKickAmount*0.5,RecoilKickAmount*2.5)
		recoil_current_x += randf_range(-RecoilKickAmountX*1.25,RecoilKickAmountX*1.25)
		Ammo-=1

func _ReloadAnimation(event:InputEvent,alive:bool)->void:
	if (Ammo<MaxAmmo and event.is_action_pressed("Reload") and alive and !Reloading):
		Reloading=true
		reload_target_z = ReloadDipAmount
		if is_empty():
			await get_tree().create_timer(ReloadHoldTime).timeout
		else:
			await get_tree().create_timer(ReloadHoldTime*0.75).timeout
		reload_target_z = 0.0
		# wait until it's visually back near rest before allowing another reload
		while abs(reload_current_z - reload_target_z) > 0.01:
			await get_tree().process_frame
		Reloading=false
		Ammo=MaxAmmo
func _AimDownSights(event:InputEvent,alive:bool)->void:
	if alive:
		if event.is_action_pressed("ADS") and not aiming and not Reloading:
			aiming=true
		elif event.is_action_pressed("ADS") and aiming and not Reloading:
			aiming=false
		elif event.is_action_pressed("Reload") and aiming:
			aiming=false
func is_empty() -> bool:
	return Ammo <= 0
#this entire script is ai written because i am on a time limit.
