extends Control

func _ready():
	$VBoxContainer/StartButton.pressed.connect(_on_start_button_pressed)
	$VBoxContainer/RulesButton.pressed.connect(_on_rules_button_pressed)
	$VBoxContainer/SettingsButton.pressed.connect(_on_settings_button_pressed)
	$RulesPopup/VBoxContainer/CloseButton.pressed.connect(_on_close_button_pressed)
	$SettingsPopup/VBoxContainer/CloseButton.pressed.connect(_on_settings_close_button_pressed)
	$SettingsPopup/VBoxContainer/MuteButton.pressed.connect(_on_mute_button_pressed)
	
	# Connect volume sliders
	$SettingsPopup/VBoxContainer/MusicVolume/HSlider.value_changed.connect(_on_music_volume_changed)
	$SettingsPopup/VBoxContainer/SFXVolume/HSlider.value_changed.connect(_on_sfx_volume_changed)
	
	# Initialize slider values from AudioManager
	var music_volume = AudioManager.music_volume
	var sfx_volume = AudioManager.sfx_volume
	$SettingsPopup/VBoxContainer/MusicVolume/HSlider.value = music_volume
	$SettingsPopup/VBoxContainer/SFXVolume/HSlider.value = sfx_volume

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/Main.tscn")

func _on_rules_button_pressed():
	var viewport_size = get_viewport_rect().size
	$RulesPopup.position = Vector2(viewport_size.x - 400, viewport_size.y / 2 - 100)
	$RulesPopup.popup()

func _on_close_button_pressed():
	$RulesPopup.hide()

func _on_settings_button_pressed():
	var viewport_size = get_viewport_rect().size
	$SettingsPopup.position = Vector2(viewport_size.x - 400, viewport_size.y / 2 - 150)
	$SettingsPopup.popup()

func _on_settings_close_button_pressed():
	$SettingsPopup.hide()

func _on_mute_button_pressed():
	AudioManager.toggle_mute()
	$SettingsPopup/VBoxContainer/MuteButton.text = "Unmute All" if AudioManager.is_muted else "Mute All"

func _on_music_volume_changed(value: float):
	AudioManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float):
	AudioManager.set_sfx_volume(value) 
