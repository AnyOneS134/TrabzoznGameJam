extends Area2D


@onready var canvas_layer = $"../CanvasLayer"
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canvas_layer.kalan_sure += 3
		queue_free()
