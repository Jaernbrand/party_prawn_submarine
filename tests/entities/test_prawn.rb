
require 'test/unit'
require 'minitest/mock'

require 'entities/prawn'
require 'game_window'

require_relative 'prawn_extension'

class PrawnTester < Test::Unit::TestCase

	def setup
		@prawn = Prawn.new(MiniTest::Mock.new, MiniTest::Mock.new)
		Prawn::tiles = nil
		Prawn::skins = nil
	end

	def test_preload
		Prawn::preload(GameWindow.new)
		assert_not_nil(Prawn::tiles)
		assert_not_nil(Prawn::skins)
		assert_not_nil(Prawn::swim_sound)
	end

	def test_update_party_horn_is_updated
		@prawn.party_horn = MiniTest::Mock.new

		@prawn.party_horn.expect(:x=, nil, [Numeric])
		@prawn.party_horn.expect(:y=, nil, [Numeric])
		@prawn.party_horn.expect(:angle=, nil, [Numeric])

		@prawn.party_horn.expect(:update, nil, [])

		@prawn.update

		@prawn.party_horn.verify
	end

	def test_update_swim_sound_is_played
		Prawn::swim_sound = MiniTest::Mock.new
		Prawn::swim_sound.expect(:play, nil, [])

		@prawn.swimming = true
		@prawn.prev_time = Gosu::milliseconds - 
							(Prawn::STD_ANIMATION_UPDATE_INTERVAL + 500)

		@prawn.party_horn = MiniTest::Mock.new
		@prawn.party_horn.expect(:x=, nil, [Numeric])
		@prawn.party_horn.expect(:y=, nil, [Numeric])
		@prawn.party_horn.expect(:angle=, nil, [Numeric])
		@prawn.party_horn.expect(:update, nil, [])

		@prawn.update

		Prawn::swim_sound.verify
	end

	def test_needs_redraw_not_swimming_party_horn_dont_need_redraw
		@prawn.swimming = false
		@prawn.party_horn = MiniTest::Mock.new
		@prawn.party_horn.expect(:needs_redraw?, false, [])

		assert(!@prawn.needs_redraw?)
	end

	def test_needs_redraw_not_swimming_party_horn_needs_redraw
		@prawn.swimming = false
		@prawn.party_horn = MiniTest::Mock.new
		@prawn.party_horn.expect(:needs_redraw?, true, [])

		assert(@prawn.needs_redraw?)
	end

	def test_needs_redraw_is_swimming_party_horn_dont_need_redraw
		@prawn.swimming = true
		@prawn.party_horn = MiniTest::Mock.new
		@prawn.party_horn.expect(:needs_redraw?, false, [])

		assert(@prawn.needs_redraw?)
	end

	def test_needs_redraw_swimming_party_horn_needs_redraw
		@prawn.swimming = true
		@prawn.party_horn = MiniTest::Mock.new
		@prawn.party_horn.expect(:needs_redraw?, true, [])

		assert(@prawn.needs_redraw?)
	end

	def test_draw
		@prawn.party_horn = MiniTest::Mock.new
		@prawn.party_horn.expect(:draw, nil, [])

		@prawn.player = MiniTest::Mock.new
		@prawn.player.expect(:colour, 0xff_ff0000, [])
		@prawn.player.expect(:z, 100, [])

		Prawn::tiles = MiniTest::Mock.new
		Prawn::skins = MiniTest::Mock.new

		fake_img = MiniTest::Mock.new
		fake_skin = MiniTest::Mock.new

		fake_img.expect(:draw_rot, nil, Array.new(4, Numeric))
		fake_skin.expect(:draw_rot, nil, Array.new(9, Numeric))

		Prawn::tiles.expect(:[], fake_img, [Numeric])
		Prawn::skins.expect(:[], fake_skin, [Numeric])

		@prawn.draw

		Prawn::tiles.verify
		Prawn::skins.verify
		fake_img.verify
		fake_skin.verify
	end

	def test_increment_tile_index_face_left_idx_start_at_two
		oracle = 1

		@prawn.tile_idx = 2
		@prawn.angle = 180

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_left_idx_start_at_one
		oracle = 2

		@prawn.tile_idx = 1
		@prawn.angle = 180

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_left_idx_start_at_zer0
		oracle = 1

		@prawn.tile_idx = 0
		@prawn.angle = 180

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_left_idx_start_at_three
		oracle = 2

		@prawn.tile_idx = 3
		@prawn.angle = 180

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_left_idx_start_at_four
		oracle = 1

		@prawn.tile_idx = 4
		@prawn.angle = 180

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_left_idx_start_at_five
		oracle = 2

		@prawn.tile_idx = 5
		@prawn.angle = 180

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_right_idx_start_at_zero
		oracle = 5

		@prawn.tile_idx = 0

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_right_idx_start_at_one
		oracle = 4

		@prawn.tile_idx = 1

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_right_idx_start_at_two
		oracle = 5

		@prawn.tile_idx = 2

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_right_idx_start_at_three
		oracle = 4

		@prawn.tile_idx = 3

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_right_idx_start_at_four
		oracle = 5

		@prawn.tile_idx = 4

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_increment_tile_index_face_right_idx_start_at_five
		oracle = 4

		@prawn.tile_idx = 5

		@prawn.send(:increment_swim_tile_index)
		assert_equal(oracle, @prawn.tile_idx)
	end

	def test_face_left_angle_0
		oracle = false
		@prawn.angle = 0
		assert_equal(oracle, @prawn.send(:face_left?))
	end

	def test_face_left_angle_90
		oracle = false
		@prawn.angle = 90
		assert_equal(oracle, @prawn.send(:face_left?))
	end

	def test_face_left_angle_91
		oracle = true
		@prawn.angle = 91
		assert_equal(oracle, @prawn.send(:face_left?))
	end

	def test_face_left_angle_180
		oracle = true
		@prawn.angle = 180
		assert_equal(oracle, @prawn.send(:face_left?))
	end

	def test_face_left_angle_269
		oracle = true
		@prawn.angle = 269
		assert_equal(oracle, @prawn.send(:face_left?))
	end

	def test_face_left_angle_270
		oracle = false
		@prawn.angle = 270
		assert_equal(oracle, @prawn.send(:face_left?))
	end

	def test_draw_angle_face_left
		oracle = 20
		@prawn.angle = 200
		face_left = true
		assert_equal(oracle, @prawn.send(:draw_angle, face_left))
	end

	def test_draw_angle_face_right
		oracle = 10
		@prawn.angle = 10
		face_left = false
		assert_equal(oracle, @prawn.send(:draw_angle, face_left))
	end

	def test_move_party_horn_face_right
		@prawn.party_horn = MiniTest::Mock.new
	
		# The prawn is currently placed at coordiante (0, 0)
		x = 3 * Prawn::TILE_WIDTH/4
		y = 3 * Prawn::TILE_HEIGHT/5
		angle = 0
		@prawn.party_horn.expect(:x=, nil, [x])
		@prawn.party_horn.expect(:y=, nil, [y])
		@prawn.party_horn.expect(:angle=, nil, [angle])

		@prawn.send(:move_party_horn)

		@prawn.party_horn.verify
	end

	def test_move_party_horn_face_left
		@prawn.party_horn = MiniTest::Mock.new
	
		# The prawn is currently placed at coordiante (0, 0)
		x = Prawn::TILE_WIDTH/4 - PartyHorn::PARTY_HORN_TILE_WIDTH
		y = 3 * Prawn::TILE_HEIGHT/5
		angle = 180

		@prawn.angle = angle

		@prawn.party_horn.expect(:x=, nil, [x])
		@prawn.party_horn.expect(:y=, nil, [y])
		@prawn.party_horn.expect(:angle=, nil, [angle])

		@prawn.send(:move_party_horn)

		@prawn.party_horn.verify
	end

end
