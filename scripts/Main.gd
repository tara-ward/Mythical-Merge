extends Node2D
const GAME_OVER_Y := 95 # Set game over line right under NextCreaturePreview
const BUCKET_LEFT := 300 # Adjusted for slimmer bucket
const BUCKET_RIGHT := 852 # Adjusted for slimmer bucket

@onready var creature_container = $CreatureContainer
@onready var game_over_line     = $CanvasLayer/GameOverLine
@onready var popup              = $CanvasLayer/GameOverPopup
@onready var next_creature_preview = $CanvasLayer/NextCreaturePreview
@onready var spawn_cooldown_timer = $SpawnCooldownTimer # New timer for cooldown

var _next_spawn_creature_path: String

func _ready():
	print("Main _ready() called. Input processing enabled.")
	set_process_input(true)
	var w = get_viewport_rect().size.x
	game_over_line.points = [Vector2(0,GAME_OVER_Y), Vector2(w,GAME_OVER_Y)]
	Score.score_changed.connect(_on_score_changed)
	Score.reset()
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	_set_next_creature_for_preview()

	# Set custom mouse cursor
	var custom_cursor = load("res://assets/color-orchid-pointer.png")
	Input.set_custom_mouse_cursor(custom_cursor)

	# Setup spawn cooldown timer
	spawn_cooldown_timer.wait_time = 0.5
	spawn_cooldown_timer.one_shot = true
	spawn_cooldown_timer.timeout.connect(_on_spawn_cooldown_timeout)

func _input(event):
	if event is InputEventMouseButton and event.button_index == 1 and event.is_pressed():
		# Check if click is on volume controls
		var volume_controls = $CanvasLayer/VolumeControls
		var click_pos = event.position
		var controls_rect = Rect2(volume_controls.position, volume_controls.size)
		if controls_rect.has_point(click_pos):
			return  # Don't spawn if clicking on volume controls
			
		if not spawn_cooldown_timer.is_stopped(): # Prevent spawning if timer is active
			return
		# Constrain spawn position to bucket boundaries
		var spawn_x = clamp(event.position.x, BUCKET_LEFT, BUCKET_RIGHT)
		_spawn_creature(spawn_x)
		spawn_cooldown_timer.start()

func _on_spawn_timer_timeout():
	# This timer is now unused for spawning creatures directly
	pass

func _on_spawn_cooldown_timeout():
	pass # Just signals that spawning is re-enabled

func _set_next_creature_for_preview():
	var allowed_paths = [
		"res://scenes/Creature1.tscn",
		"res://scenes/Creature2.tscn",
		"res://scenes/Creature3.tscn",
		"res://scenes/Creature4.tscn"
	]
	_next_spawn_creature_path = allowed_paths[randi() % allowed_paths.size()]
	var creature_scene = load(_next_spawn_creature_path)
	var creature_instance = creature_scene.instantiate()
	if creature_instance is Node:
		next_creature_preview.texture = creature_instance.get_node("Sprite2D").texture
	else:
		print("Error: creature_instance is not a Node. Path: " + _next_spawn_creature_path)
		next_creature_preview.texture = null
	creature_instance.queue_free() # Free the temporary instance
	next_creature_preview.position.x = get_viewport_rect().size.x / 2 # Center the preview horizontally
	next_creature_preview.position.y = 50 # Adjust vertical position

func _spawn_creature(x_position: float):
	var c = load(_next_spawn_creature_path).instantiate()
	c.position = Vector2(x_position, GAME_OVER_Y + 5)  # Spawn just below the game over line
	
	# Add a small random horizontal impulse to encourage stacking
	var impulse_strength = 10.0 # Adjusted impulse strength
	var random_x_impulse = randf_range(-impulse_strength, impulse_strength)
	c.apply_central_impulse(Vector2(random_x_impulse, 0))

	creature_container.add_child(c)
	_set_next_creature_for_preview()
	AudioManager.play_drop()  # Play drop sound effect

func _process(_dt):
	for c in creature_container.get_children():
		if c.global_position.y < GAME_OVER_Y:
			_game_over(); break

func _game_over():
	get_tree().paused = true
	Score.save_highscore()
	popup.show() # Show the custom Control popup

func _on_score_changed(curr,high):
	$CanvasLayer/ScoreLabel.text     = "Score: %d" % curr
	$CanvasLayer/HighScoreLabel.text = "Best:  %d" % high
