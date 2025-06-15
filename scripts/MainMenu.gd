extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/RulesButton.pressed.connect(_on_rules_button_pressed)
	$RulesPopup/VBoxContainer/CloseButton.pressed.connect(_on_close_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_rules_button_pressed():
	var viewport_size = get_viewport_rect().size
	$RulesPopup.position = Vector2(viewport_size.x - 400, viewport_size.y / 2 - 100)
	$RulesPopup.popup()

func _on_close_button_pressed():
	$RulesPopup.hide() 
