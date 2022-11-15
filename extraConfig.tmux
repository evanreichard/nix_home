# VIM, Prefix, Renumber
setw -g mode-keys vi
set-option -g prefix C-t
set-option -g renumber-windows on

# Maintain Directory
bind '"' split-window -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"
bind c new-window -c "#{pane_current_path}"
