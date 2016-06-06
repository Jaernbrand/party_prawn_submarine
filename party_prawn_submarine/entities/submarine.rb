require 'gosu'

require_relative '../constants'
require_relative 'torpedo'

class Submarine

	SUB_IMAGE_PATH = Constants::IMAGE_PATH + "submarine.png"
	SUB_SKIN_PATH = Constants::IMAGE_PATH + "submarine_skin.png"

	# In pixels.
	SUB_TILE_WIDTH = 198
	# In pixels.
	SUB_TILE_HEIGHT = 135

	SUB_Z = 2

	# In seconds.
	STD_TORPEDO_RELOAD_TIME = 3

	# Pixels / update
	STD_SPEED_INCREASE_STEP = 0.1

	# Pixels / update
	STD_MAX_SPEED = 5

	# Degrees / update
	STD_ROTATION_SPEED = 1
	
	# The Player that owns the Submarine.
	attr_accessor :player 
	
	# The game state in which the Submarine is manipulated and presented to the 
	# user.
	attr_accessor :game_state

	# The angle of the Submarine in degrees.
	attr_reader :angle

	attr_reader :x, :y, :max_speed

	# Initialises a new Submarine instance with the given coordinate and with
	# the given angle.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The starting x position of the Submarine
	#   - +Numeric+ +y+ -> The starting y position of the Submarine
	#   - +Numeric+ +angle+ -> The starting angle of the Submarine in degrees
	#   - +Prawn+ +prawn+ -> The Submarine's Prawn
	def initialize(x, y, angle, prawn)
		@x = x
		@y = y

		@torpedo_reload_time = STD_TORPEDO_RELOAD_TIME
		@torpedo_launched = Time.at(0)

		@angle = angle
			
		@rotation_speed = STD_ROTATION_SPEED

		@speed_inc_step = STD_SPEED_INCREASE_STEP
		@x_speed = 0
		@y_speed = 0
		@max_speed = STD_MAX_SPEED

		@has_moved = true

		@prawn = prawn
		@prawn.x = x
		@prawn.y = y
		@prawn.angle = angle
	end


	# Preloads the assets needed by the Submarine.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def self.preload(window)
		@@tiles = Gosu::Image::load_tiles(window, 
											  SUB_IMAGE_PATH, 
											  SUB_TILE_WIDTH,
											  SUB_TILE_HEIGHT,
											  false)
		@@skins = Gosu::Image::load_tiles(window, 
											  SUB_SKIN_PATH, 
											  SUB_TILE_WIDTH,
											  SUB_TILE_HEIGHT,
											  false)
	end

	# Updates the Submarine and its Prawn.
	def update
		if Gosu::button_down?(@player.get_button(:left))
			move_left
		end
		if Gosu::button_down?(@player.get_button(:right)) 
			move_right
		end
		if Gosu::button_down?(@player.get_button(:up))
			move_up
		end
		if Gosu::button_down?(@player.get_button(:down))
			move_down
		end

		if !Gosu::button_down?(@player.get_button(:down)) &&
			!Gosu::button_down?(@player.get_button(:up)) &&
			!is_plane

			stabilise
		end

		if Gosu::button_down?(@player.get_button(:torpedo)) && torpedo_ready?
			fire_torpedo
		end

		if @player_moved
			@prawn.swimming = true
		else
			drift 
			@prawn.swimming = false
		end

		@prawn.update
		@player_moved = false
	end

	# Moves the Submarine instance in the direction its heading and decreases 
	# the speed of the Submarine object.
	def drift
		if @x_speed != 0
			@x_speed = adjust_towards_zero(@x_speed, @speed_inc_step) 		
			update_x(@x_speed)
		end
		if @y_speed != 0
			@y_speed = adjust_towards_zero(@y_speed, @speed_inc_step) 
			update_y(@y_speed)
		end

		@has_moved = true
	end

	# Moves the Submarine to the left.
	def move_left
		@x_speed -= @speed_inc_step
		if @x_speed < -@max_speed
			@x_speed = -@max_speed
		end

		update_x(@x_speed)

		if !face_left?
			update_angle(calculate_angle(180))
		end

		@has_moved = @player_moved = true
	end

	# Moves the Submarine to the right.
	def move_right
		@x_speed += @speed_inc_step
		if @x_speed > @max_speed
			@x_speed = @max_speed
		end

		update_x(@x_speed)

		if face_left?
			update_angle(calculate_angle(180))
		end

		@has_moved = @player_moved =true
	end

	# Moves the Submarine upwards.
	def move_up
		@y_speed -= @speed_inc_step
		if @y_speed < -@max_speed
			@y_speed = -@max_speed
		end

		update_y(@y_speed)
		update_angle(calculate_angle(-@rotation_speed))

		@has_moved = @player_moved = true
	end

	# Moves the Submarine downwards.
	def move_down
		@y_speed += @speed_inc_step
		if @y_speed > @max_speed
			@y_speed = @max_speed
		end

		update_y(@y_speed)
		update_angle(calculate_angle(@rotation_speed))

		@has_moved = @player_moved = true
	end

	# Returns whether the Submarine instance is plane or not.
	#
	# * *Returns* :
	#   - +true+ if the Submarine object is plane
	# * *Return* *Type* :
	#   - boolean
	def is_plane
		@angle == 0 || @angle == 180
	end

	# Changes the angle of the Submarine so that it becomes closer to plane.
	# Each call will only perform one angle adjustment. The angle adjustment
	# is equal to the rotation speed of the Submarine instance.
	def stabilise
		if almost_at_angle(0, @angle, @rotation_speed)
			update_angle(0)

		elsif almost_at_angle(180, @angle, @rotation_speed)
			update_angle(180)

		elsif first_quadrant?(@angle) || third_quadrant?(@angle)
			update_angle(calculate_angle(-@rotation_speed))

		else
			update_angle(calculate_angle(@rotation_speed))

		end
	end

	# Returns whether the Submarine is ready to fire a new Torpedo.
	#
	# * *Returns* :
	#   - +true+ if the Submarine is ready to fire a Torpedo
	# * *Return* *Type* :
	#   - boolean
	def torpedo_ready?
		time_diff = Time.new - @torpedo_launched 
		@torpedo_reload_time < time_diff
	end

	# Fires a Torpedo. The Torpedo is owned by the same player that owns the
	# Submarine. 
	def fire_torpedo
		x = (@x + @@tiles[0].width/2) - Torpedo::IMG_WIDTH / 2
		y = (@y + @@tiles[0].height/2) - Torpedo::IMG_HEIGHT / 2

		torpedo = Torpedo.new(x, y, @angle)
		torpedo.player = @player
		@game_state.add_entity(torpedo)
		@torpedo_launched = Time.new
	end

	# Return whether the Submarine needs to be redrawn in the GameWindow.
	#
	# * *Returns* :
	#   - +true+ if the Submarine needs to be redrawn
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		if @has_moved || @prawn.needs_redraw?
			return true
		end
		false
	end

	# Draws the Submarine in the GameWindow.
	def draw
		sub_face_left = face_left?

		draw_sub(sub_face_left)
		@has_moved = false
		@prawn.draw
	end


protected
	
	# Updates the x value of the Submarine and its children by the given amount.
	#
	# * *Args*    :
	#   - +Numeric+ +x_speed+ -> The amount to add to the x value
	def update_x(x_speed)
		@x += x_speed
		@prawn.x += x_speed
	end

	# Updates the y value of the Submarine and its children by the given amount.
	#
	# * *Args*    :
	#   - +Numeric+ +y_speed+ -> The amount to add to the y value
	def update_y(y_speed)
		@y += y_speed
		@prawn.y += y_speed
	end

	# Sets the angle of the Submarine and its children to the given angle.
	#
	# * *Args*    :
	#   - +Numeric+ +angle+ -> The new angle
	def update_angle(angle)
		@angle = angle
		@prawn.angle = angle
	end

	# Calculates the angle of the Submarine if the angle is change the given 
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

	# Adjusts the given number closer to 0 according to the given adjustment 
	# value and returns the result. If 0 can be reached or passed with the 
	# given arguments, then 0 is returned.
	#
	# * *Args*    :
	#   - +Numeric+ +number+ -> The number to adjust
	#   - +Numeric+ +adjustment+ -> The step closer to 0 as a positive value 
	# * *Returns* :
	#   - The result of the adjustment
	# * *Return* *Type* :
	#   - Numeric
	def adjust_towards_zero(number, adjustment)
		if (number - adjustment).abs <= adjustment
			0
		elsif number > 0
			number - adjustment
		elsif number < 0
			number + adjustment
		else
			raise "Unexpected conditional branch. " <<
					"Called with arguments: " <<
					"number = " << number.to_s <<
					", adjustment = " << adjustment.to_s	
		end
	end

	# Checks if the current angle is almost equal to the target angle.
	#
	# * *Args*    :
	#   - +Numeric+ +target_angle+ -> The target angle to compare with
	#   - +Numeric+ +current_angle+ -> The current angle to compare with
	#   - +Numeric+ +error+ -> The error margin to use as a positive value
	# * *Returns* :
	#   - +true+ if the target angle and the current angle are almost equal
	# * *Return* *Type* :
	#   - boolean
	def almost_at_angle(target_angle, current_angle, error)
		(target_angle - current_angle).abs <= error
	end

	# Checks if the given angle is in the first quadrant.
	#
	# * *Args*    :
	#   - +Numeric+ +angle+ -> The angle in degrees
	# * *Returns* :
	#   - +true+ if the angle is in the first quadrant
	# * *Return* *Type* :
	#   - boolean
	def first_quadrant?(angle)
		0 < angle && angle < 90
	end

	# Checks if the given angle is in the third quadrant.
	#
	# * *Args*    :
	#   - +Numeric+ +angle+ -> The angle in degrees
	# * *Returns* :
	#   - +true+ if the angle is in the third quadrant
	# * *Return* *Type* :
	#   - boolean
	def third_quadrant?(angle)
		180 < angle && angle < 270
	end


private

	# Draws the graphical representation of the Submarine in the GameWindow.
	#
	# * *Args*    :
	#   - +boolean+ +sub_face_left+ -> Whether the Submarine faces left or not
	def draw_sub(sub_face_left)
		idx = sub_tile_index(sub_face_left)
		angle = sub_draw_angle(sub_face_left)

		sub_img = @@tiles[idx]
		sub_img.draw_rot(@x, @y, SUB_Z, angle)

		sub_img = @@skins[idx]
		sub_img.draw_rot(@x, 
						 @y, 
						 SUB_Z, 
						 angle, 
						 0.5, # Default center_x 
						 0.5, # Default center_y
						 1, # Default scale_x
						 1, # Default scale_y
						 @player.colour)
	end

	# Returns the current tile index to use for drrawing the Submarine.
	#
	# * *Args*    :
	#   - +boolean+ +sub_face_left+ -> Whether the Submarine faces left or not
	# * *Returns* :
	#   - The current tile index
	# * *Return* *Type* :
	#   - Integer
	def sub_tile_index(sub_face_left)
		if sub_face_left
			0
		else
			1
		end
	end

	# Returns the angle to use when drawing the Submarine in the GameWindow.
	#
	# * *Args*    :
	#   - +boolean+ +sub_face_left+ -> Whether the Submarine faces left or not
	# * *Returns* :
	#   - The draw angle to use
	# * *Return* *Type* :
	#   - Numeric
	def sub_draw_angle(sub_face_left)
		if sub_face_left
			180 - @angle
		else
			@angle
		end
	end

	# Returns whether the Submarine faces to the left.
	#
	# * *Returns* :
	#   - +true+ if the Submarine faces to the left
	# * *Return* *Type* :
	#   - boolean
	def face_left?
		90 < @angle && @angle < 270
	end

end
