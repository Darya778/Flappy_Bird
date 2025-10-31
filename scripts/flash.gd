extends ColorRect

func flash(duration := 0.5):
	color.a = 1.0
	var tween = create_tween()
	tween.tween_property(self, "color:a", 0.0, duration)
