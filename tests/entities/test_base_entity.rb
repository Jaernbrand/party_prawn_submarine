
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
		oracle = 20
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

	def test_overlaps_with_itself
		set_entity_attributes(@entity, 60, 60, 20, 10, 0)

		assert !@entity.overlaps?(@entity)
	end

	def test_overlaps_does_overlap_both_plane
		other = BaseEntity.new

		set_entity_attributes(@entity, 60, 60, 20, 10, 0)
		set_entity_attributes(other, 65, 65, 20, 30, 0)

		assert @entity.overlaps?(other)
	end

	def test_overlaps_does_overlap_one_at_angle
		other = BaseEntity.new

		set_entity_attributes(@entity, 60, 60, 40, 10, 45)
		set_entity_attributes(other, 60, 60, 20, 30, 0)

		assert @entity.overlaps?(other)
	end

	def test_overlaps_does_not_overlap
		other = BaseEntity.new

		set_entity_attributes(@entity, 60, 60, 20, 10, 30)
		set_entity_attributes(other, 90, 60, 20, 10, 0)

		assert !@entity.overlaps?(other)
	end
	
	def test_collision
		other = MiniTest::Mock.new
		assert_nothing_raised { @entity.collision(other) }
	end

	def test_degrees_to_radians
		oracle = Math::PI

		radians = @entity.send(:degrees_to_radians, 180)

		assert((oracle - radians) <= 0.000001)
	end

	def test_circle_overlap_does_not_overlap
		other = BaseEntity.new

		set_entity_attributes(@entity, 50, 50, 10, 10, 45)
		set_entity_attributes(other, 70, 70, 10, 10, 0)

		assert !@entity.send(:circles_overlap?, other)
	end

	def test_circle_overlap_does_overlap
		other = BaseEntity.new

		set_entity_attributes(@entity, 65, 65, 10, 10, 45)
		set_entity_attributes(other, 70, 65, 10, 10, 0)

		assert @entity.send(:circles_overlap?, other)
	end

	def test_circle_overlap_just_touch
		other = BaseEntity.new

		set_entity_attributes(@entity, 60, 60, 10, 10, 0)
		set_entity_attributes(other, 70, 60, 10, 10, 0)

		assert @entity.send(:circles_overlap?, other)
	end

	def test_euclidiean_distance
		lhs = [1, 1]
		rhs = [3, 5]

		oracle = Math::sqrt((lhs[0] - rhs[0])**2 + (lhs[1] - rhs[1])**2)

		resp = @entity.send(:euclidean_distance, lhs, rhs)

		assert((oracle - resp).abs <= 0.000001)
	end

	def test_euclidiean_distance_length_not_equal
		lhs = [1, 2]
		rhs = [3]

		assert_raise RuntimeError do
			@entity.send(:euclidean_distance, lhs, rhs)
		end
	end

	def test_corners_plane_entity
		x = 60
		y = 60
		w = 20
		h = 10

		oracle = [OpenStruct.new(:x => x, :y => y), # Upper left
				OpenStruct.new(:x => x, :y => y + h), # Lower left
				OpenStruct.new(:x => x + w, :y => y), # Upper right
				OpenStruct.new(:x => x + w, :y => y + h)] # Lower right

		set_entity_attributes(@entity, x, y, w, h, 0)

		corners = @entity.send(:corners, @entity)

		assert_equal(corners.length, oracle.length)

		for i in 0...oracle.length
			assert_equal(corners[i].x, oracle[i].x)
			assert_equal(corners[i].y, oracle[i].y)
		end
	end

	def test_corners_non_plane_entity
		x = 60
		y = 60
		w = 20
		h = 10
		angle = 45

		set_entity_attributes(@entity, x, y, w, h, angle)
		oracle = create_corners(@entity)

		corners = @entity.send(:corners, @entity)

		assert_equal(corners.length, oracle.length)

		for i in 0...oracle.length
			assert_equal(corners[i].x, oracle[i].x)
			assert_equal(corners[i].y, oracle[i].y)
		end
	end

	def test_create_axes
		rect = [OpenStruct.new(:x => 60, :y => 60), # Upper left
				OpenStruct.new(:x => 60, :y => 70), # Lower left
				OpenStruct.new(:x => 80, :y => 60), # Upper right
				OpenStruct.new(:x => 80, :y => 70)] # Lower right

		axis1 = OpenStruct.new(:x => (rect[0].x - rect[1].x).abs,
							  :y => (rect[0].y - rect[1].y).abs)
		axis2 = OpenStruct.new(:x => (rect[0].x - rect[2].x).abs,
							  :y => (rect[0].y - rect[2].y).abs)
		oracle = [axis1, axis2]

		axes = []
		@entity.send(:create_axes, rect, axes)

		assert_equal(oracle.length, axes.length)

		for i in 0...oracle.length
			assert_equal(oracle[i].x, axes[i].x)
			assert_equal(oracle[i].y, axes[i].y)
		end
	end

	def test_project
		rect = [OpenStruct.new(:x => 60, :y => 60), # Upper left
				OpenStruct.new(:x => 60, :y => 70), # Lower left
				OpenStruct.new(:x => 80, :y => 60), # Upper right
				OpenStruct.new(:x => 80, :y => 70)] # Lower right

		axis = OpenStruct.new(:x => (rect[0].x - rect[1].x).abs, 
							 :y => (rect[0].y - rect[1].y).abs)

		oracle = []
		rect.each do |corner|
			proj = (axis.x * corner.x + axis.y * corner.y) / 
					(axis.x**2 + axis.y**2)
			proj_x = proj * axis.x
			proj_y = proj * axis.y

			oracle << proj_x * axis.x + proj_y * axis.y
		end

		scalars = @entity.send(:project, rect, axis)
		assert_equal(oracle.length, scalars.length)

		for i in 0...oracle.length
			assert((oracle[i] - scalars[i]).abs <= 0.0000001)
		end
	end

	def test_projections_overlap_does_overlap
		proj1 = [2, 3, 3, 4]
		proj2 = [3, 5, 6, 7]
		assert @entity.send(:projections_overlap, proj1, proj2)
	end

	def test_projections_overlap_does_not_overlap
		proj1 = [2, 3, 4, 5]
		proj2 = [6, 7, 8, 9]
		assert !@entity.send(:projections_overlap, proj1, proj2)
	end

	def test_rectangles_overlap_does_overlap
		other = BaseEntity.new

		set_entity_attributes(@entity, 60, 60, 20, 10, 0)
		set_entity_attributes(other, 70, 60, 20, 10, 0)

		assert @entity.send(:rectangles_overlap?, other)
	end

	def test_rectangles_overlap_does_not_overlap
		other = BaseEntity.new

		set_entity_attributes(@entity, 60, 60, 20, 10, 0)
		set_entity_attributes(other, 90, 60, 20, 10, 0)

		assert !@entity.send(:rectangles_overlap?, other)
	end

	def test_rectangles_overlap_does_overlap_at_angle
		other = BaseEntity.new

		set_entity_attributes(@entity, 60, 60, 20, 10, 45)
		set_entity_attributes(other, 63, 63, 20, 30, 0)

		assert @entity.send(:rectangles_overlap?, other)
	end

	def test_circle_overlap_does_overlap_at_angle
		other = BaseEntity.new

		set_entity_attributes(@entity, 60, 60, 20, 10, 45)
		set_entity_attributes(other, 65, 65, 20, 30, 0)

		assert @entity.send(:circles_overlap?, other)
	end

	def test_rotate_x_0_rotation
		x = 10
		y = 10
		sin = 0
		cos = 1
		assert_equal(x, @entity.send(:rotate_x, x, y, cos, sin))
	end

	def test_rotate_y_0_rotation
		x = 10
		y = 10
		sin = 0
		cos = 1
		assert_equal(y, @entity.send(:rotate_y, x, y, cos, sin))
	end

	def test_rotate_x_45_degrees
		x = 10
		y = 10
		sin = Math::sqrt(2)/2
		cos = Math::sqrt(2)/2

		oracle = cos * x  + sin * y

		assert oracle -  @entity.send(:rotate_x, x, y, cos, sin) <= 0.0000001
	end

	def test_rotate_y_45_degrees
		x = 10
		y = 10
		sin = Math::sqrt(2)/2
		cos = Math::sqrt(2)/2

		oracle = cos * y  - sin * x

		assert oracle -  @entity.send(:rotate_y, x, y, cos, sin) <= 0.0000001
	end

	def test_create_corner_0_rotation
		x = 10
		y = 10
		sin = 0
		cos = 1
		centre_x = 5
		centre_y = 5

		oracle_x = 10
		oracle_y = 10

		corner = @entity.send(:create_corner, x, y, cos, sin, centre_x, centre_y)

		assert_equal(oracle_x, corner.x)
		assert_equal(oracle_y, corner.y)
	end

	def test_create_corner_45_degrees
		x = 10
		y = 10
		sin = Math::sqrt(2)/2
		cos = Math::sqrt(2)/2
		centre_x = 5
		centre_y = 5

		oracle_x = (cos * (x - centre_x) + sin * (y - centre_y)) + centre_x
		oracle_y = (cos * (y - centre_y) - sin * (x - centre_x)) + centre_y

		corner = @entity.send(:create_corner, x, y, cos, sin, centre_x, centre_y)

		assert oracle_x - corner.x <= 0.0000001
		assert oracle_y - corner.y <= 0.0000001
	end


private

	def set_entity_attributes(entity, x, y, w, h, angle)
		entity.x = x
		entity.y = y
		entity.width = w
		entity.height = h
		entity.angle = angle
	end

	def create_corners(entity)
		corners = []

		angle = @entity.send(:degrees_to_radians, entity.angle())
		cos = Math::cos(angle)
		sin = Math::sin(angle)

		centre_x = entity.x + entity.width / 2.0
		centre_y = entity.y + entity.height / 2.0

		corners << create_corner(entity.x, 
									 entity.y, 
									 cos, 
									 sin, 
									 centre_x, 
									 centre_y)

		corners << create_corner(entity.x, 
									 entity.y + entity.height, 
									 cos, 
									 sin, 
									 centre_x, 
									 centre_y)

		corners << create_corner(entity.x + entity.width, 
									 entity.y, 
									 cos, 
									 sin, 
									 centre_x, 
									 centre_y)

		corners << create_corner(entity.x + entity.width, 
									 entity.y + entity.height, 
									 cos, 
									 sin, 
									 centre_x, 
									 centre_y)

		corners
	end

	def create_corner(x, y, cos, sin, centre_x, centre_y)
		corner = OpenStruct.new
		x -= centre_x
		y -= centre_y
		corner.x = rotate_x(x, y, cos, sin) + centre_x
		corner.y = rotate_y(x, y, cos, sin) + centre_y
		corner
	end

	def rotate_x(x, y, cos, sin)
		cos * x + sin * y
	end

	def rotate_y(x, y, cos, sin)
		cos * y - sin * x
	end

end

