# Algorithm Visualization Framework

This is a basic tutorial to set up the framework and create custom algorithms for the movement and pathfinding games. This tutorial covers only the basics. 
To find more information about the classes mentioned or not mentioned in this tutorial, use the Godot documentation.
You can find the documentation for the classes by clicking on **Search Help** in the top right corner of the Godot editor and searching for the class name.

(If the documentation does not show up or is empty – 
close the project, delete the .godot folder and reopen the project. This should regenerate the custom documentation.)

## Movement Game

### Create custom movement algorithm:
* Go to folder structure (at the bottom left)
* Go to `res://MovementAlgorithmGame/Movement/`
* Create a new script and name it
* Delete everything that was automatically generated
* Extend `MovementAlgorithm` and define `class_name` like so:

```GDScript
extends MovementAlgorithm  
class_name YourMovementAlgorithm
```

* To create the movement algorithm `getSteering` must be overwritten and a `SteeringBehavior` must be returned. E.g.:

```GDScript
func get_steering(delta) -> SteeringBehavior:
	var result = SteeringBehavior.new()
	
	# Your movement algorithm goes here
	
	return result
```

### Because of the extension of Movement Algorithm, you have access to:
Note that these are just the most useful variables and functions.

* `character` - The character associated with the movement algorithm
  * `position` - The position of the character
  * `get_linear_velocity()` - The linear velocity of the character
  * `get_angular_velocity()` - The angular velocity of the character


* `target` - The target of the character/ the player
  * `position` - The position of the character
  * `get_linear_velocity()` - The linear velocity of the character
  * `get_angular_velocity()` - The angular velocity of the character


* `geometryVisualizer2D` - With this visualization interface you can draw shapes and lines for debugging your algorithm
  * `draw_radius` - Draws a radius
  * `draw_vector` - Draws a vector
  * `draw_point` - Draws a point
  * `draw_fading_point` - Draws a fading point


* `MovementUtils` - A library of useful functions for movement algorithms
  * `maxLinearAcceleration` - Maximum linear acceleration allowed for movement
  * `maxAngularAcceleration` - Maximum angular acceleration allowed for rotation
  * `maxLinearVel` - Maximum speed a moving object can achieve
  * `orientation_from_vec()` - Calculates the rotation angle in radians for a given direction vector
  * `vector_from_orientation()` - Converts an orientation angle in radians to a direction vector
  * `normalize_angle()` - Normalizes an angle to the range (-PI, PI]


### Additional helpful information:
* If the target needs to be changed the method `set_target` can be overwritten. Remember that Godot does not allow overwriting variables of the parent class.
