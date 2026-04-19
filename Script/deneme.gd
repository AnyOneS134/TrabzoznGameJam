extends Node2D

@onready var canvas_layer = $CanvasLayer

func _ready() -> void:
	canvas_layer.kalan_sure = 120


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("space"):
		get_tree().change_scene_to_file("res://Scene/node_2d.tscn")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().reload_current_scene()
