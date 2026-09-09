class_name HostileBrain
extends RigidBody3D

#-----Variables-----#
#Editor-Accesible Variables (you'll thank yourself later)
@export_category("Dynamic Values")
@export var MaxHealth:float=7
@export var Health:float=7
@export var Damage:float=1.5
@export_category("Hostile Movement Properties")
@export var Speed:float=5
@export var Velocity:float=5
@export var DashDistance:float=5
@export var SprintMultiplier:float=1.25
@export var Stamina:float=10
@export var rot_speed: float = 6.0
@export var stop_dist: float = 1.5
@onready var Player=%RootPlayer
var ok:=true
#Logics
func _process(delta: float) -> void:
	if %RayCast3D.is_colliding():
		var Collided:Node=%RayCast3D.get_collider()
		if Collided and is_instance_valid(Collided) and Collided.has_method("DamageMe"):
			Collided.DamageMe(Damage)
	if self.position.y<=-5 and is_instance_valid(self):
		queue_free()
		print("free")
func DamageMe(addedDamage:float)->void:
	Health-=addedDamage
	if Health<=0:
		KillMe()
	ok=false
	apply_impulse(basis.y*5, basis.z*0.05)
	await get_tree().create_timer(3.5).timeout
	ok=true
func KillMe()->void:
	self.queue_free()

#Ai-generated code because i am running out of time
func _integrate_forces(s):
	if ok:
		rotation.x=0
		rotation.z=0
		if not Player: return
		var to = Player.global_position - global_position
		var dist = to.length()
		# Rotate toward player
		if dist > 0.001:
			var fwd = -global_transform.basis.z
			var dir = to.normalized()
			if fwd.dot(dir) < 0.9999:
				var axis = fwd.cross(dir).normalized()
				if axis.length() < 0.001: axis = Vector3.UP
				s.angular_velocity = axis * min(fwd.angle_to(dir) / s.step, rot_speed)
			else:
				s.angular_velocity = Vector3.ZERO
		# Move toward player
		s.linear_velocity = s.linear_velocity.lerp(
			Vector3.ZERO if dist <= stop_dist else to.normalized() * Speed,0.15 if dist > stop_dist else 0.1)
