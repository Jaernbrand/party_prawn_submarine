
require 'gosu'

# Handles callbacks for button up and down events. See Gosu's documentation 
# for button constants.
class Controller

	# Initialises a new Controller instance. The new object will use the given
	# Hash objects to store the pairs of button constants (key) and Proc 
	# objects (value).
	#
	# * *Args*    :
	#   - <tt>Hash<Fixnum, Proc></tt> +bt_down+ -> The Hash to store button down callbacks in
	#   - <tt>Hash<Fixnum, Proc></tt> +bt_up+ -> The Hash to store button up callbacks in
	def initialize(bt_down = {}, bt_up = {})
		@bt_down = bt_down
		@bt_up = bt_up
	end

	# Adds the given callback Proc for the given key ID. The Proc is to be 
	# called when the button with the specified ID is down.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button
	#   - +Proc+ +callback+ -> The Proc to call when the ID key is down
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

	# Adds the given callback Proc for the given key ID. The Proc is to be 
	# called when the button with the specified ID is up.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button
	#   - +Proc+ +callback+ -> The Proc to call when the ID key is up
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

	# Calls the Proc when the button associated with the given button ID is 
	# pressed.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button being pressed down
	def button_down(id)
		callback = @bt_down[id]
		callback.call if callback
	end

	# Calls the Proc when the button associated with the given button ID is 
	# released.
	#
	# * *Args*    :
	#   - +Fixnum+ +id+ -> The ID of the button being released
	def button_up(id)
		callback = @bt_up[id]
		callback.call if callback
	end

end
