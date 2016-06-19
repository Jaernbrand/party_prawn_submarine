
require 'game_states/play_state'

# Extends PlayState with methods for testing purposes.
class PlayState

	attr_accessor :all_entities, :rm_marked, :has_removed

	def self.img
		@@img
	end

	def self.img=(img)
		@@img = img
	end

end
