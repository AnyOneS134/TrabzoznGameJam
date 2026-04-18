extends StaticBody2D

@onready var sprite = $Sprite2D

@onready var platform_renk = [
	preload("res://Sprite/Engeler/yesil.png"),
	preload("res://Sprite/Engeler/sari.png"),
	preload("res://Sprite/Engeler/kirmizi.png")
]

@export var renk_index = 0


func _ready() -> void:
	sprite.texture = platform_renk[renk_index]



func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		renk_index += 1
		sprite.texture = platform_renk[renk_index]

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if renk_index == 2:
			queue_free()
		
		
		#	queue_free()
		
		
		
		
		
