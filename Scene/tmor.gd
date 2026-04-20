extends Area2D
@onready var sprite = $Sprite2D
@onready var ses =$AudioStreamPlayer
@onready var canvas_layer = $"../CanvasLayer"
func _ready() -> void:
	pass 



func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		canvas_layer.tmor_index += 1
		
		ses.play()
		await ses.finished
		queue_free()
