
require 'gosu'

# Handles callbacks for button up and down events. The Controller also handles 
# callbacks for if buttons that are continuously pressed down. The callback 
# objects have to implement the method call. See Gosu's documentation for 
# button constants.
class Controller

	# Initialises a new Controller instance. The new object will use the given
	# Hash objects to store the pairs of button constants (key) and callable 
	# objects (value).
	#
	# * *Args*    :
	#   - <tt>Hash<Fixnum, callable></tt> +bt_down+ -> The Hash to store button down callbacks in
	#   - <tt>Hash<Fixnum, callable></tt> +bt_up+ -> The Hash to store button up callbacks in
	#   - <tt>Hash<Fixnum, callable></tt> +bt_up+ -> The Hash to store button held down callbacks in
	def initialize(bt_down = {}, bt_up = {}, bt_held = {})
		@bt_down = bt_down
		@bt_up = bt_up
		@bt_held = bt_held

		@prev_pressed = []
	end

	# Adds the given callback callable for the given key ID. The callable is 
	# to be called when the button with the specified ID is down.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button
	#   - +callable+ +callback+ -> The callable to call when the ID key is down
	def add_button_down_callback(id, callback)
		@bt_down[id] = callback
	end

	# Removes the button down callback entry with the given button ID.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button
	def remove_button_down_callback(id)
		@bt_down.delete(id)
	end

	# Adds the given callback callable for the given key ID. The callable is 
	# to be called when the button with the specified ID is up.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button
	#   - +callable+ +callback+ -> The callable to call when the ID key is up
	def add_button_up_callback(id, callback)
		@bt_up[id] = callback
	end

	# Removes the button up callback entry with the given button ID.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button
	def remove_button_up_callback(id)
		@bt_up.delete(id)
	end

	# Adds the given callback callable for the given key ID. The callable is 
	# to be called when the button with the specified ID is held down.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button
	#   - +callable+ +callback+ -> The callable to call when the ID key is held down
	def add_button_held_callback(id, callback)
		@bt_held[id] = callback
	end

	# Removes the button held callback entry with the given button ID.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button
	def remove_button_held_callback(id)
		@bt_held.delete(id)
	end

	# Calls the callable when the button associated with the given button ID is 
	# pressed.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button being pressed down
	def button_down(id)
		callback = @bt_down[id]
		callback.call if callback
		@prev_pressed << id
	end

	# Calls the callable when the button associated with the given button ID is 
	# released.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button being released
	def button_up(id)
		callback = @bt_up[id]
		callback.call if callback
	end

	# Checks if all previously pressed buttons still are pressed down and calls
	# any associated held down callbacks.
	def buttons_pressed_down
		if !@prev_pressed.empty?
			prev = @prev_pressed
			@prev_pressed = []

			prev.each do |key|
				if Gosu::button_down?(key)
					button_held(key)
				end
			end
		end
	end

	
protected

	# Calls the callable when the button associated with the given button ID is 
	# held down.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button being held down
	def button_held(id)
		callback = @bt_held[id]
		if callback
			callback.call 
			@prev_pressed << id
		end
	end

end
