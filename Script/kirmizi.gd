extends StaticBody2D

@onready var sprite = $Sprite2D

@onready var platform_renk = [
	{"kirmizi" : preload("res://Sprite/icon.svg")},
	{"sari" : preload("res://Sprite/icon.svg")},
	{"yesil" : preload("res://Sprite/icon.svg")}
]

var renk_index = 0


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
		
		
		
		
		
