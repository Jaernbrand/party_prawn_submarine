
require_relative '../constants'
require_relative 'base_entity'

# An animated explosion with sound.
class Explosion < BaseEntity

	TILE_PATH = Constants::IMAGE_PATH + "explosion_sprites.png"

	EXPLOSION_SOUND_PATH = Constants::SOUND_EFFECTS_PATH + "waterxplo.ogg"

	# In pixels
	TILE_WIDTH = 200
	# In pixels
	TILE_HEIGHT = 200

	# In milli seconds
	STD_ANIMATION_UPDATE_INTERVAL = 100

	# The z layer where Explosions are drawn. Used by the #draw method.
	EXPLOSION_Z = 100

	# The game state in which the explosion exists
	attr_accessor :game_state

	# Initialises a new Explosion instance with the top left corner at the 
	# given coordinate. 
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x position of the top left corner
	#   - +Numeric+ +y+ -> The y position of the top left corner
	#   - +Numeric+ +game_state+ -> The game state in which the Explosion is placed
	def initialize(x, y)
		@x = x
		@y = y

		@width = TILE_WIDTH
		@height = TILE_HEIGHT
		
		@angle = 0

		@frame = 0

		@animation_update_interval = STD_ANIMATION_UPDATE_INTERVAL
		@prev_time = 0

		@changed_frame = true

		@@explosion_sound.play
	end

	# Preloads the assets needed by the Explosion.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def self.preload(window)
		@@tiles = Gosu::Image::load_tiles(window, 
										  TILE_PATH, 
										  TILE_WIDTH, 
										  TILE_HEIGHT, 
										  false)
		@@explosion_sound = Gosu::Sample.new(EXPLOSION_SOUND_PATH)
	end

	# Updates the state of the Explosion.
	def update
		curr_time = Gosu::milliseconds
		if (curr_time - @prev_time).abs > @animation_update_interval
			@frame += 1
			@changed_frame = true

			if @frame >= @@tiles.length
				@game_state.death_mark(self)
			end

			@prev_time = curr_time
		end
	end

	# Return whether the Torpedo needs to be redrawn in the GameWindow.
	#
	# * *Returns* :
	#   - +true+ if the Torpedo needs to be redrawn
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		@changed_frame
	end

	# Draws the Explosion in the GameWindow.
	def draw
		if @frame < @@tiles.length
			img = @@tiles[@frame]
			img.draw(@x, @y, EXPLOSION_Z)

			@changed_frame = false
		end
	end

end

