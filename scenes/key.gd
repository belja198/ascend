extends Area2D
class_name Key

signal key_picked_up;

func _on_body_entered(body:Node2D) -> void:
	key_picked_up.emit();
	queue_free();
