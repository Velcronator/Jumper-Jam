extends Control

var tween_time = 0.5

func _ready() -> void:
	visible = false
	modulate.a = 0.0

func appear():
	visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0 , tween_time)
	return tween


func  disappear():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0 , tween_time)
	return tween
