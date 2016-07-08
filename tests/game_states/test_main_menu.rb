
require 'test/unit'
require 'minitest/mock'

require 'game_window'
require 'game_states/main_menu'

require_relative 'main_menu_extension'

class MainMenuTester < Test::Unit::TestCase

	def setup
		@main_menu = MainMenu.new(GameWindow.new)
	end

	def test_mouse_cursor_is_shown
		assert @main_menu.window.show_cursor
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
		root = @main_menu.send(:create_exit_button, 0, 0)
		assert(root.is_a? Button)
	end

	def test_create_new_game_button
		new_game = @main_menu.send(:create_new_game_button, 
								   MiniTest::Mock.new, 
								   0, 
								   0)
		assert(new_game.is_a? Button)
	end

	def test_button_up
		@main_menu.controller = MiniTest::Mock.new
		@main_menu.controller.expect(:button_up, nil, [Numeric])

		key_id = 50
		@main_menu.button_up(key_id)

		@main_menu.controller.verify
	end

	def test_button_down
		@main_menu.controller = MiniTest::Mock.new
		@main_menu.controller.expect(:button_down, nil, [Numeric])

		key_id = 50
		@main_menu.button_down(key_id)

		@main_menu.controller.verify
	end

	def test_button_up_nil_controller
		key_id = 50
		assert_nothing_raised do
			@main_menu.button_up(key_id)
		end
	end

	def test_button_down_nil_controller
		key_id = 50
		assert_nothing_raised do
			@main_menu.button_down(key_id)
		end
	end

end
