
require 'test/unit'
require 'minitest/mock'

require 'game_window'
require 'game_states/main_menu'

require_relative 'main_menu_extension'

class MainMenuTester < Test::Unit::TestCase

	def setup
		@main_menu = MainMenu.new(GameWindow.new)
	end

	def test_draw
		@main_menu.current_menu = MiniTest::Mock.new
		@main_menu.current_menu.expect(:draw, nil, [])

		@main_menu.draw

		@main_menu.current_menu.verify
	end

	def test_update
		@main_menu.current_menu = MiniTest::Mock.new
		@main_menu.current_menu.expect(:update, nil, [])

		@main_menu.update

		@main_menu.current_menu.verify
	end

	def test_create_root_menu
		root = @main_menu.send(:create_root_menu)
		assert(root.is_a? Menu)
	end

	def test_create_exit_button
		root = @main_menu.send(:create_exit_button)
		assert(root.is_a? Button)
	end

end
