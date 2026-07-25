extends Control

signal unpause

func _on_mainmenu_pressed() -> void:
	Engine.time_scale = 1
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_resume_pressed() -> void:
	emit_signal("unpause")

func _on_quit_pressed() -> void:
	get_tree().quit()
