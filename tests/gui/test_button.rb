
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

end

