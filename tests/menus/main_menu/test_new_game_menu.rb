
require 'test/unit'
require 'minitest/mock'

require 'game_window'
require 'constants'

require 'menus/main_menu/root_menu'
require 'menus/main_menu/new_game_menu'

require_relative 'new_game_menu_extension'
require_relative '../../gui/button_extension'

class NewGameMenuTester < Test::Unit::TestCase

	def setup
		@window = MiniTest::Mock.new
		mock_user_messages(@window)

		@main = MiniTest::Mock.new
		@main.expect(:window, @window, [])

		@root_menu = MiniTest::Mock.new

		@menu = NewGameMenu.new(@main)
		@menu.parent = @root_menu
	end

	def test_create_back_button
		menu = @menu.send(:create_back_button, 0, 0)
		assert(menu.is_a? Button)
	end

	def test_create_start_button
		new_game = @menu.send(:create_start_button, 0, 0)
		assert(new_game.is_a? Button)
	end

	def test_create_start_button_call_callback
		new_game = @menu.send(:create_start_button, 0, 0)
		callback = new_game.callbacks[:release]

		@window.expect(:state=, nil, [PlayState])

		callback.call

		@window.verify
	end
	
	def test_create_start_button_call_callback_not_enough_players
		entries = @menu.instance_variable_get(:@entries)
		# Disable 3 out of 4 players
		disable_player_entries(entries, 3)

		new_game = @menu.send(:create_start_button, 0, 0)
		callback = new_game.callbacks[:release]

		callback.call
	end

	def test_std_player_names
		oracle = ["Player1", "Player2", "Player3", "Player4"]
		names = @menu.send(:std_player_names)
		assert_equal(oracle, names)
	end

	def test_create_player_options
		oracle_len = Constants::MAX_PLAYERS
		@menu.entries = []
		@menu.send(:create_player_options)

		assert_equal(oracle_len, @menu.entries.length)
		@menu.entries.each do |ent|
			assert(ent.is_a? PlayerEntry)
		end
	end

	def test_create_player_options_have_same_x_value
		@menu.entries = []
		@menu.send(:create_player_options)

		@menu.entries.each do |lhs|
			@menu.entries.each do |rhs|
				assert_equal(lhs.x, rhs.x)
			end
		end
	end

	def test_create_player_options_have_different_y_values
		@menu.entries = []
		@menu.send(:create_player_options)

		@menu.entries.each do |lhs|
			@menu.entries.each do |rhs|
				if !(lhs.equal? rhs)
					assert_not_equal(lhs.y, rhs.y)
				end
			end
		end
	end

	def test_entries_to_players
		oracle_len = Constants::MAX_PLAYERS
		players = @menu.send(:entries_to_players)

		assert_equal(oracle_len, @menu.entries.length)
		players.each do |player|
			assert(player.is_a? Player)
		end
	end

	def test_std_player_colours_length
		colours = @menu.send(:std_player_colours)
		assert(Constants::MAX_PLAYERS <= colours.length)
	end

	def test_std_player_colours_type
		colours = @menu.send(:std_player_colours)
		colours.each do |colour|
			assert(colour.is_a? Gosu::Color)
		end
	end

	def test_ready_to_start_default_players_enabled
		assert @menu.send(:ready_to_start?)
	end

	def test_ready_to_start_two_players_enabled
		entries = @menu.instance_variable_get(:@entries)
		# Disable 2 out of 4 players
		disable_player_entries(entries, 2)
		assert @menu.send(:ready_to_start?)
	end

	def test_ready_to_start_one_player_enabled
		entries = @menu.instance_variable_get(:@entries)
		# Disable 3 out of 4 players
		disable_player_entries(entries, 3)
		assert !@menu.send(:ready_to_start?)
	end

	def test_ready_to_start_two_players_with_same_name
		entries = @menu.instance_variable_get(:@entries)
		entries[1] = entries[0].dup
		assert !@menu.send(:ready_to_start?)
	end

	def test_names_are_unique
		entries = @menu.instance_variable_get(:@entries)
		assert @menu.send(:names_are_unique?, entries)
	end

	def test_names_are_unique_one_duplication
		entries = @menu.instance_variable_get(:@entries)
		entries[1] = entries[0].dup
		assert !@menu.send(:names_are_unique?, entries)
	end


private

	def disable_player_entries(entries, num)
		for k in 0...num
			entries[k].enabled=false
		end
	end

	def mock_user_messages(window)
		msgs = MiniTest::Mock.new
		msgs.expect(:message, "Dummy Text", [Symbol])
		msgs.expect(:keyname, "Dummy Text", [Symbol])
		window.expect(:user_messages, msgs, [])
	end

end

