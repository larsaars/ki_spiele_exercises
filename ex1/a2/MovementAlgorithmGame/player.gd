extends MovementGameCharacter

func _ready():
	super()
	deactivate_dragging()

func _physics_process(delta):
	var result = SteeringBehavior.new()
	
	# feels better when own player accelerates faster then the algorithms
	# it doesn't get limited because it sets the values of the steering behavior directly
	var max_acceleration = 300
	var max_roll_speed : float = 3.14 * 3
	
	
	var up_down_direction = Input.get_axis("up", "down")
	if up_down_direction:
		result.linear.y = up_down_direction
	else:
		result.linear.y = 0
	
	
	var right_left_direction = Input.get_axis("left", "right")
	if right_left_direction:
		result.linear.x = right_left_direction
	else:
		result.linear.x = 0
	
	result.linear = result.linear.normalized() * max_acceleration
	
	
	var right_left_roll = Input.get_axis("roll_left", "roll_right")
	if right_left_roll:
		result.angular = right_left_roll * max_roll_speed
	else:
		result.angular = 0
	
	
	movement_physics_update(result, delta)
