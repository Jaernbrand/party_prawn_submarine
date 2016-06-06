
require_relative '../constants'

class Torpedo

	TORPEDO_IMAGE_PATH = Constants::IMAGE_PATH + "torpedo.png"

	# In pixels
	IMG_WIDTH = 112
	# In pixels
	IMG_HEIGHT = 21

	# Pixels / update
	STD_MOVE_SPEED = 2

	TORPEDO_Z = 1

	attr_accessor :player, :game_state

	attr_reader :x, :y
	
	# Angle of the Torpedo in degrees.
	attr_reader :angle

	# Initialises a new Torpedo instance with the given coordinate and with
	# the given angle.
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The starting x position of the Torpedo
	#   - +Numeric+ +y+ -> The starting y position of the Torpedo
	#   - +Numeric+ +angle+ -> The starting angle of the Torpedo in degrees
	def initialize(x, y, angle)
		@x = x
		@y = y
		@move_speed = STD_MOVE_SPEED
		@angle = angle

		@moved = true
	end

	# Preloads the assets needed by the Torpedo.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def self.preload(window)
		@@img = Gosu::Image.new(window, TORPEDO_IMAGE_PATH, false)
	end

	# Updates the state of the Torpedo.
	def update
		move
		if @game_state.outside_bounds?(@x, @y, @@img.width, @@img.height) 	
			@game_state.death_mark(self)
		end
	end

	# Moves the Torpedo in the direction its travelling.
	def move
		rad = degrees_to_radians(@angle) 
		@x += Math::cos(rad) * @move_speed
		@y += Math::sin(rad) * @move_speed
		@moved = true
	end

	# Return whether the Torpedo needs to be redrawn in the GameWindow.
	#
	# * *Returns* :
	#   - +true+ if the Torpedo needs to be redrawn
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		redraw = @moved
		@moved = false
		redraw
	end

	# Draws the Torpedo in the GameWindow.
	def draw
		@@img.draw_rot(@x, 
					  @y, 
					  TORPEDO_Z, 
					  @angle, 
					  0.5, # Default center_x
					  0.5, # Default center_y
					  1, # Default scale_x 
					  1, # Default scale_y
					  @player.colour)
	end

private 
	
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

end

