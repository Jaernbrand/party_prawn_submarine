
require 'test/unit'
require 'minitest/mock'

require 'entities/party_horn'
require 'game_window'

require_relative 'party_horn_extension'

class PartyHornTester < Test::Unit::TestCase

	def setup
		@party_horn = PartyHorn.new
		PartyHorn::tiles = nil
	end

	def test_preload
		PartyHorn::preload(GameWindow.new)
		assert_not_nil(PartyHorn::tiles)
	end

end
