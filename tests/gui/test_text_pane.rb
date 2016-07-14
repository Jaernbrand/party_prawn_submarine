
require 'test/unit'
require 'minitest/mock'

require 'game_window'
require 'gui/text_pane'

require_relative 'text_pane_extension'
require_relative '../gosu_mocker'

class TextPaneTester < Test::Unit::TestCase

	include GosuMocker

	def setup
		@window = MiniTest::Mock.new

		@text_input = MiniTest::Mock.new

		@font_name = Gosu::default_font_name
		@text = "Some text"
		@text_height = 22
		@z = 50

		@text_pane = TextPane.new(@window, 
								  @text_input, 
								  @text, 
								  @text_height, 
								  @font_name, 
								  @z)
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

	def test_update_click_somewhere_else_not_in_focus
		x = 500
		y = 500

		mock_gosu
		begin
			Gosu.expect(:button_down?, false, [Fixnum])
			@window.expect(:mouse_x, x, [])
			@window.expect(:mouse_y, y, [])

			@text_pane.update

			assert(!@text_pane.in_focus)
		ensure
			restore_gosu
		end
	end

	def test_update_is_clicked_not_in_focus
		x = 2
		y = 2

		mock_gosu
		begin
			Gosu.expect(:button_down?, true, [Fixnum])
			@window.expect(:mouse_x, x, [])
			@window.expect(:mouse_y, y, [])

			@window.expect(:text_input=, nil, [@text_input]) 
			@text_input.expect(:text=, @text_pane.text, [String])
			@text_input.expect(:text, @text_pane.text, [])

			@text_pane.update

			assert(@text_pane.in_focus)
		ensure
			restore_gosu
		end
	end

	def test_update_not_in_focus
		pre_text = @text_pane.text

		@window.expect(:button_down?, false, [Fixnum])

		@text_pane.update

		assert_equal(pre_text, @text_pane.text)
	end

	def test_update_in_focus
		addition = " 123"
		oracle = addition

		@text_input.expect(:text, addition, [])
		@text_pane.in_focus = true

		@text_pane.update

		assert_equal(oracle, @text_pane.text)
	end

	def test_update_call_focus_first
		addition = " 123"
		oracle = @text + addition

		@window.expect(:text_input=, nil, [@text_input])
		@text_input.expect(:text=, nil, [String])

		@text_input.expect(:text, oracle, [])
		@text_pane.focus

		@text_pane.update

		assert_equal(oracle, @text_pane.text)
	end

	def test_update_click_somewhere_else_when_in_focus
		x = 500
		y = 500

		mock_gosu
		begin
			old_keys = TextPane.done_keys
			TextPane.done_keys = []

			Gosu.expect(:button_down?, true, [Fixnum])
			@window.expect(:mouse_x, x, [])
			@window.expect(:mouse_y, y, [])
			@window.expect(:text_input=, nil, [nil])
		
			@text_pane.in_focus = true

			@text_pane.update

			assert(!@text_pane.in_focus)
			@window.verify
		ensure
			restore_gosu
			TextPane.done_keys = old_keys
		end
	end

	def test_update_done_editing
		mock_gosu
		begin
			Gosu.expect(:button_down?, true, [Fixnum])
			@window.expect(:text_input=, nil, [nil])

			@text_pane.in_focus = true

			@text_pane.update

			assert(!@text_pane.in_focus)
			@window.verify
		ensure
			restore_gosu
		end
	end

	def test_update_reached_max_characters
		addition = " 123"
		oracle = @text + addition

		@text_input.expect(:text, oracle, [])

		@text_pane.in_focus = true

		mock_gosu
		begin
			old_keys = TextPane.done_keys
			@window.expect(:mouse_x, 50, [])
			@window.expect(:mouse_y, 50, [])
			Gosu.expect(:button_down?, false, [Fixnum])

			@text_pane.update

			assert_equal(oracle, @text_pane.text)
		ensure
			restore_gosu
			TextPane.done_keys = old_keys
		end
	end

	def test_done_editing_click_somewhere_else
		x = 500
		y = 500

		mock_gosu
		begin
			old_keys = TextPane.done_keys
			TextPane.done_keys = []

			@window.expect(:mouse_x, x, [])
			@window.expect(:mouse_y, y, [])

			Gosu.expect(:button_down?, true, [Fixnum])

			@text_pane.in_focus = true

			assert @text_pane.send(:done_editing?)
			@window.verify
		ensure
			restore_gosu
			TextPane.done_keys = old_keys
		end
	end

	def test_done_editing_enter_pressed
		enter_key = Gosu::KbEnter

		mock_gosu
		begin
			old_keys = TextPane.done_keys
			TextPane.done_keys = old_keys.select do |key|
				key == enter_key
			end

			Gosu.expect(:button_down?, true, [enter_key])

			@text_pane.in_focus = true

			assert @text_pane.send(:done_editing?)
		ensure
			restore_gosu
			TextPane.done_keys = old_keys
		end
	end

	def test_done_editing_return_pressed
		enter_key = Gosu::KbReturn

		mock_gosu
		begin
			old_keys = TextPane.done_keys
			TextPane.done_keys = old_keys.select do |key|
				key == enter_key
			end

			Gosu.expect(:button_down?, true, [enter_key])

			@text_pane.in_focus = true

			assert @text_pane.send(:done_editing?)
		ensure
			restore_gosu
			TextPane.done_keys = old_keys
		end
	end

	def test_update_text
		addition = " 123"
		oracle = @text + addition

		@text_input.expect(:text, oracle, [])
		@text_pane.send(:update_text)

		assert_equal(oracle, @text_pane.text)
	end

	def test_update_text_max_characters_not_reached
		@text_pane.max_length = @text.length + 10

		addition = " 123"
		oracle = @text + addition

		@text_input.expect(:text, @text + addition, [])
		@text_input.expect(:text=, nil, [@text])
		@text_pane.send(:update_text)

		assert_equal(oracle, @text_pane.text)
	end

	def test_update_text_reached_max_characters
		@text_pane.max_length = @text.length

		addition = " 123"
		oracle = @text

		@text_input.expect(:text, @text + addition, [])
		@text_input.expect(:text=, nil, [@text])
		@text_pane.send(:update_text)

		assert_equal(oracle, @text_pane.text)
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

	def test_bg_width_change_when_text_is_set
		old_width = @text_pane.bg_width

		new_text = @text + "1"
		@text_pane.text = new_text

		assert(old_width < @text_pane.bg_width)
	end

	def test_contains_do_contain_point
		x = 2
		y = 2
		assert(@text_pane.contains(x, y))
	end

	def test_contains_does_not_contain_point
		x = 500
		y = 500
		assert(!@text_pane.contains(x, y))
	end

	def test_focus_is_false_when_initialised
		assert(!@text_pane.in_focus)
	end

	def test_focus
		@window.expect(:text_input=, nil, [@text_input])
		@text_input.expect(:text=, nil, [String])

		@text_pane.focus

		assert(@text_pane.in_focus)
		@window.verify
		@text_input.verify
	end

	def test_unfocus
		@window.expect(:text_input=, nil, [nil])
		@text_pane.unfocus

		assert(!@text_pane.in_focus)
		@window.verify
	end

end

