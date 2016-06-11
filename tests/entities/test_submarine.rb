
require 'test/unit'
require 'minitest/mock'

require 'entities/submarine'
require 'game_window'

require_relative 'submarine_extension'

class SubmarineTester < Test::Unit::TestCase

	def setup
		prawn = MiniTest::Mock.new

		prawn.expect(:x=, nil, [0])
		prawn.expect(:y=, nil, [0])
		prawn.expect(:angle=, nil, [0])

		@sub = Submarine.new(0,0,0,prawn)
		@sub.prawn = MiniTest::Mock.new

		Submarine::tiles = nil
		Submarine::skins = nil
	end

	def test_create_submarine
		fake_prawn = MiniTest::Mock.new
		x = 1
		y = 2
		angle = 45

		fake_prawn.expect(:x=, nil, [x])
		fake_prawn.expect(:y=, nil, [y])
		fake_prawn.expect(:angle=, nil, [angle])

		sub = Submarine.new(x, y, angle, fake_prawn)

		assert_equal(x, sub.x)
		assert_equal(y, sub.y)
		assert_equal(angle, sub.angle)
		fake_prawn.verify
	end

	def test_adjust_towards_zero_number_gt_0
		oracle = 0.9

		number = 1
		adj = 0.1
		ret = @sub.send(:adjust_towards_zero, number, adj)

		error_margin = 1.0 / 100000
		assert( almost_equal(ret, oracle, error_margin) )
	end

	def test_adjust_towards_zero_number_lt_0
		oracle = -0.9

		number = -1
		adj = 0.1
		ret = @sub.send(:adjust_towards_zero, number, adj)

		error_margin = 1.0 / 100000
		assert( almost_equal(ret, oracle, error_margin) )
	end

	def test_adjust_towards_zero__number_almost_0
		oracle = 0

		number = 0.001
		adj = 0.1
		ret = @sub.send(:adjust_towards_zero, number, adj)

		error_margin = 1.0 / 100000
		assert( almost_equal(ret, oracle, error_margin) )
	end

	def test_adjust_towards_zero_number_is_0
		oracle = 0

		number = 0
		adj = 0.1
		ret = @sub.send(:adjust_towards_zero, number, adj)

		error_margin = 1.0 / 100000
		assert( almost_equal(ret, oracle, error_margin) )
	end

	def test_move_right_face_right
		oracle_x = Submarine::STD_SPEED_INCREASE_STEP
		oracle_y = 0
		oracle_angle = 0

		@sub.prawn.expect(:x, 0, [])
		@sub.prawn.expect(:x=, nil, [Submarine::STD_SPEED_INCREASE_STEP])

		@sub.move_right

		assert_equal(oracle_x, @sub.x)
		assert_equal(oracle_y, @sub.y)
		assert_equal(oracle_angle, @sub.angle)
	end

	def test_move_right_face_left
		oracle_x = Submarine::STD_SPEED_INCREASE_STEP
		oracle_y = 0
		oracle_angle = 0

		@sub.angle = 180

		@sub.prawn.expect(:x, 0, [])
		@sub.prawn.expect(:x=, nil, [Submarine::STD_SPEED_INCREASE_STEP])
		@sub.prawn.expect(:angle=, nil, [oracle_angle])

		@sub.move_right

		assert_equal(oracle_x, @sub.x)
		assert_equal(oracle_y, @sub.y)
		assert_equal(oracle_angle, @sub.angle)
	end

	def test_move_left_face_left
		oracle_x = -Submarine::STD_SPEED_INCREASE_STEP
		oracle_y = 0
		oracle_angle = 180

		@sub.angle = 180

		@sub.prawn.expect(:x, 0, [])
		@sub.prawn.expect(:x=, nil, [-Submarine::STD_SPEED_INCREASE_STEP])

		@sub.move_left

		assert_equal(oracle_x, @sub.x)
		assert_equal(oracle_y, @sub.y)
		assert_equal(oracle_angle, @sub.angle)
	end

	def test_move_left_face_right
		oracle_x = -Submarine::STD_SPEED_INCREASE_STEP
		oracle_y = 0
		oracle_angle = 180

		@sub.prawn.expect(:x, 0, [])
		@sub.prawn.expect(:x=, nil, [-Submarine::STD_SPEED_INCREASE_STEP])
		@sub.prawn.expect(:angle=, nil, [oracle_angle])

		@sub.move_left

		assert_equal(oracle_x, @sub.x)
		assert_equal(oracle_y, @sub.y)
		assert_equal(oracle_angle, @sub.angle)
	end

	def test_move_right_face_right_multi_steps
		number_of_steps = 3

		oracle_x = sum_interval(@sub.x,
					   Submarine::STD_SPEED_INCREASE_STEP,
					   number_of_steps,
					   @sub.max_speed)
		oracle_y = 0
		oracle_angle = 0

		setup_accessor_stub(@sub.prawn, "x")

		(0...number_of_steps).each do
			@sub.move_right
		end

		error_margin = 1.0 / 100000
		assert(almost_equal(oracle_x, @sub.x, error_margin))
		assert_equal(oracle_y, @sub.y)
		assert_equal(oracle_angle, @sub.angle)
	end

	def test_move_right_face_left_multi_steps
		number_of_steps = 3

		oracle_x = sum_interval(@sub.x,
					   Submarine::STD_SPEED_INCREASE_STEP, 
					   number_of_steps,
					   @sub.max_speed)
		oracle_y = 0
		oracle_angle = 0

		@sub.angle = 0

		setup_accessor_stub(@sub.prawn, "x")

		(0...number_of_steps).each do
			@sub.move_right
		end

		error_margin = 1.0 / 100000
		assert(almost_equal(oracle_x, @sub.x, error_margin))
		assert_equal(oracle_y, @sub.y)
		assert_equal(oracle_angle, @sub.angle)
	end

	def test_move_left_face_left_multi_steps
		number_of_steps = 3

		oracle_x = sum_interval(@sub.x,
					   -Submarine::STD_SPEED_INCREASE_STEP,
					   number_of_steps,
					   @sub.max_speed)
		oracle_y = 0
		oracle_angle = 180

		@sub.angle = 180

		setup_accessor_stub(@sub.prawn, "x")
		@sub.prawn.expect(:angle=, nil, [oracle_angle])

		(0...number_of_steps).each do
			@sub.move_left
		end

		error_margin = 1.0 / 100000
		assert(almost_equal(oracle_x, @sub.x, error_margin))
		assert_equal(oracle_y, @sub.y)
		assert_equal(oracle_angle, @sub.angle)
	end

	def test_move_left_face_right_multi_steps
		number_of_steps = 3

		oracle_x = sum_interval(@sub.x,
					   -Submarine::STD_SPEED_INCREASE_STEP,
					   number_of_steps,
					   @sub.max_speed)
		oracle_y = 0
		oracle_angle = 180

		setup_accessor_stub(@sub.prawn, "x")
		@sub.prawn.expect(:angle=, nil, [oracle_angle])

		(0...number_of_steps).each do
			@sub.move_left
		end

		error_margin = 1.0 / 100000
		assert(almost_equal(oracle_x, @sub.x, error_margin))
		assert_equal(oracle_y, @sub.y)
		assert_equal(oracle_angle, @sub.angle)
	end

	def test_move_right_reached_max_speed
		oracle_x = Submarine::STD_MAX_SPEED
		@sub.x_speed = Submarine::STD_MAX_SPEED

		@sub.prawn.expect(:x, 0, [])
		@sub.prawn.expect(:x=, nil, [Submarine::STD_MAX_SPEED])

		@sub.move_right

		assert_equal(oracle_x, @sub.x)
	end

	def test_move_left_reached_max_speed
		oracle_x = -Submarine::STD_MAX_SPEED
		@sub.x_speed = -Submarine::STD_MAX_SPEED

		@sub.angle = 180

		@sub.prawn.expect(:x, 0, [])
		@sub.prawn.expect(:x=, nil, [-Submarine::STD_MAX_SPEED])

		@sub.move_left

		assert_equal(oracle_x, @sub.x)
	end

	def test_move_up_reached_max_speed
		oracle_y = -Submarine::STD_MAX_SPEED
		@sub.y_speed = -Submarine::STD_MAX_SPEED

		@sub.prawn.expect(:y, 0, [])
		@sub.prawn.expect(:y=, nil, [Numeric])
		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.move_up

		assert_equal(oracle_y, @sub.y)
	end

	def test_move_down_reached_max_speed
		oracle_y = Submarine::STD_MAX_SPEED
		@sub.y_speed = Submarine::STD_MAX_SPEED

		@sub.prawn.expect(:y, 0, [])
		@sub.prawn.expect(:y=, nil, [Numeric])
		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.move_down

		assert_equal(oracle_y, @sub.y)
	end

	def test_stabilise_almost_plane_face_right
		oracle = 0
		@sub.angle = Submarine::STD_ROTATION_SPEED / 2.0

		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.stabilise

		assert_equal(oracle, @sub.angle)
	end

	def test_stabilise_almost_plane_face_left
		oracle = 180
		@sub.angle = Submarine::STD_ROTATION_SPEED / 2.0 + 180

		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.stabilise

		assert_equal(oracle, @sub.angle)
	end

	def test_stabilise_first_quadrant
		@sub.angle = 40
		oracle = @sub.angle - Submarine::STD_ROTATION_SPEED

		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.stabilise

		assert_equal(oracle, @sub.angle)
	end

	def test_stabilise_second_quadrant
		@sub.angle = 300
		oracle = @sub.angle + Submarine::STD_ROTATION_SPEED

		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.stabilise

		assert_equal(oracle, @sub.angle)
	end

	def test_stabilise_third_quadrant
		@sub.angle = 220
		oracle = @sub.angle - Submarine::STD_ROTATION_SPEED

		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.stabilise

		assert_equal(oracle, @sub.angle)
	end

	def test_stabilise_fourth_quadrant
		@sub.angle = 310
		oracle = @sub.angle + Submarine::STD_ROTATION_SPEED

		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.stabilise

		assert_equal(oracle, @sub.angle)
	end

	def test_stabilise_270_degrees
		@sub.angle = 270
		oracle = @sub.angle + Submarine::STD_ROTATION_SPEED

		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.stabilise

		assert_equal(oracle, @sub.angle)
	end

	def test_stabilise_90_degrees
		@sub.angle = 90
		oracle = @sub.angle + Submarine::STD_ROTATION_SPEED

		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.stabilise

		assert_equal(oracle, @sub.angle)
	end

	def test_torpedo_ready
		assert(@sub.send(:torpedo_ready?))
	end

	def test_torpedo_ready_not_ready
		@sub.torpedo_launched = Time.now + Submarine::STD_TORPEDO_RELOAD_TIME / 2
		assert(!@sub.send(:torpedo_ready?))
	end

	def test_fire_torpedo
		fake_tile = MiniTest::Mock.new
		fake_tile.expect(:width, 198, [])
		fake_tile.expect(:height, 135, [])

		Submarine::tiles = MiniTest::Mock.new
		Submarine::tiles.expect(:[], fake_tile, [0])

		play_state = MiniTest::Mock.new
		play_state.expect(:add_entity, nil, [Torpedo])

		@sub.game_state = play_state
		@sub.player = MiniTest::Mock.new

		before = Time.now
		@sub.send(:fire_torpedo)
		after = Time.now

		fake_tile.verify
		Submarine::tiles.verify
		play_state.verify
		assert(before <= @sub.torpedo_launched)
		assert(after >= @sub.torpedo_launched)
	end

	def test_drift_x_axis
		step = Submarine::STD_SPEED_INCREASE_STEP
		oracle_x_speed = Submarine::STD_MAX_SPEED - step
		oracle_x = @sub.x + oracle_x_speed

		@sub.x_speed = Submarine::STD_MAX_SPEED

		setup_accessor_stub(@sub.prawn, "x")

		@sub.drift

		assert_equal(oracle_x_speed, @sub.x_speed)
		assert_equal(oracle_x, @sub.x)
	end

	def test_drift_y_axis
		step = Submarine::STD_SPEED_INCREASE_STEP
		oracle_y_speed = Submarine::STD_MAX_SPEED - step
		oracle_y = @sub.y + oracle_y_speed

		@sub.y_speed = Submarine::STD_MAX_SPEED

		setup_accessor_stub(@sub.prawn, "y")

		@sub.drift

		assert_equal(oracle_y_speed, @sub.y_speed)
		assert_equal(oracle_y, @sub.y)
	end

	def test_preload
		window = GameWindow.new
		Submarine::preload(window)

		assert_not_nil(Submarine::tiles)
		assert_not_nil(Submarine::skins)
	end

	def test_draw
		Submarine::tiles = MiniTest::Mock.new
		Submarine::skins = MiniTest::Mock.new

		player_colour = 0xff_ff0000

		@sub.player = MiniTest::Mock.new
		@sub.player.expect(:colour, player_colour, [])

		fake_tile = MiniTest::Mock.new
		fake_skin = MiniTest::Mock.new

		x = 0 
		y = 0
		angle = 0
		centre = 0.5
		scale = 1
		skin_args = [x, 
		  		y, 						
				Submarine::SUB_Z,
				angle,
				centre,
				centre,
				scale,
				scale,
				player_colour]
		fake_tile.expect(:draw_rot, nil, [x, y, Submarine::SUB_Z, angle])
		fake_skin.expect(:draw_rot, nil, skin_args)

		idx = 1
		Submarine::tiles.expect(:[], fake_tile, [idx])
		Submarine::skins.expect(:[], fake_skin, [idx])

		@sub.has_moved = true
		@sub.prawn.expect(:draw, nil, [])

		@sub.draw

		Submarine::tiles.verify
		Submarine::skins.verify
		fake_tile.verify
		fake_skin.verify
		@sub.player.verify
		@sub.prawn.verify
	end

	def test_needs_redraw_redrawing_prawn_needs_redrawing
		@sub.prawn = MiniTest::Mock.new
		@sub.prawn.expect(:needs_redraw?, true, [])

		assert(@sub.needs_redraw?)
	end

	def test_needs_redraw_redrawing_has_moved
		@sub.prawn = MiniTest::Mock.new
		@sub.prawn.expect(:needs_redraw?, false, [])

		@sub.has_moved = true

		assert(@sub.needs_redraw?)
	end

	def test_needs_redraw_redrawing_not_needed
		@sub.prawn = MiniTest::Mock.new
		@sub.prawn.expect(:needs_redraw?, false, [])

		@sub.has_moved = false

		assert(!@sub.needs_redraw?)
	end

	def test_has_moved_set_move_up
		setup_accessor_stub(@sub.prawn, "y")
		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.move_up
		assert(@sub.has_moved)
	end
	
	def test_has_moved_set_move_down
		setup_accessor_stub(@sub.prawn, "y")
		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.move_down
		assert(@sub.has_moved)
	end

	def test_has_moved_set_move_left
		setup_accessor_stub(@sub.prawn, "x")
		@sub.prawn.expect(:angle=, nil, [Numeric])

		@sub.move_left
		assert(@sub.has_moved)
	end

	def test_has_moved_set_move_right
		setup_accessor_stub(@sub.prawn, "x")
		@sub.move_right
		assert(@sub.has_moved)
	end

	def test_draw_resets_has_moved
		Submarine::tiles = MiniTest::Mock.new
		Submarine::skins = MiniTest::Mock.new

		player_colour = 0xff_ff0000

		@sub.player = MiniTest::Mock.new
		@sub.player.expect(:colour, player_colour, [])

		fake_tile = MiniTest::Mock.new
		fake_skin = MiniTest::Mock.new

		x = 0 
		y = 0
		angle = 0
		centre = 0.5
		scale = 1
		skin_args = [x, 
		  		y, 						
				Submarine::SUB_Z,
				angle,
				centre,
				centre,
				scale,
				scale,
				player_colour]
		fake_tile.expect(:draw_rot, nil, [x, y, Submarine::SUB_Z, angle])
		fake_skin.expect(:draw_rot, nil, skin_args)

		idx = 1
		Submarine::tiles.expect(:[], fake_tile, [idx])
		Submarine::skins.expect(:[], fake_skin, [idx])

		@sub.prawn.expect(:draw, nil, [])

		@sub.draw
		assert(!@sub.has_moved)
	end

	def test_update_x
		@sub.prawn = MiniTest::Mock.new

		oracle_x = Submarine::STD_SPEED_INCREASE_STEP
		@sub.prawn.expect(:x, 0, [])
		@sub.prawn.expect(:x=, nil, [oracle_x])

		@sub.send(:update_x, Submarine::STD_SPEED_INCREASE_STEP)

		assert_equal(oracle_x, @sub.x)
		@sub.prawn.verify
	end

	def test_update_y
		@sub.prawn = MiniTest::Mock.new

		oracle_y = Submarine::STD_SPEED_INCREASE_STEP
		@sub.prawn.expect(:y, 0, [])
		@sub.prawn.expect(:y=, nil, [oracle_y])

		@sub.send(:update_y, Submarine::STD_SPEED_INCREASE_STEP)

		assert_equal(oracle_y, @sub.y)
		@sub.prawn.verify
	end

	def test_update_angle
		@sub.prawn = MiniTest::Mock.new

		oracle_angle = 45
		@sub.prawn.expect(:angle=, nil, [oracle_angle])

		@sub.send(:update_angle, oracle_angle)

		assert_equal(oracle_angle, @sub.angle)
		@sub.prawn.verify
	end

	def test_try_fire_torpedo
		fake_tile = MiniTest::Mock.new
		fake_tile.expect(:width, 198, [])
		fake_tile.expect(:height, 135, [])

		Submarine::tiles = MiniTest::Mock.new
		Submarine::tiles.expect(:[], fake_tile, [0])

		play_state = MiniTest::Mock.new
		play_state.expect(:add_entity, nil, [Torpedo])

		@sub.game_state = play_state
		@sub.player = MiniTest::Mock.new

		@sub.try_fire_torpedo

		play_state.verify
	end

	def test_try_fire_torpedo_not_reloaded
		launched = Time.now + Submarine::STD_TORPEDO_RELOAD_TIME / 2

		@sub.torpedo_launched = launched
		@sub.try_fire_torpedo
		assert_equal(launched, @sub.torpedo_launched)
	end

	def test_update_player_moved
		@sub.player_moved = true
		
		@sub.prawn.expect(:swimming=, true, [true])
		@sub.prawn.expect(:update, nil, [])

		@sub.update

		@sub.prawn.verify
		assert(!@sub.player_moved)
	end

	def test_update_player_not_moved_sub_is_plane
		start_x = 0
		@sub.player_moved = false

		setup_drift_x_mock

		@sub.prawn.expect(:swimming=, false, [false])
		@sub.prawn.expect(:update, nil, [])

		@sub.update

		@sub.prawn.verify
		assert(!@sub.player_moved)
	end

	def test_update_player_not_moved_sub_is_not_plane
		start_x = 0
		start_angle = 90
		@sub.player_moved = false

		setup_drift_x_mock
		setup_stabilise_mock(start_angle)

		@sub.prawn.expect(:swimming=, false, [false])
		@sub.prawn.expect(:update, nil, [])

		@sub.update

		assert_not_equal(start_x, @sub.x)
		assert_not_equal(start_angle, @sub.angle)
		@sub.prawn.verify
		assert(!@sub.player_moved)
	end

private
	
	def setup_drift_x_mock
		@sub.x_speed = Submarine::STD_MAX_SPEED
		setup_accessor_stub(@sub.prawn, "x")
	end

	def setup_stabilise_mock(angle)
		@sub.angle = angle
		@sub.prawn.expect(:angle=, nil, [Numeric])
	end

	def setup_accessor_stub(mock, attribute)
		mock.expect(attribute.to_sym, 0, [])
		mock.expect((attribute + "=").to_sym, nil, [Numeric])
	end

	def almost_equal(lhs, rhs, error)
		(lhs - rhs).abs <= error
	end

	def sum_interval(start, step, num_of_steps, max_speed)
		acc = start
		speed = 0
		(0...num_of_steps).each do
			if speed < max_speed
				speed += step
			end
			acc += speed
		end
		acc
	end

end
