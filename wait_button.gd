extends TextureButton

func _pressed():
	get_parent()._on_wait_button()