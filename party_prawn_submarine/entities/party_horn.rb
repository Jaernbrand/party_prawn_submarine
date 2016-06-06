
require 'gosu'

require_relative '../constants'

class PartyHorn

	PARTY_HORN_IMAGE_PATH = Constants::IMAGE_PATH + "party_horn.png"

	# In pixels.
	PARTY_HORN_TILE_WIDTH = 29
	# In pixels.
	PARTY_HORN_TILE_HEIGHT = 10

	PARTY_HORN_Z = 3

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

	def update
	end

	def needs_redraw?
		true
	end

	def draw
	end

end
