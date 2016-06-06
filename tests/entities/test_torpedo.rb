
require 'test/unit'
require 'minitest/mock'

require 'entities/torpedo'
require 'game_window'

require_relative 'torpedo_extension'

class TorpedoTester < Test::Unit::TestCase

	TORPEDO_IMG_WIDTH = 112 # In pixels
	TORPEDO_IMG_HEIGHT = 21 # In pixels

	def setup
		@torpedo = Torpedo.new(0,0,0)
		Torpedo::img=nil
	end

	def test_create_torpedo
		x = 1
		y = 2
		angle = 45
		torp = Torpedo.new(x, y, angle)

		assert_equal(x, torp.x)
		assert_equal(y, torp.y)
		assert_equal(angle, torp.angle)
	end


	def test_move_0_deg
		oracle_x = Torpedo::STD_MOVE_SPEED
		oracle_y = 0

		@torpedo.move

		assert_equal(oracle_x, @torpedo.x)
		assert_equal(oracle_y, @torpedo.y)
	end

	def test_move_90_deg
		oracle_x = 0
		oracle_y = Torpedo::STD_MOVE_SPEED

		@torpedo.angle = 90
		@torpedo.move

		assert( (oracle_x - @torpedo.x).abs < 0.001 )
		assert( (oracle_y - @torpedo.y).abs < 0.001 )
	end

	def test_preload
		window = GameWindow.new
		Torpedo::preload(window)

		assert_not_nil(Torpedo::img)
	end

	def test_draw
		Torpedo::img = MiniTest::Mock.new

		player_colour = 0xff_ff0000

		@torpedo.player = MiniTest::Mock.new
		@torpedo.player.expect(:colour, player_colour, [])
		
		x = 0 
		y = 0
		angle = 0
		x_piv = 0.5
		y_piv = 0.5
		scale = 1
		args = [x, 
		  		y, 						
				Torpedo::TORPEDO_Z,
				angle,
				x_piv,
				y_piv,
				scale,
				scale,
				player_colour]
		Torpedo::img.expect(:draw_rot, nil, args)

		@torpedo.draw

		Torpedo::img.verify
		@torpedo.player.verify
	end

	def test_update_inside_bounds
		Torpedo::img = create_mock_img(TORPEDO_IMG_WIDTH, TORPEDO_IMG_HEIGHT)

		args = [Torpedo::STD_MOVE_SPEED, 
		  		0, 
				TORPEDO_IMG_WIDTH, 
				TORPEDO_IMG_HEIGHT]

		play_state = MiniTest::Mock.new
		play_state.expect(:outside_bounds?, false, args)

		@torpedo.game_state = play_state

		@torpedo.update

		play_state.verify
	end

	def test_update_outside_bounds
		Torpedo::img = create_mock_img(TORPEDO_IMG_WIDTH, TORPEDO_IMG_HEIGHT)

		args = [Torpedo::STD_MOVE_SPEED, 
		  		0, 
				TORPEDO_IMG_WIDTH, 
				TORPEDO_IMG_HEIGHT]

		play_state = MiniTest::Mock.new
		play_state.expect(:outside_bounds?, true, args)
		play_state.expect(:death_mark, nil, [@torpedo])

		@torpedo.game_state = play_state

		@torpedo.update

		play_state.verify
	end

	def test_needs_redraw_redrawing_needed_first_call
		assert(@torpedo.needs_redraw?)
	end

	def test_needs_redraw_redrawing_needed
		@torpedo.needs_redraw?
		@torpedo.move
		assert(@torpedo.needs_redraw?)
	end

	def test_needs_redraw_redrawing_not_needed
		@torpedo.needs_redraw?
		assert(!@torpedo.needs_redraw?)
	end

private

	def create_mock_img(width, height)
		img = MiniTest::Mock.new
		img.expect(:width, width, [])
		img.expect(:height, height, [])
		img
	end

end
