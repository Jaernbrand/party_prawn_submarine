
# Extends the Prawn class for testing purposes.
class Prawn

	attr_accessor :tile_idx, :prev_time

	def self.tiles
		@@tiles
	end

	def self.tiles=(value)
		@@tiles=value
	end

	def self.skins
		@@skins
	end

	def self.skins=(value)
		@@skins=value
	end

	def self.swim_sound
		@@swim_sound
	end

	def self.swim_sound=(value)
		@@swim_sound=value
	end

end
