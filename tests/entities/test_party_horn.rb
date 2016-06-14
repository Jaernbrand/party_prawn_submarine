
require 'test/unit'
require 'minitest/mock'

require 'entities/party_horn'
require 'game_window'

require_relative 'party_horn_extension'

class PartyHornTester < Test::Unit::TestCase

	def setup
		@party_horn = PartyHorn.new
		PartyHorn::tiles = nil
		PartyHorn::sound = nil
	end

	def test_preload
		PartyHorn::preload(GameWindow.new)
		assert_not_nil(PartyHorn::tiles)
		assert_not_nil(PartyHorn::sound)
	end

	def test_draw_is_blown_faces_right
		@party_horn.is_blown = true
		PartyHorn::tiles = MiniTest::Mock.new
		fake_img = MiniTest::Mock.new

		args = [0, # x
				0, # y
				PartyHorn::PARTY_HORN_Z,
				0] # angle
		fake_img.expect(:draw_rot, nil, args)

		idx = 1
		PartyHorn::tiles.expect(:[], fake_img, [idx])

		@party_horn.draw

		fake_img.verify
		PartyHorn::tiles.verify
	end

	def test_draw_is_blown_faces_left
		@party_horn.is_blown = true
		
		angle = 180
		@party_horn.angle = angle

		PartyHorn::tiles = MiniTest::Mock.new
		fake_img = MiniTest::Mock.new

		args = [0, # x
				0, # y
				PartyHorn::PARTY_HORN_Z,
				180 - angle] # Because of the face_left adjustment
		fake_img.expect(:draw_rot, nil, args)

		idx = 0
		PartyHorn::tiles.expect(:[], fake_img, [idx])

		@party_horn.draw

		fake_img.verify
		PartyHorn::tiles.verify
	end

	def test_draw_is_not_blown
		assert_nothing_raised do
			@party_horn.draw
		end
	end

	def test_needs_redraw_has_changed
		@party_horn.has_changed = true
		assert(@party_horn.needs_redraw?)
	end

	def test_needs_redraw_has_not_changed
		@party_horn.has_changed = false
		assert(!@party_horn.needs_redraw?)
	end

	def test_update_not_blown
		assert_nothing_raised do
			@party_horn.draw
		end
	end

	def test_update_is_blown_and_still_blowing
		@party_horn.is_blown = true
		@party_horn.start_time = Gosu::milliseconds

		@party_horn.update

		assert(@party_horn.is_blown)
	end

	def test_update_is_blown_and_blowing_is_done
		@party_horn.is_blown = true
		@party_horn.start_time = Gosu::milliseconds - 
								(PartyHorn::BLOW_DURATION + 500)

		@party_horn.update
		assert(!@party_horn.is_blown)
	end

	def test_blow
		PartyHorn.sound = MiniTest::Mock.new
		PartyHorn.sound.expect(:play, nil, [])

		@party_horn.blow
		assert(@party_horn.is_blown)
		PartyHorn.sound.verify
	end

	def test_blow_assign_start_time
		PartyHorn.sound = MiniTest::Mock.new
		PartyHorn.sound.expect(:play, nil, [])

		assert_equal(nil, @party_horn.start_time)
		@party_horn.blow
		assert(@party_horn.start_time.instance_of? Fixnum)
	end

	def test_face_left_angle_0
		oracle = false
		@party_horn.angle = 0
		assert_equal(oracle, @party_horn.send(:face_left?))
	end

	def test_face_left_angle_90
		oracle = false
		@party_horn.angle = 90
		assert_equal(oracle, @party_horn.send(:face_left?))
	end

	def test_face_left_angle_91
		oracle = true
		@party_horn.angle = 91
		assert_equal(oracle, @party_horn.send(:face_left?))
	end

	def test_face_left_angle_180
		oracle = true
		@party_horn.angle = 180
		assert_equal(oracle, @party_horn.send(:face_left?))
	end

	def test_face_left_angle_269
		oracle = true
		@party_horn.angle = 269
		assert_equal(oracle, @party_horn.send(:face_left?))
	end

	def test_face_left_angle_270
		oracle = false
		@party_horn.angle = 270
		assert_equal(oracle, @party_horn.send(:face_left?))
	end

	def test_draw_angle_face_left
		oracle = -20
		@party_horn.angle = 200
		face_left = true
		assert_equal(oracle, @party_horn.send(:draw_angle, face_left))
	end

	def test_draw_angle_face_right
		oracle = 10
		@party_horn.angle = 10
		face_left = false
		assert_equal(oracle, @party_horn.send(:draw_angle, face_left))
	end

end
