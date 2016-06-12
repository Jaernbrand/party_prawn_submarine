
require 'test/unit'
require 'minitest/mock'

require 'controller'

require_relative 'controller_extension'

class ControllerTester < Test::Unit::TestCase

	def setup
		@tmp_gosu = Gosu
		Object.send(:remove_const, :Gosu)
		Object.const_set(:Gosu, MiniTest::Mock.new)
	end

	def teardown
		Object.send(:remove_const, :Gosu)
		Object.const_set(:Gosu, @tmp_gosu)
	end

	def test_add_button_down
		bt_down = MiniTest::Mock.new
		controller = Controller.new(bt_down, 
									MiniTest::Mock.new, 
									MiniTest::Mock.new)

		id = 40
		fake_value = MiniTest::Mock.new

		bt_down.expect(:[]=, id, [id, fake_value])
		controller.add_button_down_callback(id, fake_value)

		bt_down.verify
	end

	def test_remove_button_down
		bt_down = MiniTest::Mock.new
		controller = Controller.new(bt_down, 
									MiniTest::Mock.new, 
									MiniTest::Mock.new)

		id = 40

		bt_down.expect(:delete, id, [id])
		controller.remove_button_down_callback(id)

		bt_down.verify
	end


	def test_add_button_up
		bt_up = MiniTest::Mock.new
		controller = Controller.new(MiniTest::Mock.new, 
									bt_up, 
									MiniTest::Mock.new)

		id = 40
		fake_value = MiniTest::Mock.new

		bt_up.expect(:[]=, id, [id, fake_value])
		controller.add_button_up_callback(id, fake_value)

		bt_up.verify
	end

	def test_remove_button_up
		bt_up = MiniTest::Mock.new
		controller = Controller.new(MiniTest::Mock.new, 
									bt_up, 
									MiniTest::Mock.new)

		id = 40

		bt_up.expect(:delete, id, [id])
		controller.remove_button_up_callback(id)

		bt_up.verify
	end

	def test_button_down_with_existing_key
		id = 40
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])

		bt_down = {id => fake_callback}
		controller = Controller.new(bt_down, 
									MiniTest::Mock.new, 
									MiniTest::Mock.new)

		controller.button_down(id)

		fake_callback.verify
	end

	def test_button_down_with_non_existing_key
		id = 40
		bt_down = MiniTest::Mock.new
		bt_down.expect(:[], nil, [id])
		controller = Controller.new(bt_down, 
									MiniTest::Mock.new, 
									MiniTest::Mock.new)

		controller.button_down(id)

		bt_down.verify
	end
	
	def test_button_up_with_existing_key
		id = 40
		fake_callback = MiniTest::Mock.new
		bt_up = {id => fake_callback}

		fake_callback.expect(:call, nil, [])

		controller = Controller.new(MiniTest::Mock.new, 
									bt_up, 
									MiniTest::Mock.new)

		controller.button_up(id)

		fake_callback.verify
	end

	def test_button_up_with_non_existing_key
		id = 40
		bt_up = MiniTest::Mock.new
		bt_up.expect(:[], nil, [id])
		controller = Controller.new(MiniTest::Mock.new, 
									bt_up, 
									MiniTest::Mock.new)

		controller.button_up(id)

		bt_up.verify
	end

	def test_add_button_held
		bt_held = MiniTest::Mock.new
		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new,
								   	bt_held)

		id = 40
		fake_value = MiniTest::Mock.new

		bt_held.expect(:[]=, id, [id, fake_value])
		controller.add_button_held_callback(id, fake_value)

		bt_held.verify
	end

	def test_remove_button_held
		bt_held = MiniTest::Mock.new
		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new,
								   	bt_held)

		id = 40

		bt_held.expect(:delete, id, [id])
		controller.remove_button_held_callback(id)

		bt_held.verify
	end

	def test_button_held_with_existing_key
		id = 40
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])

		bt_held = {id => fake_callback}
		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new, 
									bt_held)

		controller.send(:button_held, id)

		fake_callback.verify
	end

	def test_button_held_with_non_existing_key
		id = 40
		bt_held = MiniTest::Mock.new
		bt_held.expect(:[], nil, [id])
		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new, 
									bt_held)

		controller.send(:button_held, id)

		bt_held.verify
	end

	def test_buttons_pressed_one_key
		id = 40
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])

		bt_held = {id => fake_callback}
		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new, 
									bt_held)

		Gosu.expect(:button_down?, true, [id])

		controller.prev_pressed << id
		controller.buttons_pressed_down

		fake_callback.verify
	end

	def test_buttons_pressed_multiple_keys
		all_ids = [40, 41, 42, 43, 44]
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])
		bt_held = {}

		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new, 
									bt_held)

		Gosu.expect(:button_down?, true, [Numeric])

		all_ids.each do |id|
			bt_held[id] = fake_callback
			controller.prev_pressed << id
		end

		controller.buttons_pressed_down

		fake_callback.verify
	end

	def test_buttons_pressed_empty_previous_pressed
		bt_held = MiniTest::Mock.new
		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new, 
									bt_held)

		controller.buttons_pressed_down

		bt_held.verify
	end

	def test_prev_pressed_starts_empty
		oracle = 0
		controller = Controller.new
		assert_equal(oracle, controller.prev_pressed.length)
	end

	def test_button_down_add_to_previously
		oracle = 1
		id = 40
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])

		bt_down = {id => fake_callback}
		controller = Controller.new(bt_down, 
									MiniTest::Mock.new, 
									MiniTest::Mock.new)

		controller.button_down(id)
		assert_equal(oracle, controller.prev_pressed.length)
	end

	def test_button_held_add_to_previously
		oracle = 1
		id = 40
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])

		bt_held = {id => fake_callback}
		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new, 
									bt_held)

		controller.send(:button_held, id)
		assert_equal(oracle, controller.prev_pressed.length)
	end

	def test_held_button_without_callback_not_readded_to_previously
		oracle = 0
		id = 40
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])

		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new, 
									{})

		controller.send(:button_held, id)
		assert_equal(oracle, controller.prev_pressed.length)
	end

	def test_previously_pressed_is_renewed
		oracle = 0
		id = 40
		fake_callback = MiniTest::Mock.new
		fake_callback.expect(:call, nil, [])

		bt_held = {id => fake_callback}
		controller = Controller.new(MiniTest::Mock.new, 
									MiniTest::Mock.new, 
									bt_held)

		Gosu.expect(:button_down?, false, [id])

		controller.prev_pressed << id
		controller.buttons_pressed_down

		assert_equal(oracle, controller.prev_pressed.length)
	end

end

