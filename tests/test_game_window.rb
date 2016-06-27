
require 'test/unit'
require 'minitest/mock'

require 'game_window'

class GameWindowTester < Test::Unit::TestCase

	def setup
		@window = GameWindow.new
	end

	def test_user_messages_is_set
		assert_not_nil @window.user_messages
	end

end

