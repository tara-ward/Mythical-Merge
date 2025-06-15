extends Control

func _ready() -> void:
	# allow this popup (and its children) to process when the SceneTree is paused
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# make sure the path matches your scene tree
	$Panel/PlayAgainButton.pressed.connect(_on_play_again_pressed)

func _on_play_again_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/Main.tscn")
