extends Control
func _on_start_button_pressed() -> void:
	pass # Replace with function body.
	get_tree().change_scene_to_file("res://Scene/TestingGround.tscn")
func _on_exit_button_pressed() -> void:
	pass # Replace with function body.
	get_tree().quit()
