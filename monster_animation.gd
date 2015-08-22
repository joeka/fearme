extends AnimatedSprite

var timer = 0
export(float) var frame_time = 0.2

func play():
	set_process(true)

func stop():
	set_process(false)
	timer = 0
	set_frame(0)
	
func _process(delta):
	timer = timer + delta
	
	if(timer > frame_time):
		if(get_frame() == self.get_sprite_frames().get_frame_count()-1):
			set_frame(0)
		else:
			self.set_frame(get_frame() + 1)

		timer = 0