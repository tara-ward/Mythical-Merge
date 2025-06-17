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
	initialize_audio()

func initialize_audio():
	print("AudioManager: Initializing audio...")
	
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
	var drop_stream = load("res://assets/Drop.ogg")
	var pop_stream = load("res://assets/pop.ogg")
	var merge_stream = load("res://assets/Merge.ogg")
	var music_stream = load("res://assets/BackgroundMusic.ogg")
	
	# Debug stream loading
	print("AudioManager: Stream loading results:")
	print("- Drop.ogg: ", "Loaded" if drop_stream != null else "Failed")
	print("- pop.ogg: ", "Loaded" if pop_stream != null else "Failed")
	print("- Merge.ogg: ", "Loaded" if merge_stream != null else "Failed")
	print("- BackgroundMusic.ogg: ", "Loaded" if music_stream != null else "Failed")
	
	if drop_stream == null or pop_stream == null or merge_stream == null or music_stream == null:
		push_error("AudioManager: Failed to load one or more audio streams")
		return
	
	drop_player.stream = drop_stream
	pop_player.stream = pop_stream
	merge_player.stream = merge_stream
	music_player.stream = music_stream
	
	# Configure music player
	update_volumes()
	start_audio()
	audio_initialized = true

func start_audio():
	print("AudioManager: Starting audio")
	if music_player.stream != null:
		music_player.play()
		music_player.finished.connect(_on_music_finished)
		print("AudioManager: Music started successfully")
	else:
		push_error("AudioManager: Error - music stream is null")

func _on_music_finished():
	print("AudioManager: Music finished, restarting")
	if music_player.stream != null:
		music_player.play()  # Loop the music
		print("AudioManager: Music restarted successfully")
	else:
		push_error("AudioManager: Error - music stream is null")

func play_drop():
	if not is_muted and audio_initialized and drop_player.stream != null:
		print("AudioManager: Playing drop sound")
		drop_player.play()

func play_pop():
	if not is_muted and audio_initialized and pop_player.stream != null:
		print("AudioManager: Playing pop sound")
		pop_player.play()

func play_merge():
	if not is_muted and audio_initialized and merge_player.stream != null:
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