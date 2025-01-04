extends Area2D

@export var next_level_name: String = "";
@export var is_locked: bool = false;
var key_ref: Key;

func _ready() -> void:
	key_ref = get_tree().get_first_node_in_group("keyes");
	if key_ref != null:
		is_locked = true;
		modulate = Color(0.1, 0.1, 1.0, 1.0);
		key_ref.key_picked_up.connect(unlock_door);
	else:
		is_locked = false;

func lock_door() -> void:
	modulate = Color(0.1, 0.1, 1.0, 1.0);
	is_locked = true;

func unlock_door() -> void:
	modulate = Color(1.0, 1.0, 1.0, 1.0);
	is_locked = false;

func change_level() -> void:
	get_tree().change_scene_to_file(next_level_name);

func _on_body_entered(body: Node2D) -> void:
	if body is Player || body is PlayerFell:
		#print("player confirmed")
		if next_level_name == "" || is_locked:
			return;
		call_deferred("change_level");
