
require 'test/unit'
require 'minitest/mock'

require 'entities/explosion'
require 'game_window'

require_relative 'explosion_extension'

class ExplosionTester < Test::Unit::TestCase

	def setup
		Explosion::tiles = nil
		Explosion::explosion_sound = MiniTest::Mock.new
		Explosion::explosion_sound.expect(:play, nil, [])

		@fake_game_state = MiniTest::Mock.new
		@explosion = Explosion.new(0, 0)
		@explosion.game_state = @fake_game_state
	end

	def test_verify_sound_is_played
		Explosion::explosion_sound.verify
	end

	def test_verify_angle_is_zero
		oracle = 0
		assert_equal(oracle, @explosion.angle)
	end

	def test_preload
		Explosion::explosion_sound = nil

		window = GameWindow.new
		Explosion::preload(window)

		assert_not_nil(Explosion::tiles)
		assert_not_nil(Explosion::explosion_sound)
	end

	def test_update_animation_interval_not_passed
		@explosion.prev_time = Gosu::milliseconds
		assert_nothing_raised { @explosion.update }
	end

	def test_draw
		fake_img = MiniTest::Mock.new
		fake_img.expect(:draw, nil, [0, 0, Explosion::EXPLOSION_Z])

		Explosion::tiles = MiniTest::Mock.new
		Explosion::tiles.expect(:[], fake_img, [0])
		Explosion::tiles.expect(:length, 2, [])

		@explosion.draw
		
		Explosion::tiles.verify
		fake_img.verify
	end

	def test_update_frame_is_incremented
		oracle = 1

		Explosion::tiles = [MiniTest::Mock.new, MiniTest::Mock.new]

		@explosion.prev_time = Gosu::milliseconds - 
						(Explosion::STD_ANIMATION_UPDATE_INTERVAL - 500)

		@explosion.update

		assert_equal(oracle, @explosion.frame)
	end

	def test_update_changed_frame_is_set
		Explosion::tiles = [MiniTest::Mock.new, MiniTest::Mock.new]

		@explosion.prev_time = Gosu::milliseconds - 
						(Explosion::STD_ANIMATION_UPDATE_INTERVAL - 500)

		@explosion.update

		assert @explosion.changed_frame
	end

	def test_update_death_marked_when_last_frame_reached
		Explosion::tiles = [MiniTest::Mock.new, MiniTest::Mock.new]

		@explosion.prev_time = Gosu::milliseconds - 
						(Explosion::STD_ANIMATION_UPDATE_INTERVAL - 500)

		@explosion.frame = 1
		@explosion.game_state.expect(:death_mark, nil, [@explosion])
		@explosion.update

		@explosion.game_state.verify
	end

	def test_update_prev_time_is_updated
		start_time = Gosu::milliseconds - 
					Explosion::STD_ANIMATION_UPDATE_INTERVAL - 1

		@explosion.prev_time = start_time

		Explosion::tiles = [MiniTest::Mock.new, MiniTest::Mock.new]

		@explosion.update

		assert(@explosion.prev_time > start_time)
		assert(@explosion.prev_time <= Gosu::milliseconds)
	end

	def test_needs_redraw_changed_frame
		@explosion.changed_frame = true
		assert @explosion.needs_redraw?
	end

	def test_needs_redraw_not_changed_frame
		@explosion.changed_frame = false
		assert !@explosion.needs_redraw?
	end

	def test_draw_frame_greater_than_tiles_length
		Explosion::tiles = [MiniTest::Mock.new, MiniTest::Mock.new]
		@explosion.frame = 2

		assert_nothing_raised { @explosion.draw }
	end

	def test_draw_frame_less_than_tiles_length
		idx = 1

		Explosion::tiles = [MiniTest::Mock.new, MiniTest::Mock.new]
		@explosion.frame = idx
		Explosion::tiles[idx].expect(:draw, nil, [Numeric, Numeric, Numeric])

		@explosion.draw

		Explosion::tiles[idx].verify
		assert !@explosion.changed_frame
	end

end
