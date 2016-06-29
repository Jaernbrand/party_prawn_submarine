
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

end

