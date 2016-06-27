
require 'entities/explosion'

class Explosion

	attr_accessor :prev_time, :frame, :changed_frame

	def self.explosion_sound=(value)
		@@explosion_sound=value
	end

	def self.explosion_sound
		@@explosion_sound
	end

	def self.tiles=(value)
		@@tiles=value
	end

	def self.tiles
		@@tiles
	end

end

