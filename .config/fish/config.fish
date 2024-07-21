# ---- Interactive ----
if status is-interactive
  # ---- Vim stuff ----
  # Set normal and visual mode to a block
  set fish_cursor_default block
  # Set insert mode to a line
  set fish_cursor_insert line
  # Set replace modes to an underscore
  set fish_cursor_replace_one underscore
  set fish_cursor_replace underscore
  # Set the in-command cursor to a line
  set fish_cursor_external line
  # Forcing the cursor on
  set fish_vi_force_cursor
  # Enabling vi/vim bindings
  fish_vi_key_bindings
  # ---- Setting up zoxide ----
  zoxide init fish | source
end

