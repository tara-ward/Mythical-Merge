extends RigidBody2D
@export var scene_path:String

func _ready():
	contact_monitor = true
	max_contacts_reported = 6
	body_entered.connect(_on_body_entered)

func _on_body_entered(other_body:Node2D) -> void:
	if other_body is RigidBody2D and other_body.scene_path == scene_path:
		_try_merge(other_body)

func _integrate_forces(state:PhysicsDirectBodyState2D) -> void:
	# Removed merge logic from here, now handled by signal
	pass

func _try_merge(other:RigidBody2D) -> void:
	if is_queued_for_deletion() or other.is_queued_for_deletion(): return
	queue_free(); other.queue_free()
	var next_path = CreatureDefs.EVOLUTIONS[scene_path]
	if next_path:
		var c = load(next_path).instantiate()
		c.global_position = global_position - Vector2(0, 1)
		get_tree().root.get_node("Main/CreatureContainer").add_child(c)
		Score.add(10)
		AudioManager.play_merge()
	else:
		Score.add(100)
		AudioManager.play_pop()
		# optional PopEffect here 
 
