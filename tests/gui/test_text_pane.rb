
require 'test/unit'
require 'minitest/mock'

require 'game_window'
require 'gui/text_pane'

require_relative 'text_pane_extension'

class TextPaneTester < Test::Unit::TestCase

	def setup
		@window = GameWindow.new

		@font_name = Gosu::default_font_name
		@text = "Some text"
		@text_height = 22
		@z = 50

		@text_pane = TextPane.new(@text, @text_height, @font_name, @z)
	end

	def test_default_background_colour
		oracle = Gosu::Color::BLACK
		assert_equal(oracle, @text_pane.background_colour)
	end

	def test_default_text_colour
		oracle = Gosu::Color::WHITE
		assert_equal(oracle, @text_pane.text_colour)
	end

	def test_font_is_set
		assert_not_nil @text_pane.font
	end

	def test_text_is_set
		oracle = @text
		assert_equal(oracle, @text_pane.text)
	end

	def test_z_is_set
		oracle = @z
		assert_equal(oracle, @text_pane.z)
	end

	def test_text_height_is_set
		oracle = @text_height
		assert_equal(oracle, @text_pane.font.height)
	end

	def test_update
		assert_nothing_raised { @text_pane.update }
	end

	def test_draw
		white = Gosu::Color::WHITE
		black = Gosu::Color::BLACK

		bg_width = @text_pane.font.text_width(@text) + 2
		bg_height = @text_height + 2

		mock_gosu
		begin
			@text_pane.font = MiniTest::Mock.new

			x = 0
			y = 0
			
			@text_pane.font.expect(:draw, nil, [@text,
									   			x+1, 
												y+1, 
												@z, 
												1, # scale_x
												1, # scale_y
												white])

			Gosu.expect(:draw_rect, nil, [x, y, bg_width, bg_height, black, @z])

			@text_pane.draw

			@text_pane.font.verify
			Gosu.verify

		ensure
			restore_gosu
		end
	end


private

	def mock_gosu
		@old_gosu = Gosu
		Object.send(:remove_const, :Gosu)
		Object.const_set(:Gosu, MiniTest::Mock.new)
	end

	def restore_gosu
		Object.send(:remove_const, :Gosu)
		Object.const_set(:Gosu, @old_gosu)
	end

end

