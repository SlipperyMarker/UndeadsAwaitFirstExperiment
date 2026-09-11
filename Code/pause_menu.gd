extends Control

@onready var pause_menu: Control = %PauseMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_button_pressed() -> void:
	get_tree().paused=false
	Input.mouse_mode=Input.MOUSE_MODE_CAPTURED
	pause_menu.hide()


func _on_restart_button_pressed() -> void:
	get_tree().paused=false
	get_tree().change_scene_to_file("res://Scene/TestingGround.tscn")


func _on_button_3_pressed() -> void:
	get_tree().quit()
