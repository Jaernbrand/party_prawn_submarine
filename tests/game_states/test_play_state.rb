
require 'test/unit'
require 'minitest/mock'

require 'game_states/play_state'
require 'player'

require_relative 'play_state_extension'

class PlayStateTester < Test::Unit::TestCase

	WIDTH = 320
	HEIGHT = 240

	def setup
		@play_state = PlayState.new(MiniTest::Mock.new)
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

	def test_outside_bounds_x_inside_w_outside
		x = WIDTH - 20
		y = 20
		w = WIDTH + 20
		h = 40
		outside = @play_state.outside_bounds?(x, y, w, h)
		assert(!outside)
	end

	def test_outside_bounds_y_inside_h_outside
		x = 20
		y = HEIGHT - 20
		w = 40
		h = HEIGHT + 20
		outside = @play_state.outside_bounds?(x, y, w, h)
		assert(!outside)
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
		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, false, [])

		entity = MiniTest::Mock.new
		entity.expect(:update, nil, [])
		entity.expect(:game_state=, nil, [@play_state])
		entity.expect(:overlaps?, false, [entity])

		@play_state.add_entity(entity)
		@play_state.update

		entity.verify
	end

	def test_update_multiple_entities
		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, false, [])

		entities = []

		num = 4
		(0...num).each do |i|
			entities[i] = MiniTest::Mock.new
			entities[i].expect(:update, nil, [])
			entities[i].expect(:game_state=, nil, [@play_state])
			entities[i].expect(:overlaps?, false, [Object])
			@play_state.add_entity(entities[i])
		end

		@play_state.update

		entities.each do |ent|
			ent.verify
		end
	end

	def test_update_controller_called
		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, false, [])

		@play_state.update

		@play_state.controller.verify
	end

	def test_update_game_over_game_over_prompt_is_set
		pair = [Gosu::KbSpace, Object]

		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])
		@play_state.controller.expect(:add_button_down_callback, nil, pair)

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, true, [])

		@play_state.window = GameWindow.new

		@play_state.update

		assert_not_nil @play_state.game_over_prompt
	end

	def test_update_game_over_boolean_changed
		pair = [Gosu::KbSpace, Object]

		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])
		@play_state.controller.expect(:add_button_down_callback, nil, pair)

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, true, [])

		@play_state.window = GameWindow.new

		@play_state.update

		assert @play_state.game_over_is_ready
	end

	def test_update_game_over_game_over_not_init_more_than_once
		pair = [Gosu::KbSpace, Object]

		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])
		@play_state.controller.expect(:add_button_down_callback, nil, pair)

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, true, [])

		@play_state.window = GameWindow.new

		@play_state.update

		@play_state.controller.verify
	end

	def test_update_game_over
		pair = [Gosu::KbSpace, Object]

		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])
		@play_state.controller.expect(:add_button_down_callback, nil, pair)

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, true, [])

		@play_state.window = GameWindow.new

		@play_state.update

		@play_state.controller.verify
	end

	def test_update_judge_called_not_game_over
		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, false, [])

		@play_state.update

		@play_state.judge.verify
	end

	def test_update_judge_called_game_over
		pair = [Gosu::KbSpace, Object]

		@play_state.controller = MiniTest::Mock.new
		@play_state.controller.expect(:buttons_pressed_down, nil, [])
		@play_state.controller.expect(:add_button_down_callback, nil, pair)

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, true, [])

		@play_state.window = GameWindow.new

		@play_state.update

		@play_state.judge.verify
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
		entity.expect(:is_a?, false, [Class])

		@play_state.all_entities = [entity]
		@play_state.death_mark(entity)
		@play_state.send(:remove_marked)

		assert_equal(oracle_rm_length, @play_state.rm_marked.length)
		assert_equal(oracle_ent_length, @play_state.all_entities.length)
	end

	def test_remove_marked_has_removed_set
		entity = MiniTest::Mock.new
		entity.expect(:equal?, true, [entity])
		entity.expect(:is_a?, false, [Class])

		@play_state.all_entities = [entity]
		@play_state.death_mark(entity)
		@play_state.send(:remove_marked)

		assert(@play_state.has_removed)
	end

	def test_remove_marked_submarine
		fake_player = MiniTest::Mock.new

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:died, nil, [fake_player])

		entity = MiniTest::Mock.new
		entity.expect(:equal?, true, [entity])
		entity.expect(:is_a?, true, [Class])
		entity.expect(:player, fake_player, [])

		@play_state.all_entities = [entity]
		@play_state.death_mark(entity)
		@play_state.send(:remove_marked)

		assert(@play_state.has_removed)
	end

	def test_remove_marked_has_removed_not_set_when_nothing_to_remove
		@play_state.all_entities = []
		@play_state.send(:remove_marked)

		assert(!@play_state.has_removed)
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

	def test_needs_redraw_has_removed_entity
		@play_state.has_removed = true
		assert(@play_state.needs_redraw?)
	end

	def test_needs_redraw_has_removed_is_reset
		@play_state.has_removed = true
		@play_state.needs_redraw?
		assert(!@play_state.has_removed)
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

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, false, [])

		@play_state.draw
		
		entity.verify
	end

	def test_draw_background_is_drawn
		setup_img_mock_draw_background

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, false, [])

		@play_state.draw

		PlayState::img.verify
	end

	def test_draw_background
		setup_img_mock_draw_background

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, false, [])

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

	def detect_collisions_one_entity_no_overlap
		fake_entity = MiniTest::Mock.new
		# Should not overlap with itself.
		fake_entity.expect(:overlaps?, false, [fake_entity])

		@play_state.all_entities = [fake_entity]
		@play_state.send(:detect_collisions)

		fake_entity.verify
	end

	def detect_collisions_one_entity_overlaps
		fake_entity = MiniTest::Mock.new
		fake_entity.expect(:overlaps?, true, [fake_entity])
		fake_entity.expect(:collision?, nil, [fake_entity])

		@play_state.all_entities = [fake_entity]
		@play_state.send(:detect_collisions)

		fake_entity.verify
	end

	def test_draw_show_winner_called_when_game_over
		setup_img_mock_draw_background

		player = Player.new('Player1')
		player.colour = 0xff_ff0000

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, true, [])
		@play_state.judge.expect(:winner, player, [])

		@play_state.window = GameWindow.new

		begin
			@play_state.draw
		rescue RuntimeError
			# Font.draw in @play_state.win_msg will likely throw an exception 
			# since there there is no rendering queue.
		end

		assert_not_nil(@play_state.win_msg)
	end

	def test_show_winner_nil_winner
		@play_state.window = GameWindow.new

		assert_equal(nil, @play_state.win_msg)

		begin
			@play_state.send(:show_winner, nil)
		rescue RuntimeError
			# Font.draw in @play_state.win_msg will likely throw an exception 
			# since there there is no rendering queue.
		end

		oracle = "No one won."
		assert_equal(oracle, @play_state.win_msg.text)
	end

	def test_show_winner_player_winner
		@play_state.window = GameWindow.new

		player = Player.new('Player1')

		assert_equal(nil, @play_state.win_msg)

		begin
			@play_state.send(:show_winner, player)
		rescue RuntimeError
			# Font.draw in @play_state.win_msg will likely throw an exception 
			# since there there is no rendering queue.
		end

		oracle = "The winner is Player1!"
		assert_equal(oracle, @play_state.win_msg.text)
	end

	def test_show_winner_win_msg_already_set
		@play_state.win_msg = MiniTest::Mock.new
		@play_state.win_msg.expect(:draw, nil, [])
		@play_state.win_msg.expect(:!, false, [])

		@play_state.send(:show_winner, nil)

		@play_state.win_msg.verify
	end

	def test_create_win_message_nil_winner
		@play_state.window = GameWindow.new

		oracle = "No one won."
		resp = @play_state.send(:create_win_message, nil)
		assert_equal(oracle, resp.text)
	end

	def test_create_win_message_player_winner
		@play_state.window = GameWindow.new

		player = Player.new('Player1')

		oracle = "The winner is Player1!"
		resp = @play_state.send(:create_win_message, player)
		assert_equal(oracle, resp.text)
	end

	def test_create_game_over_prompt
		@play_state.window = GameWindow.new

		resp = @play_state.send(:create_game_over_prompt)

		oracle = "Press Space to return to menu."
		assert_equal(oracle, resp.text)
	end

	def test_game_over_init
		@play_state.controller = MiniTest::Mock.new
		add_args = [Gosu::KbSpace, Object]
		@play_state.controller.expect(:add_button_down_callback, nil, add_args)

		@play_state.window = GameWindow.new

		@play_state.send(:game_over_init)

		@play_state.controller.verify
		assert_not_nil(@play_state.game_over_prompt)
	end

	def test_game_over_prompt_is_drawn
		@play_state.window = GameWindow.new

		entity = MiniTest::Mock.new
		entity.expect(:draw, nil, [])
		@play_state.all_entities = [entity]

		player = Player.new("Hugo")

		@play_state.judge = MiniTest::Mock.new
		@play_state.judge.expect(:game_over?, true, [])
		@play_state.judge.expect(:winner, player, [])

		@play_state.game_over_prompt = MiniTest::Mock.new
		@play_state.game_over_prompt.expect(:draw, nil, [])

		@play_state.win_msg = MiniTest::Mock.new
		@play_state.win_msg.expect(:!, false, [])
		@play_state.win_msg.expect(:draw, nil, [])

		@play_state.draw
		
		@play_state.game_over_prompt.verify
	end


private

	def setup_img_mock_draw_background
		PlayState::img = MiniTest::Mock.new
		PlayState::img.expect(:draw, nil, [Numeric, Numeric, Numeric])
		PlayState::img.expect(:width, WIDTH/2, [])
		PlayState::img.expect(:height, HEIGHT/2, [])
	end

end
