@tool
extends TileMapLayer

func calculate_aspect_ratio():
	material.set_Shader_param("aspect_ratio", scale.y / scale.x)


func _on_item_rect_changed() -> void:
	calculate_aspect_ratio()
