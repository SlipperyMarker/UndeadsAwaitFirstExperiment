extends Control
@onready var label: Label = $Label
@onready var root_player: PlayerBrain = %RootPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text="Ammo: "+root_player._GetAmmo()+"/"+root_player._GetMaxAmmo()
	pass
