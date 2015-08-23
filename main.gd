extends Node2D
var move_button
var hide_button

func _init():
	move_button = preload("res://assets/move_button.scn")
	hide_button = preload("res://assets/hide_button.scn")

func _ready():
	new_grid()
	set_process_input(true)

func _next_turn():
	get_tree().call_group(0,"actors","_next_turn")

func new_grid():
	_next_turn()
	var current_grid = pos_to_grid( get_node("Player").get_pos() )
	for x in range(current_grid.x - 1, current_grid.x + 2):
		for y in range(current_grid.y -1, current_grid.y +2):
			var grid = Vector2(x, y)
			if reachable(grid) and grid != current_grid:
				var cell = get_node("Objects").get_cell(x, y)
				if cell == -1:
					var mvbtn = move_button.instance()
					add_child(mvbtn)
					mvbtn.set_global_pos(grid_to_pos(grid) - Vector2(32,32))
				else: # TODO check if monster can hide here
					print( "adding hide button")
					var hdbtn = hide_button.instance()
					add_child(hdbtn)
					hdbtn.set_global_pos(grid_to_pos(grid) - Vector2(32,32))

func disable_buttons():
	var buttons = get_tree().get_nodes_in_group("Buttons")
	for btn in buttons:
		btn.queue_free()

func _on_move_button(pos):
	disable_buttons()
	get_node("Player").go_to(pos + Vector2(32,32))
	get_node("Player").set_hiding(false)

func _on_hide_button(pos):
	_on_move_button(pos)
	get_node("Player").set_hiding(true)

func pos_to_grid( pos ):
	var x = floor(pos.x / 64)
	var y = floor(pos.y / 64)
	return Vector2(x, y)

func grid_to_pos( grid ):
	return Vector2( grid.x * 64 + 32, grid.y * 64 + 32)

func reachable( grid ):
	var current_grid = pos_to_grid(get_node("Player").get_pos())
	if grid.x < 0 or grid.x > 5 or grid.y < 1 or grid.y > 10:
		return false
	elif abs(grid.x - current_grid.x) > 1 or abs(grid.y - current_grid.y) > 1:
		return false
	else:
		return true

func _input(event):
	if event.is_action("screenshot") and event.is_pressed():
		get_viewport().queue_screen_capture()
		yield(get_tree(), "idle_frame")
		yield(get_tree(), "idle_frame")
		var filename = "screenshot" + str(OS.get_unix_time()) + ".png"
		print( "Screenshot saved: " + filename )
		get_viewport().get_screen_capture().save_png("user://" + filename)
