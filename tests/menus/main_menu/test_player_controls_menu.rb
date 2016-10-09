
require 'test/unit'
require 'minitest/mock'

require 'gosu'

require 'menus/main_menu/player_controls_menu'

require 'control_mapper'

class PlayerControlsMenuTester < Test::Unit::TestCase

	def setup
		@fake_window = MiniTest::Mock.new
		messages = MessageDictionary.new(English.messages, English.keynames)
		@fake_window.expect(:user_messages, messages, [])

		@fake_main = MiniTest::Mock.new
		@fake_main.expect(:window, @fake_window, [])

		@player_name = "Player1"
		@controls = ControlMapper.new.controls()[0]

		@menu = PlayerControlsMenu.new(@fake_main, @controls)
		@menu.player_name = @player_name

		@fake_parent = MiniTest::Mock.new
		@menu.parent = @fake_parent
	end

	def test_controls_is_set
		assert_equal @controls, @menu.controls
	end

	def test_components_are_created
		components = @menu.instance_variable_get(:@components)

		user_ctrl_quant = 6
		# Times 2 since each control gets two labels and plus one because of 
		# the back button
		comp_quant = user_ctrl_quant * 2 + 1
		assert components.size == comp_quant
	end

	def test_create_back_button_callback
		callback = @menu.send(:create_back_button_callback)
		assert(callback.is_a? Proc)
	end

	def test_call_back_button_callback
		@fake_main.expect(:current_menu=, nil, [Menu])
		callback = @menu.send(:create_back_button_callback)
		callback.call
	end

end

