
require 'test/unit'
require 'minitest/mock'

require 'gui/checkbox'
require 'constants'

require_relative 'checkbox_extension'
require_relative '../gosu_mocker'

class CheckboxTester < Test::Unit::TestCase

	include GosuMocker

	def setup
		@fake_window = MiniTest::Mock.new
		@size = 20
		@font_name = Constants::FONT_NAME
		@checkbox = Checkbox.new(@fake_window, @size, @font_name)
	end

	def test_default_checked
		assert !@checkbox.checked
	end

	def test_non_default_checked_is_set
		checkbox = Checkbox.new(@fake_window, @size, @font_name, true)
		assert checkbox.checked
	end

	def test_label_is_set
		assert_not_nil @checkbox.label
	end

	def test_contains_coordinates_true
		x = 2
		y = 2
		assert @checkbox.contains(x, y)
	end

	def test_contains_coordinates_true_non_default_coordinate
		@checkbox.x = 500
		@checkbox.y = 500
		x = 502
		y = 502
		assert @checkbox.contains(x, y)
	end

	def test_contains_coordinates_false
		x = 300
		y = 300
		assert !@checkbox.contains(x, y)
	end


	def test_update_checkbox_does_not_contain_mouse
		@fake_window.expect(:mouse_x, 350)
		@fake_window.expect(:mouse_y, 350)

		@checkbox.update

		@fake_window.verify
	end

	def test_update_clicked_somewhere_else
		@fake_window.expect(:mouse_x, 500)
		@fake_window.expect(:mouse_y, 500)

		assert_nothing_raised { @checkbox.update }
	end

	def test_update_checkbox_clicked
		@fake_window.expect(:mouse_x, 5)
		@fake_window.expect(:mouse_y, 5)

		mock_gosu
		begin
			Gosu.expect(:button_down?, true, [Numeric])
			@checkbox.update

			assert @checkbox.checked
		ensure
			restore_gosu
		end
	end

	def test_update_checkbox_clicked_when_checked
		@fake_window.expect(:mouse_x, 5)
		@fake_window.expect(:mouse_y, 5)

		mock_gosu
		begin
			Gosu.expect(:button_down?, true, [Numeric])

			@checkbox.checked = true
			@checkbox.update

			assert !@checkbox.checked
		ensure
			restore_gosu
		end
	end
	
	def test_draw_checked
		@checkbox.checked = true
		@checkbox.label = MiniTest::Mock.new
		@checkbox.label.expect(:draw, nil, [])

		@checkbox.draw

		@checkbox.label.verify
	end

	def test_draw_not_checked
		@checkbox.label = MiniTest::Mock.new
		@checkbox.label.expect(:draw_background, nil, [])

		@checkbox.draw

		@checkbox.label.verify
	end

	def test_default_x
		oracle = 0
		assert_equal(oracle, @checkbox.x)
	end

	def test_default_y
		oracle = 0
		assert_equal(oracle, @checkbox.y)
	end

	def test_set_x
		value = 51
		@checkbox.x = value
		assert_equal(value, @checkbox.x)
	end

	def test_set_y
		value = 51
		@checkbox.y = value
		assert_equal(value, @checkbox.y)
	end

end

