
require 'gosu'

# Defines application wide constants.
module Constants

	MAJOR_VERSION = "0"
	MINOR_VERSION = "0"
	PATCH = "0"

	VERSION = [MAJOR_VERSION, MINOR_VERSION, PATCH].join(".")

	IMAGE_PATH = 'assets/images/'

	SOUND_PATH = 'assets/sounds/'
	SOUND_EFFECTS_PATH = SOUND_PATH + 'effects/'

	# The name of the font to use for text
	FONT_NAME = Gosu::default_font_name

	# The text height of the buttons
	BT_TEXT_HEIGHT = 30

	# The standard text height
	TEXT_HEIGHT = 30

	# The maximum number of players.
	MAX_PLAYERS = 4

	# The minimum number of players.
	MIN_PLAYERS = 2

end
