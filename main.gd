extends Node2D
var move_button

func _init():
	move_button = preload("res://assets/move_button.scn")

func _ready():
	set_process(true)
	new_grid()

func new_grid():
	var current_grid = pos_to_grid( get_node("Player").get_pos() )
	for x in range(current_grid.x - 1, current_grid.x + 2):
		for y in range(current_grid.y -1, current_grid.y +2):
			var grid = Vector2(x, y)
			if reachable(grid) and grid != current_grid:
				var mvbtn = move_button.instance()
				add_child(mvbtn)
				mvbtn.set_global_pos(grid_to_pos(grid) - Vector2(32,32))
				mvbtn.connect("pressed", self, "_on_move_button")

func disable_buttons():
	var buttons = get_tree().get_nodes_in_group("Buttons")
	for btn in buttons:
		btn.queue_free()

func _on_move_button(pos):
	disable_buttons()
	get_node("Player").go_to(pos + Vector2(32,32))

func pos_to_grid( pos ):
	var x = floor(pos.x / 64)
	var y = floor(pos.y / 64)
	return Vector2(x, y)

func grid_to_pos( grid ):
	return Vector2( grid.x * 64 + 32, grid.y * 64 + 32)

func reachable( grid ):
	var cell = get_node("Objects").get_cell(grid.x, grid.y)
	var current_grid = pos_to_grid(get_node("Player").get_pos())
	if grid.x < 0 or grid.x > 5 or grid.y < 0 or grid.y > 10:
		return false
	elif abs(grid.x - current_grid.x) > 1 or abs(grid.y - current_grid.y) > 1:
		return false
	elif cell != -1:
		return false
	else:
		return true
