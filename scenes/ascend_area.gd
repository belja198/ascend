extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if !(body is Player):
		return;
	
	var player: Player = body as Player;
	player.is_ascended = true;
	player.sprite.modulate = Color(1, 0.62, 0.549);
