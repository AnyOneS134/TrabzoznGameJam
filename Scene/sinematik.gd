extends Node2D


@onready var ses = $AudioStreamPlayer

func _ready() -> void:
	ses.play()
	await ses.finished
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://Scene/deneme.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
