
require 'test/unit'
require 'minitest/mock'

require 'entities/explosion'
require 'game_window'

require_relative 'explosion_extension'

class ExplosionTester < Test::Unit::TestCase

	def setup
		@fake_game_state = MiniTest::Mock.new
		@explosion = Explosion.new(0, 0, @fake_game_state)
		Explosion::tiles = nil
		Explosion::explosion_sound = nil
	end

	def test_preload
		window = GameWindow.new
		Explosion::preload(window)

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

		@explosion.draw
		
		Explosion::tiles.verify
		fake_img.verify
	end

	def test_update_sound_is_played
		Explosion::explosion_sound = MiniTest::Mock.new
		Explosion::explosion_sound.expect(:play, nil, [])

		@explosion.prev_time = Gosu::milliseconds - 
						(Explosion::STD_ANIMATION_UPDATE_INTERVAL - 500)

		@explosion.update

		Explosion::explosion_sound.verify
	end

	def test_update_sound_prev_time_is_updated
		Explosion::explosion_sound = MiniTest::Mock.new
		Explosion::explosion_sound.expect(:play, nil, [])

		start_time = Gosu::milliseconds - 
					Explosion::STD_ANIMATION_UPDATE_INTERVAL - 1

		@explosion.prev_time = start_time

		@explosion.update

		assert(@explosion.prev_time > start_time)
		assert(@explosion.prev_time <= Gosu::milliseconds)
	end

end
