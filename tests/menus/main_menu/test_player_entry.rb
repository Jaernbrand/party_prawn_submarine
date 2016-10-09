
require 'test/unit'
require 'minitest/mock'

require 'gosu'

require 'menus/main_menu/player_entry'

require 'messages/message_dictionary'
require 'messages/english'

require 'control_mapper'
require 'player'

require_relative 'player_entry_extension'

class PlayerEntryTester < Test::Unit::TestCase

	def setup
		@fake_window = MiniTest::Mock.new
		setup_fake_window_user_messages

		@fake_main = MiniTest::Mock.new
		@fake_main.expect(:window, @fake_window, [])

		@fake_text_input = MiniTest::Mock.new
		@player_name = "Player1"
		@colour = Gosu::Color::RED
		@controls = ControlMapper.new.controls()[0]
		controls_parent = MiniTest::Mock.new
		@entry = PlayerEntry.new(@fake_window, 
								 @fake_main,
								 @fake_text_input, 
								 @player_name, 
								 @colour, 
								 @controls,
								 controls_parent)
	end

	def test_default_x
		assert_equal(0, @entry.x)
	end

	def test_default_y
		assert_equal(0, @entry.y)
	end

	def test_set_x
		value = 5
		@entry.x = value
		assert_equal(value, @entry.x)
	end

	def test_set_y
		value = 5
		@entry.y = value
		assert_equal(value, @entry.y)
	end

	def test_enabled_reader
		assert @entry.enabled
	end

	def test_enabled_writer
		@entry.enabled = false
		assert !@entry.enabled
	end

	def test_create_enable_player
		enable_box = @entry.send(:create_enable_player, true)
		assert(enable_box.is_a? Checkbox)
	end

	def test_create_enable_player_enable_true
		enable_box = @entry.send(:create_enable_player, true)
		assert enable_box.checked
	end

	def test_create_enable_player_enable_false
		enable_box = @entry.send(:create_enable_player, false)
		assert !enable_box.checked
	end

	def test_create_player_name
		enable_box = @entry.send(:create_player_name, 
								 @player_name, 
								 @fake_text_input)
		assert(enable_box.is_a? TextPane)
	end

	def test_create_player_colour
		enable_box = @entry.send(:create_player_colour, true)
		assert(enable_box.is_a? Label)
	end

	def test_create_player_controls
		controls_parent = MiniTest::Mock.new
		controls_button = @entry.send(:create_player_controls, 
									  @controls, 
									  controls_parent)
		assert(controls_button.is_a? Button)
	end

	def test_create_player_controls_controls_menu_is_added
		controls_parent = MiniTest::Mock.new
		controls_button = @entry.send(:create_player_controls, 
									  @controls, 
									  controls_parent)
		assert(controls_button.controls_menu.is_a? Menu)
	end

	def test_create_player_controls_callback_is_added
		controls_parent = MiniTest::Mock.new
		control_button = @entry.send(:create_player_controls, 
									 @controls, 
									 controls_parent)
		assert(control_button.is_a? Button)
	end

	def test_player_controls_callback_when_called
		ctrl_menu = MiniTest::Mock.new
		ctrl_menu.expect(:player_name=, nil, [String])

		@fake_main.expect(:current_menu=, nil, [ctrl_menu])

		button = MiniTest::Mock.new
		button.expect(:controls_menu, ctrl_menu, [])
		callable = @entry.send(:create_controls_button_callback, button)
		callable.call

		ctrl_menu.verify
		@fake_main.verify
	end

	def test_player_returns_player_object
		player = @entry.player
		assert(player.is_a? Player)
	end

	def test_player_name_is_set
		player = @entry.player
		assert_equal(@player_name, player.name)
	end

	def test_player_colour_is_set
		player = @entry.player
		assert_equal(@colour, player.colour)
	end

	def test_player_controls_is_set
		player = @entry.player
		assert_equal(@controls, player.controls)
	end

	def test_draw
		@entry.enable = MiniTest::Mock.new
		@entry.name = MiniTest::Mock.new
		@entry.colour = MiniTest::Mock.new
		@entry.controls = MiniTest::Mock.new


		@entry.enable.expect(:draw, nil, [])
		@entry.name.expect(:draw, nil, [])
		@entry.colour.expect(:draw, nil, [])
		@entry.controls.expect(:draw, nil, [])

		@entry.draw

		@entry.enable.verify
		@entry.name.verify
		@entry.colour.verify
		@entry.controls.verify
	end

	def test_update_enabled
		@entry.enable = MiniTest::Mock.new
		@entry.name = MiniTest::Mock.new
		@entry.colour = MiniTest::Mock.new
		@entry.controls = MiniTest::Mock.new


		@entry.enable.expect(:checked, true, [])

		@entry.enable.expect(:update, nil, [])
		@entry.name.expect(:update, nil, [])
		@entry.colour.expect(:update, nil, [])
		@entry.controls.expect(:update, nil, [])

		@entry.update

		@entry.enable.verify
		@entry.name.verify
		@entry.colour.verify
		@entry.controls.verify
	end

	def test_update_not_enabled
		@entry.enable = MiniTest::Mock.new
		@entry.name = MiniTest::Mock.new
		@entry.colour = MiniTest::Mock.new
		@entry.controls = MiniTest::Mock.new

		@entry.enable.expect(:update, nil, [])
		@entry.enable.expect(:checked, false, [])

		@entry.update

		@entry.enable.verify
	end

private

	def setup_fake_window_user_messages
		messages = MessageDictionary.new(English.messages, English.keynames)
		@fake_window.expect(:user_messages, messages, [])
	end

end

