extends AnimatedSprite

var timer = 0
export(float) var frame_time = 0.2

var animations = {
	"wakeup": [0, 5],
	"alarm": [5, 13],
	"alarm_loop": [10, 13]
}
var current = null
var loop = false
var rewind = false

func play( animation, loop=false, rewind=false ):
	current = animation
	self.loop = loop
	self.rewind = rewind
	if rewind:
		set_frame(animations[animation][1])
	else:
		set_frame(animations[animation][0])
	set_process(true)

func stop():
	set_process(false)
	timer = 0
	if current:
		set_frame(animations[current][1])
	
func _process(delta):
	timer = timer + delta
	
	if(timer > frame_time):
		if not rewind and get_frame() == animations[current][1]:
			if loop:
				set_frame(animations[current][0])
			elif current == "alarm":
				play("alarm_loop", true)
			else:
				set_process(false)
		elif rewind and get_frame() == animations[current][0]:
			if loop:
				set_frame(animations[current][1])
			else:
				set_process(false)
		elif rewind:
			self.set_frame(get_frame() - 1)
		else:
			self.set_frame(get_frame() + 1)

		timer = 0