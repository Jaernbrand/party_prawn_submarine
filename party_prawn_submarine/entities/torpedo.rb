
require_relative '../constants'
require_relative 'base_entity'
require_relative 'explosion'

# Torpedo fire by a player's Submarine to sink other Submarines. Only moves
# in a straight line.
class Torpedo < BaseEntity

	# The path to the image representation of the torpedo
	TORPEDO_IMAGE_PATH = Constants::IMAGE_PATH + "torpedo.png"

	# In pixels
	IMG_WIDTH = 112
	# In pixels
	IMG_HEIGHT = 21

	# Pixels / update
	STD_MOVE_SPEED = 2

	# The z layer where torpedos are drawn
	TORPEDO_Z = 1

	# The Player who owns the Torpedo
	attr_accessor :player
	
	# The game state in which the Torpedo is contained
	attr_accessor :game_state

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

		@width = IMG_WIDTH
		@height = IMG_HEIGHT

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

	# Kills the other entity if the other entity is a Submarine or a subclass
   	# of a Submarine. Does nothing otherwise.
	#
	# * *Args*    :
	#   - +BaseEntity+ +other+ -> The entity the current one collieded with
	def collision(other)
		if other.is_a?(Submarine) && other.player != @player
			@game_state.death_mark(other)
			@game_state.death_mark(self)

			explosion = Explosion.new(@x - Explosion::TILE_WIDTH/2, 
									  @y - Explosion::TILE_HEIGHT/2)
			@game_state.add_entity(explosion)
		end
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
		@@img.draw_rot(@x + IMG_WIDTH/2.0, 
					   @y + IMG_HEIGHT/2.0, 
					   TORPEDO_Z + @player.z, 
					  @angle, 
					  0.5, # Default center_x
					  0.5, # Default center_y
					  1, # Default scale_x 
					  1, # Default scale_y
					  @player.colour)
	end

end

