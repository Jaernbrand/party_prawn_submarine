
require 'test/unit'
require 'minitest/mock'

require 'game_states/play_state'

require_relative 'play_state_extension'

class PlayStateTester < Test::Unit::TestCase

	WIDTH = 320
	HEIGHT = 240

	def setup
		@play_state = PlayState.new
		@play_state.width = WIDTH
		@play_state.height = HEIGHT
	end

	def test_outside_bounds_inside	
		x = 40
		y = 30
		outside = @play_state.outside_bounds?(x, y)
		assert(!outside)
	end

	def test_outside_bounds_too_wide
		x = WIDTH + 40
		y = 30
		outside = @play_state.outside_bounds?(x, y)
		assert(outside)
	end

	def test_outside_bounds_too_long
		x = 40
		y = HEIGHT + 30
		outside = @play_state.outside_bounds?(x, y)
		assert(outside)
	end

	def test_outside_bounds_x_less_than_0
		x = -40
		y = 30
		outside = @play_state.outside_bounds?(x, y)
		assert(outside)
	end

	def test_outside_bounds_y_less_than_0
		x = 40
		y = -30
		outside = @play_state.outside_bounds?(x, y)
		assert(outside)
	end

	def test_outside_bounds_x_plus_w_less_than_0
		x = -40
		y = 30
		w = 20
		outside = @play_state.outside_bounds?(x, y, w)
		assert(outside)
	end

	def test_outside_bounds_y_plus_h_less_than_0
		x = 40
		y = -30
		w = 20
		h = 20
		outside = @play_state.outside_bounds?(x, y, w, h)
		assert(outside)
	end

	def test_add_entity
		oracle_ent_length = 1

		entity = MiniTest::Mock.new
		entity.expect(:game_state=, nil, [@play_state])
		
		@play_state.add_entity(entity)
		entity.verify

		assert_equal(oracle_ent_length, @play_state.all_entities.size)
	end

	def test_remove_entity
		oracle_ent_length = 0

		entity = MiniTest::Mock.new
		entity.expect(:game_state=, nil, [@play_state])
		entity.expect(:equal?, true, [entity])
		
		@play_state.add_entity(entity)
		removed = @play_state.remove_entity(entity)

		assert(entity.verify)
		assert_same(entity, removed)
		assert_equal(oracle_ent_length, @play_state.all_entities.size)
	end

	def test_remove_entity_non_existing
		entity = MiniTest::Mock.new
		removed = @play_state.remove_entity(entity)

		assert_nil(removed)
	end

	def test_update_one_entity
		entity = MiniTest::Mock.new
		entity.expect(:update, nil, [])
		entity.expect(:game_state=, nil, [@play_state])

		@play_state.add_entity(entity)
		@play_state.update

		entity.verify
	end

	def test_update_multiple_entities
		entities = []

		num = 4
		(0...num).each do |i|
			entities[i] = MiniTest::Mock.new
			entities[i].expect(:update, nil, [])
			entities[i].expect(:game_state=, nil, [@play_state])
			@play_state.add_entity(entities[i])
		end

		@play_state.update

		entities.each do |ent|
			ent.verify
		end
	end

	def test_death_mark
		oracle_length = 1
		entity = MiniTest::Mock.new

		@play_state.death_mark(entity)

		assert_equal(oracle_length, @play_state.rm_marked.length)
	end

	def test_remove_marked
		oracle_rm_length = 0
		oracle_ent_length = 0

		entity = MiniTest::Mock.new
		entity.expect(:equal?, true, [entity])

		@play_state.all_entities = [entity]
		@play_state.death_mark(entity)
		@play_state.remove_marked

		assert_equal(oracle_rm_length, @play_state.rm_marked.length)
		assert_equal(oracle_ent_length, @play_state.all_entities.length)
	end

	def test_needs_redraw_entities_dont_need_redraw
		entity = MiniTest::Mock.new
		entity.expect(:needs_redraw?, false, [])
		@play_state.all_entities = [entity]

		assert(!@play_state.needs_redraw?)
	end

	def test_needs_redraw_entities_need_redraw
		entity = MiniTest::Mock.new
		entity.expect(:needs_redraw?, true, [])
		@play_state.all_entities = [entity]

		assert(@play_state.needs_redraw?)
	end

	def test_needs_redraw_no_entities
		assert(!@play_state.needs_redraw?)
	end

	def test_preload
		PlayState::preload(GameWindow.new)

		assert_not_nil(PlayState::img)
	end

	def test_draw_entities_are_drawn
		entity = MiniTest::Mock.new
		entity.expect(:draw, nil, [])
		@play_state.all_entities = [entity]

		@play_state.draw
		
		entity.verify
	end

	def test_draw_background_is_drawn
		setup_img_mock_draw_background

		@play_state.draw

		PlayState::img.verify
	end

	def test_draw_background
		setup_img_mock_draw_background

		@play_state.draw

		PlayState::img.verify
	end

	def test_button_down
		id = 50

		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:button_down, nil, [id])

		@play_state.button_down(id)

		@play_state.controller.verify
	end

	def test_buttoon_up
		id = 50

		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:button_up, nil, [id])

		@play_state.button_up(id)

		@play_state.controller.verify
	end


private

	def setup_img_mock_draw_background
		PlayState::img = MiniTest::Mock.new
		PlayState::img.expect(:draw, nil, [Numeric, Numeric, Numeric])
		PlayState::img.expect(:width, WIDTH/2, [])
		PlayState::img.expect(:height, HEIGHT/2, [])
	end

end
