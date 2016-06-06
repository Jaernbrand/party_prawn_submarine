
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
	end

	def test_update_party_horn_is_updated
		@prawn.party_horn = MiniTest::Mock.new

		@prawn.party_horn.expect(:update, nil, [])

		@prawn.update

		@prawn.party_horn.verify
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
		@prawn.player = MiniTest::Mock.new
		@prawn.player.expect(:colour, 0xff_ff0000, [])

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

end
