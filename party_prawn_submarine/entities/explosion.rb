
require_relative '../constants'
require_relative 'base_entity'

# An animated explosion with sound.
class Explosion < BaseEntity

	TILE_PATH = Constants::IMAGE_PATH # TODO Add the filename!

	EXPLOSION_SOUND_PATH = Constants::SOUND_EFFECTS_PATH + "waterxplo.wav"

	# TODO Set these!
	# In pixels
	# IMG_WIDTH = 112
	# In pixels
	# IMG_HEIGHT = 21

	# In milli seconds
	STD_ANIMATION_UPDATE_INTERVAL = 100

	EXPLOSION_Z = 100

	# Initialises a new Explosion instance with the top left corner at the 
	# given coordinate. 
	#
	# * *Args*    :
	#   - +Numeric+ +x+ -> The x position of the top left corner
	#   - +Numeric+ +y+ -> The y position of the top left corner
	#   - +Numeric+ +game_state+ -> The game state in which the Explosion is placed
	def initialize(x, y, game_state)
		@x = x
		@y = y

		# TODO! 
		#@width = IMG_WIDTH
		#@height = IMG_HEIGHT

		@game_state = game_state

		@frame = 0

		@animation_update_interval = STD_ANIMATION_UPDATE_INTERVAL
		@prev_time = 0
	end

	# Preloads the assets needed by the Explosion.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def self.preload(window)
		# @@tiles = Gosu::Image::load_tiles(window, TILE_PATH, false)
		@@explosion_sound = Gosu::Sample.new(EXPLOSION_SOUND_PATH)
	end

	# Updates the state of the Explosion.
	def update
		curr_time = Gosu::milliseconds
		if (curr_time - @prev_time).abs > @animation_update_interval
			# @frame++
			# TODO Remove object when incrementing from last frame.
			@prev_time = curr_time
			@@explosion_sound.play
		end
	end

	# Return whether the Torpedo needs to be redrawn in the GameWindow.
	#
	# * *Returns* :
	#   - +true+ if the Torpedo needs to be redrawn
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		# TODO Only needs to update when animation frame changed.
		true
	end

	# Draws the Explosion in the GameWindow.
	def draw
		img = @@tiles[@frame]
		img.draw(@x, @y, EXPLOSION_Z)
	end

end

