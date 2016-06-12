
require 'gosu'

require_relative '../constants'
require_relative 'base_entity'

# Plays a sound and draws a colourful party horn when blown. Intended to be 
# associated with a Prawn.
class PartyHorn < BaseEntity

	PARTY_HORN_IMAGE_PATH = Constants::IMAGE_PATH + "party_horn.png"

	# In pixels.
	PARTY_HORN_TILE_WIDTH = 29
	# In pixels.
	PARTY_HORN_TILE_HEIGHT = 10

	# The z layer where PartyHorns are drawn. Used by the #draw method.
	PARTY_HORN_Z = 3

	# The time the PartyHorn will be blown in milliseconds.
	BLOW_DURATION = 1500

	# Initialises a new PartyHorn object. The new object is not being blown 
	# and will therefore not be drawn. Positional attributes are set to 0.
	def initialize
		@is_blown = false

		@x = @y = @angle = 0
	end

	# Preloads the assets needed by the PartyHorn.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def self.preload(window)
		@@tiles = Gosu::Image::load_tiles(window, 
										 PARTY_HORN_IMAGE_PATH, 
										 PARTY_HORN_TILE_WIDTH, 
										 PARTY_HORN_TILE_HEIGHT,
										 false)
	end

	# Updates the state of the PartyHorn.
	def update
		if @is_blown
			curr_time = Gosu::milliseconds
			if (curr_time - @start_time).abs > BLOW_DURATION
				@is_blown = false
			end
		end
	end

	# Returns whether the PartyHorn needs to be redrawn.
	#
	# * *Returns* :
	#   - +true+ if the PartyHorn needs to be redrawn
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		@is_blown
	end

	# Draws the PartHorn in the GameWindow.
	def draw
		if @is_blown
			is_facing_left = face_left?

			angle = draw_angle(is_facing_left)
			idx = is_facing_left ? 0 : 1

			img = @@tiles[idx]
			img.draw_rot(@x, @y, PARTY_HORN_Z, angle)
		end
	end

	# Blows the PartyHorn, causing it to be drawn and play a sound.
	def blow
		@is_blown = true
		@start_time = Gosu::milliseconds
	end

end
