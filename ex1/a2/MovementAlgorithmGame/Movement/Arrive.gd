extends MovementAlgorithm

class_name Arrive


# arrive constants
var maxAcceleration : float = MovementUtils.maxLinearAcceleration
var maxSpeed : float = MovementUtils.maxLinearVel
var arrived_radius : float = 100
var slow_radius : float = 300
var time_to_target: float = slow_radius / maxSpeed


func get_steering(delta) -> SteeringBehavior:
	var result = SteeringBehavior.new()
	
	# Get direction to Target
	var direction : Vector2 = target.position - character.position
	var distance : float = direction.length()
	var speed : float
	
	# Check if we're there -> no steering
	if distance < arrived_radius:
		result.linear = -character.linear_velocity
		result.angular = 0
		return result
	
	# Check if outside the slow radius -> move at maxSpeed otherwise calculate scaled speed
	if distance > slow_radius:
		speed = maxSpeed
	else:
		speed = maxSpeed * distance / slow_radius
	
	result.linear = direction.normalized() * speed - character.velocity
	result.linear /= time_to_target
	
	#check if Acceleration is not to fast
	if result.linear.length() > maxAcceleration:
		result.linear = result.linear.normalized() * maxAcceleration
	
	result.angular = 0

	
	# visual helpers
	# draw acceleration vector
	geometryVisualizer2D.draw_vector(character.position, character.position + result.linear)
	geometryVisualizer2D.draw_radius(character.position, MovementUtils.maxLinearAcceleration, Color.BLUE)
	# draw trail
	geometryVisualizer2D.draw_fading_point(character.position, 100)
	# draw arrived radius
	geometryVisualizer2D.draw_radius(target.position, arrived_radius, Color.DARK_RED)
	# draw slow down radius
	geometryVisualizer2D.draw_radius(target.position, slow_radius, Color.RED)
	
	return result
