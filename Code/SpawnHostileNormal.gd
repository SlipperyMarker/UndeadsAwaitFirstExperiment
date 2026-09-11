extends Node3D
var spawnenable:=true
@export var MaxHostileAmount:int=10
var HostileAmount:int
var remainingHostiles:int
func _ready() -> void:
	HostileAmount=MaxHostileAmount
	remainingHostiles=HostileAmount
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if spawnenable and HostileAmount==MaxHostileAmount:
		for i in HostileAmount:
			SpawnZombie()
		remainingHostiles=HostileAmount
		HostileAmount=0
func SpawnZombie()->void:
	var NewEnemy = preload("res://Prefab/Entity/HostileNormal.tscn").instantiate()
	NewEnemy.HostileNormalKilled.connect(_HostileNormalKilled)
	%PathFollow3D.progress_ratio = randf()
	add_child(NewEnemy)  # Now it's in the tree
	NewEnemy.global_position = %PathFollow3D.global_position
func _HostileNormalKilled()->void:
	HostileAmount+=1
	remainingHostiles-=1
	if HostileAmount==MaxHostileAmount:
		MaxHostileAmount*=1.2
		HostileAmount=MaxHostileAmount
		remainingHostiles=HostileAmount
		if %RootPlayer:
			%RootPlayer.Health=%RootPlayer.MaxHealth
			%RootPlayer._Healed()
		print("new wave, Zombie Amount: ",HostileAmount)
	#print("killed one enemy")
