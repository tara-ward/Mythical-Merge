extends Node

# Sound effect players
var drop_player: AudioStreamPlayer
var pop_player: AudioStreamPlayer
var merge_player: AudioStreamPlayer
var music_player: AudioStreamPlayer

# Volume control
var music_volume: float = 0.6  # 60% default
var sfx_volume: float = 1.0    # 100% default
var is_muted: bool = false
var audio_initialized: bool = false

func _ready():
	print("AudioManager: _ready called")
	# Create audio players
	drop_player = AudioStreamPlayer.new()
	pop_player = AudioStreamPlayer.new()
	merge_player = AudioStreamPlayer.new()
	music_player = AudioStreamPlayer.new()
	
	# Add players to the scene
	add_child(drop_player)
	add_child(pop_player)
	add_child(merge_player)
	add_child(music_player)
	
	# Load audio streams
	print("AudioManager: Loading audio streams...")
	var drop_stream = load("res://assets/Drop.mp3")
	var pop_stream = load("res://assets/pop.mp3")
	var merge_stream = load("res://assets/Merge.wav")
	var music_stream = load("res://assets/BackgroundMusic.mp3")
	
	if drop_stream == null:
		print("AudioManager: Failed to load Drop.mp3")
	if pop_stream == null:
		print("AudioManager: Failed to load pop.mp3")
	if merge_stream == null:
		print("AudioManager: Failed to load Merge.wav")
	if music_stream == null:
		print("AudioManager: Failed to load BackgroundMusic.mp3")
	
	drop_player.stream = drop_stream
	pop_player.stream = pop_stream
	merge_player.stream = merge_stream
	music_player.stream = music_stream
	
	# Configure music player
	update_volumes()
	
	# For web builds, we'll start music after user interaction
	if OS.get_name() == "Web":
		print("AudioManager: Running in Web mode")
		# Connect to input event to detect user interaction
		get_tree().root.connect("gui_input", Callable(self, "_on_user_interaction"))
	else:
		print("AudioManager: Running in native mode")
		start_audio()

func _on_user_interaction(_event):
	print("AudioManager: User interaction detected")
	if not audio_initialized:
		audio_initialized = true
		start_audio()
		# Disconnect after first interaction
		get_tree().root.disconnect("gui_input", Callable(self, "_on_user_interaction"))

func start_audio():
	print("AudioManager: Starting audio")
	music_player.play()
	music_player.finished.connect(_on_music_finished)

func _on_music_finished():
	print("AudioManager: Music finished, restarting")
	music_player.play()  # Loop the music

func play_drop():
	if not is_muted and audio_initialized:
		print("AudioManager: Playing drop sound")
		drop_player.play()

func play_pop():
	if not is_muted and audio_initialized:
		print("AudioManager: Playing pop sound")
		pop_player.play()

func play_merge():
	if not is_muted and audio_initialized:
		print("AudioManager: Playing merge sound")
		merge_player.play()

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

func toggle_mute():
	is_muted = !is_muted
	update_volumes()
	print("AudioManager: Mute toggled to ", is_muted)

func update_volumes():
	var music_db = linear_to_db(music_volume) if not is_muted else -80.0
	var sfx_db = linear_to_db(sfx_volume) if not is_muted else -80.0
	
	music_player.volume_db = music_db
	drop_player.volume_db = sfx_db
	pop_player.volume_db = sfx_db
	merge_player.volume_db = sfx_db
	print("AudioManager: Volumes updated - Music: ", music_db, "dB, SFX: ", sfx_db, "dB") 