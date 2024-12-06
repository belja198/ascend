extends Area2D

@export var next_level_name: String = "";

func change_level() -> void:
	get_tree().change_scene_to_file(next_level_name);

func _on_body_entered(body: Node2D) -> void:
	#print("player entered door");
	if body is Player:
		#print("player confirmed")
		if next_level_name != "":
			#print("level change")
			call_deferred("change_level");
