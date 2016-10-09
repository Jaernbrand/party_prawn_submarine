
require 'test/unit'
require 'minitest/mock'

require 'game_window'
require 'menus/main_menu/root_menu'

class RootMenuTester < Test::Unit::TestCase

	def setup
		@window = MiniTest::Mock.new
		mock_user_messages(@window)

		@main = MiniTest::Mock.new
		@main.expect(:window, @window, [])

		@root = RootMenu.new(@main)
	end

	def test_create_exit_button
		root = @root.send(:create_exit_button, 0, 0)
		assert(root.is_a? Button)
	end

	def test_create_new_game_button
		new_game = @root.send(:create_new_game_button, 
							   MiniTest::Mock.new, 
							   0, 
							   0)
		assert(new_game.is_a? Button)
	end


private

	def mock_user_messages(window)
		msgs = MiniTest::Mock.new
		msgs.expect(:message, "Dummy Text", [Symbol])
		msgs.expect(:keyname, "Dummy Text", [Symbol])
		window.expect(:user_messages, msgs, [])
	end

end

