
require 'test/unit'
require 'minitest/mock'

require 'factories/game_controller_factory'

class GameControllerFactoryTester < Test::Unit::TestCase

	def setup
		@factory = GameControllerFactory.new
	end

	def test_create_controller_one_player
		fake_sub = MiniTest::Mock.new
		fake_sub.expect(:public_method, :method, [Symbol])

		fake_horn = MiniTest::Mock.new
		fake_horn.expect(:public_method, :method, [Symbol])

		fake_player = MiniTest::Mock.new
		fake_player.expect(:controls, create_player_buttons, [])
		fake_player.expect(:submarine, fake_sub, [])
		fake_player.expect(:party_horn, fake_horn, [])

		controller = @factory.create_controller(fake_player)

		assert(controller.instance_of? Controller)
	end

	def test_create_player_controls
		fake_sub = MiniTest::Mock.new
		fake_sub.expect(:public_method, :method, [Symbol])

		fake_horn = MiniTest::Mock.new
		fake_horn.expect(:public_method, :method, [Symbol])

		fake_player = MiniTest::Mock.new
		fake_player.expect(:controls, create_player_buttons, [])
		fake_player.expect(:submarine, fake_sub, [])
		fake_player.expect(:party_horn, fake_horn, [])

		fake_controller = MiniTest::Mock.new

		fake_controller.expect(:add_button_held_callback, nil, [Fixnum, Symbol])
		fake_controller.expect(:add_button_down_callback, nil, [Fixnum, Symbol])

		@factory.send(:create_player_controls, fake_controller, fake_player)

		fake_controller.verify
	end

	def test_party_horn_callbacks
		fake_horn = MiniTest::Mock.new

		method_ret = :method # Should be a method with non-mocks
		fake_horn.expect(:public_method, method_ret, [:blow])

		callbacks = @factory.send(:party_horn_callbacks, fake_horn)
		assert_equal(method_ret, callbacks[:blow_party_horn])
		fake_horn.verify
	end

	def test_submarine_callbacks
		fake_horn = MiniTest::Mock.new

		oracle_len = 5 
		fake_horn.expect(:public_method, :method, [Symbol])

		callbacks = @factory.send(:submarine_callbacks, fake_horn)

		fake_horn.verify
		assert_equal(oracle_len, callbacks.length)
	end

	def test_controller_add_held_callbacks
		fake_controller = MiniTest::Mock.new
		fake_controller.expect(:add_button_held_callback, nil, [Fixnum, Symbol])

		buttons = create_player_buttons
		callbacks = create_callbacks

		@factory.send(:controller_add_held_callbacks, 
					  fake_controller, 
					  buttons, 
					  callbacks)

		fake_controller.verify
	end

	def test_controller_add_down_callbacks
		fake_controller = MiniTest::Mock.new
		fake_controller.expect(:add_button_down_callback, nil, [Fixnum, Symbol])

		buttons = create_player_buttons
		callbacks = create_callbacks

		@factory.send(:controller_add_down_callbacks, 
					  fake_controller, 
					  buttons, 
					  callbacks)

		fake_controller.verify
	end

	def test_controller_add_up_callbacks
		fake_controller = MiniTest::Mock.new
		fake_controller.expect(:add_button_up_callback, nil, [Fixnum, Symbol])

		buttons = create_player_buttons
		callbacks = create_callbacks

		@factory.send(:controller_add_up_callbacks, 
					  fake_controller, 
					  buttons, 
					  callbacks)

		fake_controller.verify
	end


private
	
	def create_player_buttons
		{:up => Gosu::KbUp,
		:down => Gosu::KbDown,
		:left => Gosu::KbLeft,
		:right => Gosu::KbRight,
		:torpedo => Gosu::KbSpace,
		:blow_party_horn => Gosu::KbQ}
	end

	def create_callbacks
		{:up => :move_up,
		:down => :move_down,
		:left => :move_left,
		:right => :move_right,
		:torpedo => :try_fire_torpedo,
		:blow_party_horn => :blow}
	end

end

