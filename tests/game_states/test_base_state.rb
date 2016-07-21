
require 'test/unit'
require 'minitest/mock'

require 'game_states/base_state'

class BaseStateTester < Test::Unit::TestCase

	WIDTH = 320
	HEIGHT = 240

	def setup
		@base_state = BaseState.new
		@base_state.width = WIDTH
		@base_state.height = HEIGHT
	end

	def test_draw_background
		img = MiniTest::Mock.new
		img.expect(:draw, nil, [Numeric, Numeric, Numeric])
		img.expect(:width, WIDTH/2, [])
		img.expect(:height, HEIGHT/2, [])

		@base_state.send(:draw_background, img)

		img.verify
	end
	
	def test_update_controller_is_nil
		@base_state.controller = nil

		assert_nothing_raised do 
			@base_state.update
		end
	end

	def test_update_controller_called
		@base_state.controller = MiniTest::Mock.new
		@base_state.controller.expect(:buttons_pressed_down, nil, [])

		@base_state.update

		@base_state.controller.verify
	end

	def test_button_down
		id = 50

		@base_state.controller = MiniTest::Mock.new
		@base_state.controller.expect(:button_down, nil, [id])

		@base_state.button_down(id)

		@base_state.controller.verify
	end

	def test_button_up
		id = 50

		@base_state.controller = MiniTest::Mock.new
		@base_state.controller.expect(:button_up, nil, [id])

		@base_state.button_up(id)

		@base_state.controller.verify
	end

end
