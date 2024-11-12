extends Node2D

var player_reference: Player = null;
var is_player_present: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func teleport_player(body: Node2D) -> void:
	body.position.y = position.y - 0.001;
	#body.position.x = position.x;
	
func _on_area_2d_body_entered(body:Node2D) -> void:
	call_deferred("teleport_player", body);
	is_player_present = true;
	modulate.a = 0.5;



func _on_area_2d_body_exited(body:Node2D) -> void:
	is_player_present = false;
	modulate.a = 1.0;


