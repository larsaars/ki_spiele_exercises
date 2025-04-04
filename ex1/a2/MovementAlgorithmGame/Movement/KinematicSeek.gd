extends MovementAlgorithm
class_name KinematicSeek


func get_steering(delta) -> SteeringBehavior:
	character.use_kinematic_update()
	
	var result = SteeringBehavior.new()
	
	result.linear = target.position - character.position
	result.linear = result.linear.normalized() * MovementUtils.maxLinearVel
	
	result.angular = 0
	
	return result
	
