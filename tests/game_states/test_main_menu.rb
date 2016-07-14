
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

	def test_root_menu_is_created
		root = @main_menu.current_menu
		assert(root.is_a? RootMenu)
	end

	def test_current_menu_accessors
		old_root = @main_menu.current_menu
		@main_menu.current_menu = RootMenu.new(@main_menu)
		assert_not_same(old_root, @main_menu.current_menu)
	end

	def test_button_down
		id = 50

		@main_menu.controller = MiniTest::Mock.new
		@main_menu.controller.expect(:button_down, nil, [id])

		@main_menu.button_down(id)

		@main_menu.controller.verify
	end

	def test_buttoon_up
		id = 50

		@main_menu.controller = MiniTest::Mock.new
		@main_menu.controller.expect(:button_up, nil, [id])

		@main_menu.button_up(id)

		@main_menu.controller.verify
	end

	def test_update_controller_called
		@main_menu.controller = MiniTest::Mock.new
		@main_menu.controller.expect(:buttons_pressed_down, nil, [])

		@main_menu.update

		@main_menu.controller.verify
	end

	def test_update_controller_is_nil
		@main_menu.controller = nil

		assert_nothing_raised do 
			@main_menu.update
		end
	end

end
