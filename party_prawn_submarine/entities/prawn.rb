
require 'gosu'

require_relative '../constants'
require_relative 'base_entity'

# Represents a prawn in the game. The class mostly contains logic for graphical
# representation in the GameWindow.
class Prawn < BaseEntity

	PRAWN_IMAGE_PATH = Constants::IMAGE_PATH + "prawn.png"
	PRAWN_SKIN_PATH = Constants::IMAGE_PATH + "prawn_skin.png"

	# In pixels.
	TILE_WIDTH = 134
	# In pixels.
	TILE_HEIGHT = 46

	# The z layer where Prawns are drawn. Used by the #draw method.
	PRAWN_Z = 4

	# In milli seconds
	STD_ANIMATION_UPDATE_INTERVAL = 100

	# The Player that owns the Prawn.
	attr_accessor :player

	# Boolean indicating whether the Prawn is currently swimming.
	attr_accessor :swimming

	# The PartyHorn of the Prawn object. 
	attr_accessor :party_horn

	# Initialises a new Prawn with the given player as owner.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def initialize(player, party_horn)
		@player = player
		@party_horn = party_horn

		@x = @y = @angle = 0

		@swimming = false

		@tile_idx = 0
		@prev_time = 0
		@animation_update_interval = STD_ANIMATION_UPDATE_INTERVAL
	end

	# Preloads the assets needed by the Prawn.
	#
	# * *Args*    :
	#   - +Gosu::Window+ +window+ -> The window to draw the graphical assets in
	def self.preload(window)
		@@tiles = Gosu::Image::load_tiles(window, 
											PRAWN_IMAGE_PATH, 
											TILE_WIDTH, 
											TILE_HEIGHT,
											false)
		@@skins = Gosu::Image::load_tiles(window, 
											PRAWN_SKIN_PATH, 
											TILE_WIDTH, 
											TILE_HEIGHT,
											false)
	end

	# Updates the state of the Prawn.
	def update
		if @swimming
			curr_time = Gosu::milliseconds
			if (curr_time - @prev_time).abs > @animation_update_interval
				increment_swim_tile_index
				@prev_time = curr_time
			end
		elsif face_left?
			@tile_idx = 0
		else
			@tile_idx = 3
		end

		move_party_horn
		@party_horn.update
	end

	# Return whether the Prawn needs to be redrawn in the GameWindow.
	#
	# * *Returns* :
	#   - +true+ if the Prawn needs to be redrawn
	# * *Return* *Type* :
	#   - boolean
	def needs_redraw?
		@swimming || @party_horn.needs_redraw?
	end

	# Draws the Prawn in the GameWindow.
	def draw
		@party_horn.draw
		angle = draw_angle(face_left?)
		prawn_img = @@tiles[@tile_idx]
		prawn_img.draw_rot(@x+TILE_WIDTH/2, @y+TILE_HEIGHT/2, PRAWN_Z, angle)

		prawn_skin = @@skins[@tile_idx] 
		prawn_skin.draw_rot(@x + TILE_WIDTH/2, 
						 @y + TILE_HEIGHT/2, 
						 PRAWN_Z, 
						 angle, 
						 0.5, # Default center_x 
						 0.5, # Default center_y
						 1, # Default scale_x
						 1, # Default scale_y
						 @player.colour)
	end


protected

	# Increments the index used to draw the correct image when the Prawn 
	# is swimming.
	def increment_swim_tile_index
		animation_frames = 2

		if face_left?
			post_adj = 1
			@tile_idx = (@tile_idx % animation_frames) + post_adj
		else
			post_adj = 4
			pre_adj = post_adj - 1 
			@tile_idx = ((@tile_idx - pre_adj) % animation_frames) + post_adj
		end
	end


private


	# Sets the coordinates of the Prawn's PartyHorn.
	def move_party_horn
		if face_left?
			@party_horn.x = @x + 
							(TILE_WIDTH/4 - PartyHorn::PARTY_HORN_TILE_WIDTH)
		else
			@party_horn.x = @x + 3 * TILE_WIDTH/4
		end
		@party_horn.y = @y + 3 * TILE_HEIGHT/5
		@party_horn.angle = @angle
	end

end

