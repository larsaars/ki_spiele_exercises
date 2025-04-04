extends MovementAlgorithm

class_name Seek

# seek
func get_steering(delta) -> SteeringBehavior:
	var result = SteeringBehavior.new()
	
	# calculate target direction
	var targetDirection = (target.position - character.position).normalized()
	var desiredVeclocity = targetDirection * MovementUtils.maxLinearAcceleration
	
	# calc desired acceleration
	var desiredAcceleration = desiredVeclocity - character.velocity
	
	# cap vel at max
	if desiredAcceleration.length() > MovementUtils.maxLinearAcceleration:
		desiredAcceleration = desiredAcceleration.normalized() * MovementUtils.maxLinearAcceleration
	
	# set resulting linear acceleration
	result.linear = desiredAcceleration
	
	result.angular = 0
	
	# visual helpers
	geometryVisualizer2D.draw_vector(character.position, character.position + result.linear)
	geometryVisualizer2D.draw_radius(character.position, MovementUtils.maxLinearAcceleration)
	geometryVisualizer2D.draw_fading_point(character.position, 100)
	geometryVisualizer2D.draw_point(target.position)
	
	return result
