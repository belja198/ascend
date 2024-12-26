extends Node

var player_ref: Player = null;
var is_player_floating: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("restart_level");


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("restart_level"):
		restart_level();


func restart_level() -> void:
	get_tree().reload_current_scene();
