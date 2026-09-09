extends Node3D
var spawnenable:=true
@export var MaxHostileAmount:int=10
var HostileAmount:int
func _ready() -> void:
	HostileAmount=MaxHostileAmount
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawnenable and HostileAmount==MaxHostileAmount:
		for i in HostileAmount:
			SpawnZombie()
		HostileAmount=0

func SpawnZombie()->void:
	var NewEnemy = preload("res://Prefab/Entity/HostileNormal.tscn").instantiate()
	NewEnemy.HostileNormalKilled.connect(_HostileNormalKilled)
	%PathFollow3D.progress_ratio = randf()
	add_child(NewEnemy)  # Now it's in the tree
	NewEnemy.global_position = %PathFollow3D.global_position
func _HostileNormalKilled()->void:
	HostileAmount+=1
	print("killed one enemy")
