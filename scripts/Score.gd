extends Node
signal score_changed(current:int, high:int)
var current:int = 0
var high:int    = 0

func _ready():
	var cfg = ConfigFile.new()
	if cfg.load("user://highscore.cfg") == OK:
		high = int(cfg.get_value("scores","high",0))
	emit_signal("score_changed",current,high)

func add(points:int):
	current += points
	if current > high:
		high = current
	emit_signal("score_changed",current,high)

func reset():
	current = 0
	emit_signal("score_changed",current,high)

func save_highscore():
	var cfg = ConfigFile.new()
	cfg.set_value("scores","high",high)
	cfg.save("user://highscore.cfg") 
