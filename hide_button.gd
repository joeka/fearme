extends TextureButton

func _pressed():
	get_parent()._on_hide_button( get_pos() )