
require 'test/unit'
require 'minitest/mock'

require 'gui/button'
require 'constants'

require_relative 'button_extension'
require_relative '../gosu_mocker'

class ButtonTester < Test::Unit::TestCase

	include GosuMocker

	def setup
		@fake_window = MiniTest::Mock.new
		@text = "some text"
		@text_height = 20
		@button = Button.new(@fake_window, 
							 @text, 
							 @text_height, 
							 Constants::FONT_NAME)
	end

	def test_label_is_set
		assert_not_nil @button.label
	end

	def test_contains_coordinates_true
		x = 2
		y = 2
		assert @button.contains(x, y)
	end

	def test_contains_coordinates_true_non_default_coordinate
		@button.x = 500
		@button.y = 500
		x = 502
		y = 502
		assert @button.contains(x, y)
	end

	def test_contains_coordinates_false
		x = 300
		y = 300
		assert !@button.contains(x, y)
	end

	def test_access_background_colour
		@button.background_colour = Gosu::Color::GRAY
		oracle = Gosu::Color::GRAY
		assert_equal(oracle, @button.background_colour)
	end

	def test_add_callback
		action = :down
		callable = Proc.new {}
		@button.add_callback(action, callable)
		assert @button.callbacks.key?(action)
	end

	def test_remove_callback
		action = :down
		callable = Proc.new {}

		@button.add_callback(action, callable)
		@button.remove_callback(action)

		assert !@button.callbacks.key?(action)
	end

	def test_update_button_does_not_contain_mouse
		@fake_window.expect(:mouse_x, 350)
		@fake_window.expect(:mouse_y, 350)

		@button.update

		@fake_window.verify
	end

	def test_update_button_down
		@fake_window.expect(:mouse_x, 5)
		@fake_window.expect(:mouse_y, 5)

		@button.pressed_previously = false

		called = false
		callable = Proc.new { called = true }

		@button.add_callback(:down, callable)

		mock_gosu
		begin
			Gosu.expect(:button_down?, true, [Numeric])
			@button.update

			assert called
		ensure
			restore_gosu
		end
	end
	
	def test_update_button_held
		@fake_window.expect(:mouse_x, 5)
		@fake_window.expect(:mouse_y, 5)

		@button.pressed_previously = true

		called = false
		callable = Proc.new { called = true }

		@button.add_callback(:held, callable)

		mock_gosu
		begin
			Gosu.expect(:button_down?, true, [Numeric])
			@button.update

			assert called
		ensure
			restore_gosu
		end
	end

	def test_update_button_released
		@fake_window.expect(:mouse_x, 5)
		@fake_window.expect(:mouse_y, 5)

		@button.pressed_previously = true

		called = false
		callable = Proc.new { called = true }

		@button.add_callback(:release, callable)

		mock_gosu
		begin
			Gosu.expect(:button_down?, false, [Numeric])
			@button.update

			assert called
		ensure
			restore_gosu
		end
	end

	def test_update_mouse_over
		@fake_window.expect(:mouse_x, 5)
		@fake_window.expect(:mouse_y, 5)

		@button.pressed_previously = false

		called = false
		callable = Proc.new { called = true }

		@button.add_callback(:mouse_over, callable)

		mock_gosu
		begin
			Gosu.expect(:button_down?, false, [Numeric])
			@button.update

			assert called
		ensure
			restore_gosu
		end
	end

	def test_mouse_over_callable_gets_called
		callable = MiniTest::Mock.new
		callable.expect(:call, nil, [])

		@button.add_callback(:mouse_over, callable)
		@button.send(:mouse_over)

		callable.verify
	end

	def test_down_callable_gets_called
		callable = MiniTest::Mock.new
		callable.expect(:call, nil, [])

		@button.add_callback(:down, callable)
		@button.send(:down)

		callable.verify
	end

	def test_held_callable_gets_called
		callable = MiniTest::Mock.new
		callable.expect(:call, nil, [])

		@button.add_callback(:held, callable)
		@button.send(:held)

		callable.verify
	end

	def test_release_callable_gets_called
		callable = MiniTest::Mock.new
		callable.expect(:call, nil, [])

		@button.add_callback(:release, callable)
		@button.send(:release)

		callable.verify
	end

	def test_draw
		@button.label = MiniTest::Mock.new
		@button.label.expect(:draw, nil, [])

		@button.draw

		@button.label.verify
	end

	def test_draw_background
		@button.label = MiniTest::Mock.new
		@button.label.expect(:draw_background, nil, [])

		@button.draw_background

		@button.label.verify
	end

	def test_mouse_over_no_callable
		assert_nothing_raised {
			@button.send(:mouse_over)
		}
	end

	def test_down_no_callable
		assert_nothing_raised {
			@button.send(:down)
		}
	end

	def test_held_no_callable
		assert_nothing_raised {
			@button.send(:held)
		}
	end

	def test_release_no_callable
		assert_nothing_raised {
			@button.send(:release)
		}
	end

	def test_default_x
		oracle = 0
		assert_equal(oracle, @button.x)
	end

	def test_default_y
		oracle = 0
		assert_equal(oracle, @button.y)
	end

	def test_set_x
		value = 51
		@button.x = value
		assert_equal(value, @button.x)
	end

	def test_set_y
		value = 51
		@button.y = value
		assert_equal(value, @button.y)
	end

	def test_mouse_over_pressed_gets_set
		callable = MiniTest::Mock.new
		callable.expect(:call, nil, [])

		@button.add_callback(:mouse_over, callable)
		@button.send(:mouse_over)

		assert !@button.pressed_previously
	end

	def test_down_pressed_gets_set
		callable = MiniTest::Mock.new
		callable.expect(:call, nil, [])

		@button.add_callback(:down, callable)
		@button.send(:down)

		assert @button.pressed_previously
	end

	def test_held_gets_set
		callable = MiniTest::Mock.new
		callable.expect(:call, nil, [])

		@button.add_callback(:held, callable)
		@button.send(:held)

		assert @button.pressed_previously
	end

	def test_release_gets_set
		callable = MiniTest::Mock.new
		callable.expect(:call, nil, [])

		@button.add_callback(:release, callable)
		@button.send(:release)

		assert !@button.pressed_previously
	end

end

