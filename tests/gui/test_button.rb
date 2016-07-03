
require 'test/unit'
require 'minitest/mock'

require 'gui/button'
require 'constants'

require_relative 'button_extension'

class ButtonTester < Test::Unit::TestCase

	def setup
		@text = "some text"
		@text_height = 20
		@button = Button.new(@text, @text_height, Constants::FONT_NAME)
	end

	def test_label_is_set
		assert_not_nil @button.label
	end

	def test_contains_coordinates_true
		x = 2
		y = 2
		assert @button.contains(x, y)
	end

	def test_contains_coordinates_false
		x = 300
		y = 300
		assert !@button.contains(x, y)
	end

end

