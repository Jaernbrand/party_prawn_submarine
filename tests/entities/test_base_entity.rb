
require 'test/unit'
require 'minitest/mock'

require 'entities/base_entity'

class BaseEntityTester < Test::Unit::TestCase

	def setup
		@entity = BaseEntity.new
	end

	def test_face_left_angle_0
		oracle = false
		@entity.angle = 0
		assert_equal(oracle, @entity.send(:face_left?))
	end

	def test_face_left_angle_90
		oracle = false
		@entity.angle = 90
		assert_equal(oracle, @entity.send(:face_left?))
	end

	def test_face_left_angle_91
		oracle = true
		@entity.angle = 91
		assert_equal(oracle, @entity.send(:face_left?))
	end

	def test_face_left_angle_180
		oracle = true
		@entity.angle = 180
		assert_equal(oracle, @entity.send(:face_left?))
	end

	def test_face_left_angle_269
		oracle = true
		@entity.angle = 269
		assert_equal(oracle, @entity.send(:face_left?))
	end

	def test_face_left_angle_270
		oracle = false
		@entity.angle = 270
		assert_equal(oracle, @entity.send(:face_left?))
	end

	def test_draw_angle_face_left
		oracle = -20
		@entity.angle = 200
		face_left = true
		assert_equal(oracle, @entity.send(:draw_angle, face_left))
	end

	def test_draw_angle_face_right
		oracle = 10
		@entity.angle = 10
		face_left = false
		assert_equal(oracle, @entity.send(:draw_angle, face_left))
	end

	def test_x_accessors
		new_x = 432
		@entity.x = new_x
		assert_equal(new_x, @entity.x)
	end

	def test_y_accessors
		new_y = 432
		@entity.y = new_y
		assert_equal(new_y, @entity.y)
	end

	def test_angle_accessors
		new_angle = 215
		@entity.angle = new_angle
		assert_equal(new_angle, @entity.angle)
	end

	def test_calculate_angle_wrap_around_positive
		oracle = 10
		@entity.angle = 350
		assert_equal(oracle, @entity.send(:calculate_angle, 20))
	end

	def test_calculate_angle_wrap_around_negative
		oracle = 350
		@entity.angle = 10
		assert_equal(oracle, @entity.send(:calculate_angle, -20))
	end

	def test_calculate_angle_negative_arg
		oracle = 160
		@entity.angle = 180
		assert_equal(oracle, @entity.send(:calculate_angle, -20))
	end

	def test_calculate_angle_positive_arg
		oracle = 200
		@entity.angle = 180
		assert_equal(oracle, @entity.send(:calculate_angle, 20))
	end

end

