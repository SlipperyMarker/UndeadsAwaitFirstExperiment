extends Node3D
@export var Cooldown :=21.5
var spawnenable:=true
var HostileScript=HostileBrain.new()
@export var player:Node
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	"""if spawnenable:
		for i in 10:
			SpawnZombie()
		spawnenable=false
		await get_tree().create_timer(Cooldown).timeout
		spawnenable=true
"""
func SpawnZombie()->void:
	var NewEnemy = preload("res://Prefab/Entity/HostileNormal.tscn").instantiate()
	%PathFollow3D.progress_ratio = randf()
	add_child(NewEnemy)  # Now it's in the tree
	NewEnemy.global_position = %PathFollow3D.global_position 
