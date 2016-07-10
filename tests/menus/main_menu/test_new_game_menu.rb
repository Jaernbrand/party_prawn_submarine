
require 'test/unit'
require 'minitest/mock'

require 'game_window'

require 'menus/main_menu/root_menu'
require 'menus/main_menu/new_game_menu'

class NewGameMenuTester < Test::Unit::TestCase

	def setup
		@window = MiniTest::Mock.new
		mock_user_messages(@window)

		@main = MiniTest::Mock.new
		@main.expect(:window, @window, [])

		@root_menu = MiniTest::Mock.new

		@menu = NewGameMenu.new(@main)
		@menu.parent = @root_menu
	end

	def test_create_back_button
		menu = @menu.send(:create_back_button, 0, 0)
		assert(menu.is_a? Button)
	end

	def test_create_start_button
		new_game = @menu.send(:create_start_button, 0, 0)
		assert(new_game.is_a? Button)
	end

	def test_std_player_names
		oracle = ["Player1", "Player2", "Player3", "Player4"]
		names = @menu.send(:std_player_names)
		assert_equal(oracle, names)
	end

	def test_create_player_options
		assert false, "Not implemented!"
	end


private

	def mock_user_messages(window)
		msgs = MiniTest::Mock.new
		msgs.expect(:message, "Dummy Text", [Symbol])
		window.expect(:user_messages, msgs, [])
	end

end

