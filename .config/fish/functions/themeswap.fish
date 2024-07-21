function themeswap --on-variable BAT_THEME
  fish_config theme choose $BAT_THEME
  set file_content (cat ~/dotfiles/.config/yazi/theme.toml)
  set file_content (string replace -r '/themes/[^"]*\.tmTheme' "/themes/$BAT_THEME\.tmTheme" -- $file_content)
  for line in $file_content
    echo $line
  end > ~/dotfiles/.config/yazi/theme.toml
end
