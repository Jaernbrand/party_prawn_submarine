
# Contains all user messages for the current language and returns them upon
# request.
class MessageDictionary

	# Initialises a new MessageDictionary with the given language dictionary.
	#
	# * *Args*    :
	#   - <tt>Hash<Symbol, String></tt> +language+ -> The language table to use
	def initialize(language)
		@messages = language
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

end
