extends Camera2D

# Kameranın yukarı çıkma hızı (Bunu Inspector panelinden de değiştirebilirsin)
@export var scroll_speed: float 

func _process(delta: float) -> void:
	# DİKKAT: Godot'un 2D dünyasında Y ekseni aşağı doğru BÜYÜR, yukarı doğru KÜÇÜLÜR.
	# Bu yüzden yukarı çıkmak için pozisyondan eksi (-) çıkarıyoruz.
	position.y -= scroll_speed * delta


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		get_tree().reload_current_scene()
