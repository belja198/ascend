extends Area2D
class_name Key

signal key_picked_up;

func _on_body_entered(body:Node2D) -> void:
	print("key on body entered")
	if !(body is Player || body is PlayerFell):	
		return;
	print("key Player present");
	key_picked_up.emit();
	queue_free();
