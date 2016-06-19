
# Extends the PartyHorn class for testing purposes.
class PartyHorn

	attr_accessor :is_blown, :start_time, :has_changed

	def self.tiles
		@@tiles
	end

	def self.tiles=(value)
		@@tiles=value
	end

	def self.sound
		@@sound
	end

	def self.sound=(value)
		@@sound=value
	end

end
