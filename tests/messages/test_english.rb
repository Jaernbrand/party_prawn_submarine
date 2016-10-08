
require 'test/unit'
require 'minitest/mock'

require 'messages/english'

class PlayStateTester < Test::Unit::TestCase

	def test_messages_not_nil
		assert_not_nil English.messages
	end

	def test_keynames_not_nil
		assert_not_nil English.keynames
	end

end
