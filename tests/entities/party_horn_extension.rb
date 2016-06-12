
# Extends the PartyHorn class for testing purposes.
class PartyHorn

	attr_accessor :is_blown, :start_time

	def self.tiles
		@@tiles
	end

	def self.tiles=(value)
		@@tiles=value
	end

end
