extends TextureButton

func _pressed():
	get_parent()._on_move_button( get_pos() )