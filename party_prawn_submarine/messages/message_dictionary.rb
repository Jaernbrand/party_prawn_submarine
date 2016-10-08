
# Contains all user messages for the current language and returns them upon
# request.
class MessageDictionary

	# Initialises a new MessageDictionary with the given language dictionary 
	# and the given keynames dictionary.
	#
	# * *Args*    :
	#   - <tt>Hash<Symbol, String></tt> +language+ -> The language table to use
	#   - <tt>Hash<Fixnum, String></tt> +keynames+ -> The keynames table to use
	def initialize(language, keynames)
		@messages = language
		@keynames = keynames
	end

	# Gets the message corresponding to the given message symbol. Some messages
	# might be given optional arguments to be added to the message.
	#
	# * *Args*    :
	#   - +Symbol+ +msg+ -> The message Symbol for which to get the message String
	#   - +String+ +args+ -> Additional arguments used by some messages
	# * *Returns* :
	#   - The message corresponding to the given message symbol
	# * *Return* *Type* :
	#   - String
	def message(msg, *args)
		sprintf(@messages[msg], *args)
	end

	# Returns the string representation of the given gosu key constant.
	#
	# * *Args*    :
	#   - +Fixnum+ +key+ -> The gosu key constant to get the string representation for
	# * *Returns* :
	#   - The key as a string
	# * *Return* *Type* :
	#   - String
	def keyname(key)
		@keynames[key]
	end

end
