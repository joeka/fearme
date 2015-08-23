extends Node2D

export(int) var notice_threshold = 400 # max distance you can be noticed
export(float) var light_probability_factor = 0.5
export(int) var notice_gain = 600
export(int) var notice_loss = 3
export(int) var light_threshold = 30
export(float) var light_multiplier = 4

export(float) var fear_multiplier = 0.1
export(float) var light_comfort = 0.5

export(int) var wakeup_threshold = 2

var notice = 0
var fear = 0

var asleep = true

var light = false
var queue_light = false
var queue_light_off = false

func player_hiding():
	return get_parent().get_node("Player").is_hiding()

func turn_on_light( on ):
	get_parent().get_node("Light").set_enabled( on )
	light = on

func _next_turn():
	var dist = get_pos().distance_to(get_parent().get_node("Player").get_pos())
	var new_notice = notice
	
	if dist < notice_threshold and not player_hiding():
		if light:
			new_notice = min( notice + notice_gain * light_multiplier / dist, 100 )
		else:
			new_notice = min( notice + notice_gain / dist, 100 )
	else:
		new_notice = max( notice - notice_loss, 0 )
	
	if notice > 0:
		fear += notice * fear_multiplier
	if light and fear > 0:
		fear = max(0, fear - light_comfort)
	
	if queue_light:
		queue_light = false
		get_node("KidAnimation").play("alarm", false, true)
		turn_on_light(true)
	elif queue_light_off:
		queue_light_off = false
		get_node("KidAnimation").play("alarm", false, true)
		turn_on_light(false)
	elif light and new_notice < light_threshold and randf() > light_probability_factor * new_notice * 0.01:
		get_node("KidAnimation").play("alarm")
		queue_light_off = true
	elif not light and new_notice > light_threshold and randf() < light_probability_factor * new_notice * 0.01:
		get_node("KidAnimation").play("alarm")
		queue_light = true
	
	if asleep and new_notice > wakeup_threshold:
		get_node("KidAnimation").play("wakeup")
		asleep = false
	
	if notice >= 100:
		get_tree().change_scene("res://gameover.scn")
	if fear >= 100:
		get_tree().change_scene("res://won.scn")
	
	print("\n - - - next turn - - - ")
	print("notice: ", new_notice)
	print("fear: ", fear)
	print("distance: ", dist)
	print("gain: ", new_notice - notice)
	if queue_light:
		print("light queued (probability was ", light_probability_factor * new_notice * 0.01, ")")
	print("player hiding: ", player_hiding())
	
	notice = new_notice
	get_node("/root/Game/GUILayer/NoticeProgress").set_val(notice)
	get_node("/root/Game/GUILayer/FearProgress").set_val(fear)
