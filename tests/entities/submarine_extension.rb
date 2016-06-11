
# Extends the Submarine class for testing purposes.
class Submarine

	attr_writer :angle
	
	attr_accessor :torpedo_launched, :x_speed, :y_speed, :pivot, :has_moved,
		:prawn, :player_moved, :moved_y_axis


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
