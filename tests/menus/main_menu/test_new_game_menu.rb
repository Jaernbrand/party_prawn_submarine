
require 'test/unit'
require 'minitest/mock'

require 'menus/main_menu/new_game_menu'

class NewGameMenuTester < Test::Unit::TestCase

	def setup
		@fake_window = MiniTest::Mock.new
		@root = NewGameMenu.new(@fake_window)
	end

	def test
		assert false, "Not implemented"
	end

end

