#!/usr/bin/env ruby

require '~/.dotfiles/helpers'

bracket_settings = {
  "/org/gnome/desktop/wm/keybindings/close": '<Control>q',
  "/org/gnome/desktop/wm/keybindings/maximize": '<Shift><Control>e',
  "/org/gnome/desktop/wm/keybindings/minimize": '<Control>m',
  "/org/gnome/desktop/wm/keybindings/move-to-monitor-left": '<Shift><Control>j',
  "/org/gnome/desktop/wm/keybindings/move-to-monitor-right": '<Shift><Control>k',
  "/org/gnome/desktop/wm/keybindings/switch-windows": '<Control>Tab',
  "/org/gnome/desktop/wm/keybindings/switch-windows-backward": '<Shift><Control>Tab',

  "/org/gnome/mutter/keybindings/toggle-tiled-left": '<Shift><Control>h',
  "/org/gnome/mutter/keybindings/toggle-tiled-right": '<Shift><Control>l',

  "/org/gnome/shell/keybindings/show-screenshot-ui": '<Shift><Control>4'
}
literal_settings = {
  "/org/gnome/desktop/interface/color-scheme": "'prefer-dark'",
  "/org/gnome/desktop/interface/enable-hot-corners": 'false',
  "/org/gnome/desktop/interface/text-scaling-factor": '0.85'
}

bracket_settings.each do |setting, shortcut|
  puts "running: dconf write \"#{setting}\" \"['#{shortcut}']\"".doing
  `dconf write "#{setting}" "['#{shortcut}']"`
end

literal_settings.each do |setting, config|
  puts "running: dconf write \"#{setting}\" \"#{config}\"".doing
  `dconf write "#{setting}" "#{config}"`
end
