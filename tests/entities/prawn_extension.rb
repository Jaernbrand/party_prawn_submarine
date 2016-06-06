
# Extends the Prawn class for testing purposes.
class Prawn

	attr_accessor :tile_idx

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

end
