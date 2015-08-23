extends KinematicBody2D

var target = null
var timer = 0
export(float) var speed = 1
export(float) var turn_speed = 1
var TURN = 0
var MOVE = 1
var turned = false
var action = -1

var hiding = false 

func _ready():
	rotate( get_angle_to( get_parent().get_node("Kid").get_pos() ) + PI	)

func is_hiding():
	return hiding

func set_hiding( b ):
	hiding = b

func turn_to ( pos ):
	get_node("AnimatedSprite").play()
	action = TURN
	target = pos
	set_process(true)

func go_to( pos ):
	get_node("AnimatedSprite").play()
	action = MOVE
	target = pos
	set_process(true)

func _process(delta):
	if action == MOVE and turned:
		var dir = target - get_pos()
		var d = dir.normalized() * speed * delta
		if d.length() < dir.length() and d.length() > 0:
			move(d)
		else:
			turned = false
			move_to(target)
			get_parent().new_grid()
			target = get_parent().get_node("Kid").get_pos()
			action = TURN
	elif action == TURN or (action == MOVE and not turned):
		var angle = get_angle_to( target )
		if angle > 0:
			angle -= PI
		else:
			angle += PI
		
		var rotation = angle * delta * turn_speed
			
		if abs(rotation) < abs(angle) and abs(rotation) > 0.001:
			rotate( rotation )
		else:
			rotate(angle)
			if action == MOVE:
				turned = true
			else:
				get_node("AnimatedSprite").stop()
				set_process(false)
