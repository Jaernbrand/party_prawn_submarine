
require 'gosu'

require_relative '../point'

# Abstract base class that contains logic common amoung the entities.
class BaseEntity

	# The x value of the entity.
	attr_accessor :x
   
	# The x value of the entity.
	attr_accessor :y

	# The x value of the entity.
	attr_accessor :width

	# The x value of the entity.
	attr_accessor :height
	
	# The angle of the entity in degrees.
	attr_accessor :angle

	# Returns whether the entity faces to the left.
	#
	# * *Returns* :
	#   - +true+ if the entity faces to the left
	# * *Return* *Type* :
	#   - boolean
	def face_left?
		90 < @angle && @angle < 270
	end

	# Performes the actions to be taken when the current entity collieds with 
	# an other entity. This implementation doesn't do anything. 
	#
	# This method is intended to be overriden by subclasses.
	#
	# * *Args*    :
	#   - +BaseEntity+ +other+ -> The entity the current one collieded with
	def collision(other)
	end

	# Checks if the current entity overlaps with the other entity.
	#
	# * *Args*    :
	#   - +BaseEntity+ +other+ -> Other entity to check for overlap
	# * *Returns* :
	#   - Whether the current entirty overlaps with the other entity
	# * *Return* *Type* :
	#   - boolean
	def overlaps?(other)
		if other != self && circles_overlap?(other)
			return rectangles_overlap?(other)
		end
		false
	end


protected

	# Returns the angle to use when drawing the entity in the GameWindow.
	#
	# * *Args*    :
	#   - +boolean+ +face_left+ -> Whether the entity faces left or not
	# * *Returns* :
	#   - The draw angle to use
	# * *Return* *Type* :
	#   - Numeric
	def draw_angle(face_left)
		if face_left
			@angle - 180
		else
			@angle
		end
	end

	# Calculates the angle of the entity if the angle is changed the given 
	# number of degrees.
	#
	# * *Args*    :
	#   - +Numeric+ +change+ -> The change in degrees
	# * *Returns* :
	#   - The new angle in degrees
	# * *Return* *Type* :
	#   - Numeric
	def calculate_angle(change)
		(@angle + change) % 360
	end

	# Converts degrees to radians.
	#
	# * *Args*    :
	#   - +Numeric+ +deg+ -> Degrees to convert to radians
	# * *Returns* :
	#   - The given value in degrees as radians
	# * *Return* *Type* :
	#   - Numeric
	def degrees_to_radians(deg)
		deg * Math::PI / 180
	end


private

	# Treats the entities as circles and checks if they overlap. The radii of
	# the circles are is set to width/2 or height/2, whichever is greater in
	# the entity in question.
	#
	# * *Args*    :
	#   - +BaseEntity+ +other+ -> Other entity to check for overlap
	# * *Returns* :
	#   - whether the circles of the entities overlaps
	# * *Return* *Type* :
	#   - boolean
	def circles_overlap?(other)
		centre_x = @x + width/2.0
		centre_y = @y + height/2.0

		other_centre_x = other.x + other.width/2.0
		other_centre_y = other.y + other.height/2.0

		distance = euclidean_distance([centre_x, centre_y], 
									  [other_centre_x, other_centre_y])

		radius = width > height ? width/2.0 : height/2.0 
		other_radius = other.width > other.height ? 
						other.width/2.0 : other.height/2.0 

		radius + other_radius >= distance
	end

	# Calculates the euclidean distance between lhs and rhs.
	#
	# * *Args*    :
	#   - +Array+ +lhs+ -> One of the arrays containing position values
	#   - +Array+ +rhs+ -> One of the arrays containing position values
	# * *Returns* :
	#   - the euclidean distance between the given positions
	# * *Return* *Type* :
	#   - Numeric
	def euclidean_distance(lhs, rhs)
		if lhs.length != rhs.length
			raise "Arguments have to be of equal length." <<
					" 'lhs' was: " << lhs.length.to_s <<
					" 'rhs' was: " << rhs.length.to_s
		end

		sum = 0
		for i in 0...lhs.length
			sum += (lhs[i] - rhs[i])**2
		end

		Math::sqrt(sum)
	end

	# Checks if the current entity's rotated rectangle overlaps with the other 
	# entity's rotated rectangle. Uses the Separating Axis Theorem to perform 
	# this check.
	#
	# * *Args*    :
	#   - +BaseEntity+ +other+ -> Other entity to check for overlap
	# * *Returns* :
	#   - Whether the current entirty's rectangle overlaps with the other entity's rectangle
	# * *Return* *Type* :
	#   - boolean
	def rectangles_overlap?(other)
		axes = []
	
		rect1 = corners(self)
		rect2 = corners(other)

		create_axes(rect1, axes)
		create_axes(rect2, axes)

		axes.each do |axis|
			proj_rect1 = project(rect1, axis)
			proj_rect2 = project(rect2, axis)
			
			proj_rect1.sort!
			proj_rect2.sort!

			if !projections_overlap(proj_rect1, proj_rect2)
				return false
			end
		end

		true
	end

	# Returns the positions of the four corners of the given entity's bounding
	# rectangle.
	#
	# * *Args*    :
	#   - +BaseEntity+ +entity+ -> the entity to get the corneers of
	# * *Returns* :
	#   - Array containing the positions of the rectangle's four corners
	# * *Return* *Type* :
	#   - Array<object>
	def corners(entity)
		all_corners = []

		angle = degrees_to_radians(entity.angle())
		cos = Math::cos(angle)
		sin = Math::sin(angle)

		centre_x = entity.x + entity.width / 2.0
		centre_y = entity.y + entity.height / 2.0

		all_corners << create_corner(entity.x, 
									 entity.y, 
									 cos, 
									 sin, 
									 centre_x, 
									 centre_y)

		all_corners << create_corner(entity.x, 
									 entity.y + entity.height, 
									 cos, 
									 sin, 
									 centre_x, 
									 centre_y)

		all_corners << create_corner(entity.x + entity.width, 
									 entity.y, 
									 cos, 
									 sin, 
									 centre_x, 
									 centre_y)

		all_corners << create_corner(entity.x + entity.width, 
									 entity.y + entity.height, 
									 cos, 
									 sin, 
									 centre_x, 
									 centre_y)


		all_corners
	end

	# Creates a corner coorinate from an non-rotated rectangle. The corner is
	# rotated around the given centre coordinate.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The plane x coordinate.
	#   - +Numeric+ +y+ -> The plane y coordinate.
	#   - +Numeric+ +cos+ -> The cos value of the rotation angle.
	#   - +Numeric+ +sin+ -> The sin value of the rotation angle.
	#   - +Numeric+ +centre_x+ -> The centre x coordinate.
	#   - +Numeric+ +centre_y+ -> The centre y coordinate.
	# * *Returns* :
	#   - Rotated corner coordinate
	# * *Return* *Type* :
	#   - object
	def create_corner(x, y, cos, sin, centre_x, centre_y)
		corner = Point.new
		x -= centre_x
		y -= centre_y
		corner.x = rotate_x(x, y, cos, sin) + centre_x
		corner.y = rotate_y(x, y, cos, sin) + centre_y
		corner
	end

	# Rotates the given x value around the origin.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x coordinate.
	#   - +Numeric+ +y+ -> The y coordinate.
	#   - +Numeric+ +cos+ -> The cos value of the rotation angle.
	#   - +Numeric+ +sin+ -> The sin value of the rotation angle.
	# * *Returns* :
	#   - The value of x after rotation
	# * *Return* *Type* :
	#   - Numeric
	def rotate_x(x, y, cos, sin)
		cos * x + sin * y
	end

	# Rotates the given y value around the origin.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x coordinate.
	#   - +Numeric+ +y+ -> The y coordinate.
	#   - +Numeric+ +cos+ -> The cos value of the rotation angle.
	#   - +Numeric+ +sin+ -> The sin value of the rotation angle.
	# * *Returns* :
	#   - The value of y after rotation
	# * *Return* *Type* :
	#   - Numeric
	def rotate_y(x, y, cos, sin)
		cos * y - sin * x
	end

	# Creates the axes of the given rectanlge and pushes them to the axes array.
	#
	# * *Args*    :
	#   - +Array<object>+ +rect+ -> the rectangle to create axes from
	#   - +Array<object>+ +axis+ -> array containing all axes
	def create_axes(rect, axes)
		axis1 = Point.new
		axis1.x = (rect[0].x - rect[1].x).abs
		axis1.y = (rect[0].y - rect[1].y).abs
		axes.push(axis1)

		axis2 = Point.new
		axis2.x = (rect[0].x - rect[2].x).abs
		axis2.y = (rect[0].y - rect[2].y).abs
		axes.push(axis2)
	end

	# Projects the given rectangle to the supplied axis.
	#
	# * *Args*    :
	#   - +Array<object>+ +rect+ -> the rectangle to project to the axis
	#   - +object+ +axis+ -> the axis to project the rectangle to
	# * *Returns* :
	#   - the rectanlges projection to the axis
	# * *Return* *Type* :
	#   - Array<Numeric>
	def project(rect, axis)
		scalars = []
		rect.each do |corner|
			proj = (axis.x * corner.x + axis.y * corner.y) / 
					(axis.x**2 + axis.y**2)
			proj_x = proj * axis.x
			proj_y = proj * axis.y

			scalars << proj_x * axis.x + proj_y * axis.y
		end
		scalars
	end

	# Checks whether the two projections overlap. Both arrays containing the 
	# scalars are assumed to be sorted.
	#
	# * *Args*    :
	#   - +Array<Numeric>+ +proj1+ -> projection to check for overlap
	#   - +Array<Numeric>+ +proj2+ -> projection to check for overlap
	# * *Returns* :
	#   - whether the two projections overlap
	# * *Return* *Type* :
	#   - boolean
	def projections_overlap(proj1, proj2)
		proj1.first <= proj2.last && proj2.first <= proj1.last
	end

end

