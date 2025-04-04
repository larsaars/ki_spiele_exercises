## The [GeometryVisualizer2D] provides a visualization interface for drawing radii, vectors, points, fading points, and orientation vectors
##
## It allows for the drawing of radii, vectors, points, fading points, and orientation vectors on the screen,
## which can be extremely useful for visualizing and debugging movement algorithms or any spatial data.
## With exception to the fading point all drawings will be deleted each new frame. 
## Because of this the [MovementAlgorithm]s using this node need to redraw the data they visualize each frame.
## Because the [method MovementAlgorithm.get_steering] method is called by the [SteerableCharacter] each physic update,
## the movement algorithms update their data about each frame naturally. This way a [MovementAlgorithm] can simply display
## it's data within the [method MovementAlgorithm.get_steering] method.
class_name GeometryVisualizer2D extends Node2D

## Preloads the MovementUtils script to use its functionality within the class.
const _MovementUtils = preload("res://MovementAlgorithmGame/MovementUtils.gd")

## Initializes the GeometryVisualizer2D setting it as a top level node.
func _init():
	top_level = true

## Defines a Radius class for managing the drawing of circles with a specified position, radius, and color.
class _DrawingRadius extends RefCounted:
	var pos: Vector2
	var rad: float
	var col: Color
	
	func _init(pos, rad, col):
		self.pos = pos
		self.rad = rad
		self.col = col

## Stores the list of _DrawingRadius instances to be drawn.
var _listOfRadii : Array[_DrawingRadius] = []

## Draws a circle on the screen at a given position with a specified radius and color.
## [param pos] The center position of the circle.
## [param rad] The radius of the circle.
## [param col] The color of the circle, defaulting to red.
func draw_radius(pos : Vector2, rad : float, col : Color = Color.RED):
	var newRadius = _DrawingRadius.new(pos, rad, col)
	_listOfRadii.append(newRadius)
	queue_redraw()


## Defines a Vector class for managing the drawing of vectors with a starting point, endpoint, and color.
class _DrawingVector extends RefCounted:
	var from: Vector2
	var to: Vector2
	var col: Color
	
	func _init(from, to, col):
		self.from = from
		self.to = to
		self.col = col

## Stores the list of _DrawingVector instances to be drawn.
var _listOfVectors : Array[_DrawingVector] = []

## Draws a vector from one point to another with a specified color.
## [param from] The starting point of the vector.
## [param to] The endpoint of the vector.
## [param col] The color of the vector, defaulting to blue.
func draw_vector(from : Vector2, to : Vector2, col : Color = Color.BLUE):
	var vec = _DrawingVector.new(from, to, col)
	_listOfVectors.append(vec)
	queue_redraw()

## Defines a Point class for managing the drawing of points with a position and color, supporting fading over frames.
class _DrawingPoint extends RefCounted:
	var vec: Vector2
	var col: Color
	var frames: int
	var initialFrames: int
	
	func _init(vec, col, frames = 1):
		self.vec = vec
		self.col = Color(col, 1)
		self.frames = frames
		self.initialFrames = frames
	
	func toString():
		return "Point: (" + str(vec.x) + ", " + str(vec.y) + "); f: " + str(frames) + "; f_i: " + str(initialFrames) + "; c: " + str(col)

## Stores the list of _DrawingPoint instances to be drawn.
var _listOfPoints : Array[_DrawingPoint] = []

## Draws a point on the screen at a specified position and color.
## [param vec] The position of the point.
## [param col] The color of the point, defaulting to yellow.
func draw_point(vec : Vector2, col : Color = Color.YELLOW):
	_listOfPoints.append(_DrawingPoint.new(vec, col))
	queue_redraw()

## Draws a fading point on the screen at a specified position, color, and duration for the fade effect.
## [param vec] The position of the point.
## [param frames] The number of frames over which the point fades.
## [param col] The color of the point, defaulting to orange.
func draw_fading_point(vec : Vector2, frames : int, col : Color = Color.ORANGE):
	_listOfPoints.append(_DrawingPoint.new(vec, col, frames))
	queue_redraw()


## Defines an OrientationVector class for managing the drawing of orientation vectors with a center, direction, size, and color.
class _DrawingOrientationVector extends RefCounted:
	var center: Vector2
	var orientation: Vector2
	var size: float
	var col: Color
	
	func _init(center: Vector2, orientation: Vector2, size: float, col: Color):
		self.center = center
		self.orientation = orientation
		self.size = size
		self.col = col

## Stores the list of _DrawingOrientationVector instances to be drawn.
var _listOfDrawingOrientationVectors : Array[_DrawingOrientationVector] = []

## Draws an orientation vector on the screen with a specified center, direction, size, and color.
## [param center] The center position of the orientation vector.
## [param orientation] The direction of the orientation vector.
## [param size] The size of the orientation arc.
## [param col] The color of the orientation vector, defaulting to green.
func draw_orientation_vector(center: Vector2, orientation: Vector2, size: float, col: Color = Color.GREEN):
	_listOfDrawingOrientationVectors.append(_DrawingOrientationVector.new(center, orientation, size, col))
	queue_redraw()

## Overrides Godot's _draw() method to render the shapes stored in the class's lists.
## This method is automatically called by Godot when the node is set to redraw.
func _draw():
	if not GlobalMovementAlgorithm.showVisualisation:
		return
	
	
	#Radii
	for radius in _listOfRadii:
		draw_arc(radius.pos, radius.rad, 0, 2*PI, 100, radius.col, 3)
	
	#Vectors
	for drawingVector in _listOfVectors:
		var arrowPoints = PackedVector2Array()
		arrowPoints.append(drawingVector.from)
		arrowPoints.append(drawingVector.to)
		
		var v = Vector2(drawingVector.to - drawingVector.from)
		var length = v.length()
		v = v.normalized() * 10 if length > 10 else v
		var w = v.orthogonal()
		arrowPoints.append(drawingVector.to)
		arrowPoints.append(drawingVector.to - v + w)
		arrowPoints.append(drawingVector.to)
		arrowPoints.append(drawingVector.to - v - w)
		
		draw_multiline(arrowPoints, drawingVector.col, 3)
	
	#Points
	for point in _listOfPoints:
		draw_circle(point.vec, 7, point.col)
	
	#orientation vectors
	for orientationVector in _listOfDrawingOrientationVectors:
		draw_line(orientationVector.center, orientationVector.center + orientationVector.orientation.normalized() * 50, Color.GREEN, 3)
		var start_angle = _MovementUtils.orientation_from_vec(orientationVector.orientation)
		var size = orientationVector.size * ((1*PI)/(2*PI))
		draw_arc(orientationVector.center, 50, start_angle, start_angle + size, 100, orientationVector.col, 3)
	
	#Update of arrays
	_listOfRadii = []
	_listOfVectors = []
	
	for point in _listOfPoints:
		point.frames -= 1
		point.col.a -= 1.0 / point.initialFrames
	var i = 0
	while i < _listOfPoints.size():
		if (_listOfPoints[i].frames <= 0):
			_listOfPoints.remove_at(i)
			i -= 1
		i += 1
	
	_listOfDrawingOrientationVectors = []

## Overrides Godot's _physics_process() method to queue a redraw of the node.
## This ensures that visual elements are updated regularly.
func _physics_process(delta):
	queue_redraw()
	# normally it would suffice to just clear the arrays of things to draw because the movement algorithms trigger a redraw 
	# but when deleting the last one that draws, the drawing would not be erased


