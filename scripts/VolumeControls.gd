extends Control

func _ready():
	# Connect signals
	$Panel/VBoxContainer/MusicSlider.value_changed.connect(_on_music_volume_changed)
	$Panel/VBoxContainer/SFXSlider.value_changed.connect(_on_sfx_volume_changed)
	$Panel/VBoxContainer/MuteButton.pressed.connect(_on_mute_pressed)
	
	# Set initial values
	$Panel/VBoxContainer/MusicSlider.value = AudioManager.music_volume
	$Panel/VBoxContainer/SFXSlider.value = AudioManager.sfx_volume
	_update_mute_button_text()

func _on_music_volume_changed(value: float):
	AudioManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float):
	AudioManager.set_sfx_volume(value)

func _on_mute_pressed():
	AudioManager.toggle_mute()
	_update_mute_button_text()

func _update_mute_button_text():
	$Panel/VBoxContainer/MuteButton.text = "Unmute" if AudioManager.is_muted else "Mute" 