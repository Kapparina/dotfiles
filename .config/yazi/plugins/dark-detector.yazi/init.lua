local wezterm = require("wezterm")

if wezterm.gui.get_appearance():find "Dark" then
	os.execute("echo $SHELL")
else
	os.execute("echo hello")
end
