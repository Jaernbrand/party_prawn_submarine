
# Responsible for creating the dictionary of user messages in english.
module English

	# Returns a Hash with all user messages in english.
	#
	# * *Returns* :
	#   - Hash containing the user messages in english
	# * *Return* *Type* :
	#   - Hash<Symbol, String>
	def self.messages
		{:winner => "The winner is %s!",
   		:no_winner => "No one won."}
	end

end

