extends MovementAlgorithm

class_name Flee

var maxAcceleration : float = MovementUtils.maxLinearAcceleration

# flee
func get_steering(delta) -> SteeringBehavior:
	var result = SteeringBehavior.new()
		
	result.linear = character.position - target.position
	result.linear = result.linear.normalized() * MovementUtils.maxLinearVel
	
	result.angular = 0	
	return result
