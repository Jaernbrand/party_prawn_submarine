
require 'test/unit'
require 'minitest/mock'

require 'constants'
require 'gui/text_component'

require_relative 'text_component_extension'

class TextComponentTester < Test::Unit::TestCase

	include GosuMocker

	def setup
		@text = "some text"
		@text_height = 20
		@comp = TextComponent.new(@text, @text_height, Constants::FONT_NAME)
	end

	def test_text_is_set
		assert_equal(@text, @comp.text)
	end

	def test_text_height_is_set
		assert_equal(@text_height, @comp.text_height)
	end

	def test_font_name_is_set
		assert_equal(Constants::FONT_NAME, @comp.font_name)
	end

	def test_default_text_colour_is_set
		oracle = Gosu::Color::WHITE
		assert_equal(oracle, @comp.text_colour)
	end

	def test_default_background_colour_is_set
		oracle = Gosu::Color::BLACK
		assert_equal(oracle, @comp.background_colour)
	end

	def test_default_x_is_set
		oracle = 0
		assert_equal(oracle, @comp.x)
	end

	def test_default_y_is_set
		oracle = 0
		assert_equal(oracle, @comp.y)
	end

	def test_default_z_is_set
		oracle = 0
		assert_equal(oracle, @comp.z)
	end

	def test_bg_width_is_nil
		assert_equal(nil, @comp.bg_width)
	end

	def test_bg_height_std_value
		oracle = @text_height + 2
		assert_equal(oracle, @comp.bg_height)
	end

	def test_update
		assert_nothing_raised { @comp.update }
	end

	def test_draw_background
		bg_width = 18
		@comp.bg_width = bg_width

		args = [0, # Default x
				0, # Default y
				bg_width,
				@text_height + 2,
				Gosu::Color::BLACK, # Default background colour
				0] # Default z
		mock_gosu
		begin
			Gosu.expect(:draw_rect, nil, args)
			@comp.send(:draw_background)
			Gosu.verify
		ensure
			restore_gosu
		end
	end

end

