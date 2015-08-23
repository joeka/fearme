extends AnimatedSprite

var notice = 0
var fear = 0


func turn_on_light( on ):
	get_parent().get_node("Light").set_enabled( on )

func _next_turn():
	var dist = get_pos().distance_to(get_parent().get_node("Player").get_pos())
	print( "Distance: ", dist )
