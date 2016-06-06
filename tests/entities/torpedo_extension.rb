
# Extends the Torpedo class for testing purposes.
class Torpedo

	attr_writer :angle

	def Torpedo.img
		@@img
	end

	def Torpedo.img=(value)
		@@img=value
	end

end
