
require 'test/unit'
require 'minitest/mock'

require 'gui/label'
require 'constants'

require_relative '../gosu_mocker'
require_relative 'label_extension'

class LabelTester < Test::Unit::TestCase

	include GosuMocker

	def setup
		@text = "some text"
		@text_height = 20
		@label = Label.new(@text, @text_height, Constants::FONT_NAME)
	end

	def test_create_text
		img = @label.send(:create_text_content, 
						   @text, 
						   @text_height, 
						   Constants::FONT_NAME)
		assert(img.is_a? Gosu::Image)
	end

	def test_bg_width_is_set
		assert_not_nil @label.bg_width
	end

	def test_draw
		img_args = [1, # Default x
			 		1, # Default y
					0, # Default z
			 		1, # Default scale_x
			 		1, # Default scale_y
					Gosu::Color::WHITE] # Default text colour
		@label.img = MiniTest::Mock.new
		@label.img.expect(:draw, nil, img_args)

		bg_width = 18
		@label.bg_width = bg_width

		bg_args = [0, # Default x
			 		0, # Default y
					bg_width,
					@text_height + 2,
					Gosu::Color::BLACK, # Default background colour
					0] # Default z
		mock_gosu
		begin
			Gosu.expect(:draw_rect, nil, bg_args)
			
			@label.draw

			@label.img.verify
		ensure
			restore_gosu
		end
	end

	def test_contains_coordinates_true
		x = 2
		y = 2
		assert @label.contains(x, y)
	end

	def test_contains_coordinates_false
		x = 300
		y = 300
		assert !@label.contains(x, y)
	end

	def test_default_bg_margin
		oracle = 2
		assert_equal(oracle, Label::bg_margin)
	end

end

