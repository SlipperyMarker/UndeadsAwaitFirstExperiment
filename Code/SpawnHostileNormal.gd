extends Node3D
var spawnenable:=true
@export var MaxHostileAmount:int=10
var HostileAmount:int
var remainingHostiles:int
var WaveCounter:int=0
func _ready() -> void:
	HostileAmount=MaxHostileAmount
	remainingHostiles=HostileAmount
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not %RootPlayer.alive:
		%Control4.show()
	if Input.is_action_just_pressed("Back") and Input.mouse_mode==Input.MOUSE_MODE_CAPTURED:
		%PauseMenu.show()
		Input.mouse_mode=Input.MOUSE_MODE_CONFINED
		get_tree().paused=true
	if spawnenable and HostileAmount==MaxHostileAmount:
		WaveCounter+=1
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
		if WaveCounter==10:
			MaxHostileAmount=100
		elif WaveCounter<10:
			MaxHostileAmount*=1.2
		HostileAmount=MaxHostileAmount
		remainingHostiles=HostileAmount
		if %RootPlayer:
			%RootPlayer.Health=%RootPlayer.MaxHealth
			%RootPlayer._Healed()
		print("new wave, Zombie Amount: ",HostileAmount)
	#print("killed one enemy")
