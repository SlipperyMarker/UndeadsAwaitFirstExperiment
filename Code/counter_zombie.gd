extends Control
@onready var root_master: Node3D = $"../../../.."
@onready var label: Label = %Label
var amount:String
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if root_master:
		amount=str(root_master.remainingHostiles)
		label.text="Zombies Remaining "+amount
	pass
