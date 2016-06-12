
require 'gosu'

# Abstract base class that contains logic common amoung the entities.
class BaseEntity

	# The x value of the entity.
	attr_accessor :x
   
	# The x value of the entity.
	attr_accessor :y
	
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
			180 - @angle
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

end

