
require 'test/unit'
require 'minitest/mock'

require 'game_window'

require_relative 'game_window_extension'

class GameWindowTester < Test::Unit::TestCase

	def setup
		@window = GameWindow.new
	end

	def test_user_messages_is_set
		assert_not_nil @window.user_messages
	end

	def test_button_down
		@window.state = MiniTest::Mock.new
		@window.state.expect(:button_down, nil, [Fixnum])

		@window.button_down(40)

		@window.state.verify
	end

	def test_button_up
		@window.state = MiniTest::Mock.new
		@window.state.expect(:button_up, nil, [Fixnum])

		@window.button_up(40)

		@window.state.verify
	end

	def test_update
		@window.state = MiniTest::Mock.new
		@window.state.expect(:update, nil, [])

		@window.update

		@window.state.verify
	end

	def test_draw
		@window.state = MiniTest::Mock.new
		@window.state.expect(:draw, nil, [])

		@window.draw

		@window.state.verify
	end

	def test_draw_last_redraw_is_updated
		@window.state = MiniTest::Mock.new
		@window.state.expect(:draw, nil, [])

		start_time = Gosu::milliseconds - (GameWindow::MAX_SKIP_TIME + 100)
		@window.last_redraw = start_time

		@window.draw

		@window.state.verify

		assert( start_time < @window.last_redraw )
		assert( @window.last_redraw <= Gosu::milliseconds)
	end

	def test_needs_redraw_state_needs_redraw
		@window.state = MiniTest::Mock.new
		@window.state.expect(:needs_redraw?, true, [])

		assert @window.needs_redraw?
		@window.state.verify
	end

	def test_needs_redraw_state_does_not_need_redraw
		@window.state = MiniTest::Mock.new
		@window.state.expect(:needs_redraw?, false, [])

		assert !@window.needs_redraw?
		@window.state.verify
	end

	def test_needs_redraw_state_does_not_need_redraw_exeeded_skip_time
		@window.state = MiniTest::Mock.new
		@window.state.expect(:needs_redraw?, false, [])

		@window.last_redraw = Gosu::milliseconds - 
								(GameWindow::MAX_SKIP_TIME + 100)

		assert @window.needs_redraw?
		@window.state.verify
	end

	def test_max_skip_time_exeeded_true
		@window.last_redraw = Gosu::milliseconds - 
								(GameWindow::MAX_SKIP_TIME + 100)

		assert @window.send(:max_skip_time_exceeded?)
	end

	def test_max_skip_time_exeeded_false
		assert !@window.send(:max_skip_time_exceeded?)
	end

	def test_default_show_cursor
		assert !@window.show_cursor
	end

	def test_needs_cursor_default
		assert !@window.needs_cursor?
	end

	def test_needs_cursor_set_true
		@window.show_cursor = true
		assert @window.needs_cursor?
	end

	def test_text_input_writer_nil_argument_assigned_non_nil_previously
		arg = Gosu::TextInput.new
		@window.text_input = arg

		@window.text_input = nil

		assert_equal(arg, @window.text_input)
	end

	def test_text_input_writer_nil_argument
		@window.text_input = Gosu::TextInput.new
		@window.send(:clear_text_input_assign)

		arg = nil
		@window.text_input = arg

		assert_equal(nil, @window.text_input)
	end

	def test_text_input_writer_nonnil_argument
		arg = Gosu::TextInput.new
		@window.text_input = arg
		assert(arg.equal?(@window.text_input))
	end

	def test_clear_text_input_assign_non_nil_value
		@window.last_assigned_ti = Gosu::TextInput.new
		@window.send(:clear_text_input_assign)
		assert_equal(nil, @window.last_assigned_ti)
	end

	def test_clear_text_input_assign_nil_value
		@window.send(:clear_text_input_assign)
		assert_equal(nil, @window.last_assigned_ti)
	end

	def test_update_text_input_assign_history_reset
		@window.state = MiniTest::Mock.new
		@window.state.expect(:update, nil, [])

		@window.text_input = Gosu::TextInput.new
		@window.update

		assert_equal(nil, @window.last_assigned_ti)
	end

end

