\(globals : ../globals/Globals.dhall) ->
  ''
  [org/gnome/desktop/calendar]
  show-weekdate=true

  [org/gnome/desktop/interface]
  accent-color='purple'
  clock-show-seconds=true
  clock-show-weekday=true
  color-scheme='prefer-dark'
  enable-animations=true
  enable-hot-corners=false
  gtk-enable-primary-paste=false
  locate-pointer=false
  overlay-scrolling=true
  toolkit-accessibility=false

  [org/gnome/desktop/notifications]
  show-in-lock-screen=false

  [org/gnome/desktop/peripherals/keyboard]
  delay=uint32 200
  repeat-interval=uint32 25

  [org/gnome/desktop/peripherals/mouse]
  accel-profile='default'
  natural-scroll=false
  speed=0.0

  [org/gnome/desktop/peripherals/touchpad]
  two-finger-scrolling-enabled=true

  [org/gnome/desktop/search-providers]
  enabled=['org.gnome.Calculator.desktop', 'io.github.vmkspv.lenspect.desktop']
  sort-order=['org.gnome.Settings.desktop', 'org.gnome.Contacts.desktop', 'org.gnome.Nautilus.desktop']

  [org/gnome/desktop/sound]
  allow-volume-above-100-percent=true
  event-sounds=true

  [org/gnome/desktop/wm/keybindings]
  maximize=['<Super>Up']
  minimize=@as []
  move-to-monitor-down=['<Super><Shift>Down']
  move-to-monitor-left=['<Super><Shift>Left']
  move-to-monitor-right=['<Super><Shift>Right']
  move-to-monitor-up=['<Super><Shift>Up']
  move-to-workspace-down=['<Control><Shift><Alt>Down']
  move-to-workspace-left=@as []
  move-to-workspace-right=@as []
  move-to-workspace-up=['<Control><Shift><Alt>Up']
  switch-applications=@as []
  switch-applications-backward=@as []
  switch-group=@as []
  switch-group-backward=@as []
  switch-input-source=@as []
  switch-input-source-backward=@as []
  switch-panels=@as []
  switch-panels-backward=@as []
  switch-to-workspace-1=@as []
  switch-to-workspace-last=@as []
  switch-to-workspace-left=@as []
  switch-to-workspace-right=@as []
  unmaximize=['<Super>Down', '<Alt>F5']

  [org/gnome/desktop/wm/preferences]
  audible-bell=false
  focus-mode='click'
  num-workspaces=12
  resize-with-right-button=true
  workspace-names=['Workspace 1', 'Workspace 2', 'Workspace 3', 'Workspace 4', 'Workspace 5', 'Workspace 6', 'Workspace 7', 'Workspace 8']

  [org/gnome/mutter]
  attach-modal-dialogs=false
  dynamic-workspaces=false
  edge-tiling=false
  overlay-key='''
  workspaces-only-on-primary=false

  [org/gnome/mutter/keybindings]
  cancel-input-capture=['<Super><Shift>Escape']
  toggle-tiled-left=['<Super>Left']
  toggle-tiled-right=['<Super>Right']

  [org/gnome/mutter/wayland/keybindings]
  restore-shortcuts=@as []

  [org/gnome/settings-daemon/plugins/color]
  night-light-enabled=true
  night-light-schedule-automatic=false

  [org/gnome/settings-daemon/plugins/media-keys]
  custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/', '/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/']
  help=@as []
  rotate-video-lock-static=@as []
  screensaver=['<Super>Pause']
  search=['<Super>space']

  [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0]
  binding='<Super>Return'
  command='ghostty'
  name='ghostty'

  [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1]
  binding='<Shift><Super>p'
  command='/home/linuxbrew/.linuxbrew/bin/mpc -h /run/user/6969/mpd/socket toggle'
  name='mpc toggle'

  [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2]
  binding='<Shift><Super>n'
  command='/home/linuxbrew/.linuxbrew/bin/mpc -h /run/user/6969/mpd/socket next'
  name='mpc next'

  [org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3]
  binding='<Shift><Super>b'
  command='/home/linuxbrew/.linuxbrew/bin/mpc -h /run/user/6969/mpd/socket prev'
  name='mpc prev'

  [org/gnome/shell]
  allow-extension-installation=true
  disable-user-extensions=false
  disabled-extensions=['search-light@icedman.github.com', 'dash-to-dock@micxgx.gmail.com', 'containers@royg', 'openbar@neuromorph', 'multi-monitors-bar@frederykabryan', 'blur-my-shell@aunetx', 'launch-new-instance@gnome-shell-extensions.gcampax.github.com', 'window-list@gnome-shell-extensions.gcampax.github.com', 'apps-menu@gnome-shell-extensions.gcampax.github.com', 'places-menu@gnome-shell-extensions.gcampax.github.com']
  enabled-extensions=['display-brightness-ddcutil@themightydeity.github.com', 'appindicatorsupport@rgcjonas.gmail.com', 'dynamic-music-pill@andbal', 'nightthemeswitcher@romainvigier.fr', 'paperwm@paperwm.github.com', 'caffeine@patapon.info', 'dash-to-panel@jderose9.github.com', 'just-perfection-desktop@just-perfection']
  favorite-apps=['com.mitchellh.ghostty.desktop', 'org.gnome.Nautilus.desktop', 'trivalent.desktop', 'org.keepassxc.KeePassXC.desktop']
  remember-mount-password=false

  [org/gnome/shell/app-switcher]
  current-workspace-only=false

  [org/gnome/shell/extensions/caffeine]
  cli-toggle=true
  countdown-timer=0
  duration-timer-list=[1200, 3600, 10800]
  enable-fullscreen=false
  nightlight-control='never'
  restore-state=true
  use-custom-duration=true

  [org/gnome/shell/extensions/dash-to-panel]
  animate-appicon-hover-animation-extent={'RIPPLE': 4, 'PLANK': 4, 'SIMPLE': 1}
  appicon-margin=0
  appicon-padding=0
  dot-position='TOP'
  dot-size=4
  dot-style-focused='CILIORA'
  dot-style-unfocused='SQUARES'
  focus-highlight-dominant=true
  hotkeys-overlay-combo='TEMPORARILY'
  leftbox-padding=0
  multi-monitors=false
  panel-lengths='{}'
  show-apps-icon-file='''
  status-icon-padding=0
  trans-use-custom-opacity=true
  tray-padding=4
  window-preview-title-position='TOP'

  [org/gnome/shell/extensions/display-brightness-ddcutil]
  allow-zero-brightness=true
  button-location=1
  decrease-brightness-shortcut=[''']
  hide-system-indicator=true
  increase-brightness-shortcut=[''']
  only-all-slider=true
  position-system-menu=3.0
  show-all-slider=true
  show-display-name=false
  show-internal-slider=false
  show-osd=false
  show-value-label=true
  step-change-keyboard=2.0

  [org/gnome/shell/extensions/dynamic-music-pill]
  always-show-pill=true
  compatibility-delay=false
  dock-position=0
  enable-lyrics=false
  enable-transparency=true
  hide-default-player=true
  hide-text=false
  invert-scroll-animation=false
  panel-pill-width=192
  pill-dynamic-width=false
  popup-custom-width=360
  popup-follow-radius=true
  popup-vinyl-rotate=true
  popup-vinyl-speed=10
  popup-vinyl-square=true
  position-mode=2
  scroll-action='volume'
  scroll-on-hover-only=false
  shadow-opacity=15
  sync-accent-color=false
  target-container=3
  transparency-art=false
  transparency-strength=80
  transparency-text=false
  transparency-vis=false
  visualizer-style=2

  [org/gnome/shell/extensions/just-perfection]
  accent-color-icon=false
  animation=4
  double-super-to-appgrid=false
  notification-banner-position=5
  support-notifier-type=0
  switcher-popup-delay=false
  type-to-search=false

  [org/gnome/shell/extensions/nightthemeswitcher/time]
  manual-schedule=true
  nightthemeswitcher-ondemand-keybinding=['<Shift><Super>t']
  sunrise=6.0
  sunset=18.0

  [org/gnome/shell/extensions/paperwm]
  disable-scratch-in-overview=false
  disable-topbar-styling=true
  gesture-enabled=true
  horizontal-margin=8
  only-scratch-in-overview=true
  open-window-position=0
  selection-border-radius-bottom=0
  selection-border-radius-top=16
  selection-border-size=4
  show-window-position-bar=false
  show-workspace-indicator=true
  vertical-margin=6
  vertical-margin-bottom=6
  window-gap=8
  winprops=@as []

  [org/gnome/shell/extensions/paperwm/keybindings]
  close-window=['<Shift><Super>q']
  move-down=['<Shift><Super>j']
  move-down-workspace=['<Shift><Super>Page_Down']
  move-left=['<Shift><Super>h']
  move-monitor-above=['<Shift><Control><Super>k']
  move-monitor-below=['<Shift><Control><Super>j']
  move-monitor-left=['<Shift><Control><Super>h']
  move-monitor-right=['<Shift><Control><Super>l']
  move-right=['<Shift><Super>l']
  move-space-monitor-above=[''']
  move-space-monitor-below=[''']
  move-space-monitor-left=[''']
  move-space-monitor-right=[''']
  move-up=['<Shift><Super>k']
  move-up-workspace=['<Shift><Super>Page_Up']
  new-window=['<Shift><Super>Return']
  resize-h-dec=['<Shift><Super>underscore']
  resize-w-dec=['<Shift><Super>braceleft']
  resize-w-inc=['<Shift><Super>braceright']
  swap-monitor-above=['<Shift><Alt><Super>k']
  swap-monitor-below=['<Shift><Alt><Super>j']
  swap-monitor-left=['<Shift><Alt><Super>h']
  swap-monitor-right=['<Shift><Alt><Super>l']
  switch-down=[''']
  switch-down-loop=['<Super>j']
  switch-focus-mode=[''']
  switch-global-down=[''']
  switch-global-left=[''']
  switch-global-right=[''']
  switch-global-up=[''']
  switch-left=[''']
  switch-left-loop=['<Super>h']
  switch-monitor-above=['<Alt><Super>k']
  switch-monitor-below=['<Alt><Super>j']
  switch-monitor-left=['<Alt><Super>h']
  switch-monitor-right=['<Alt><Super>l']
  switch-next=[''']
  switch-open-window-position=['<Super>z']
  switch-previous=[''']
  switch-right=[''']
  switch-right-loop=['<Super>l']
  switch-up=[''']
  switch-up-loop=['<Super>k']
  toggle-scratch=['<Shift><Super>s']
  toggle-scratch-layer=['<Super>s']

  [org/gnome/shell/keybindings]
  focus-active-notification=['<Super>n']
  shift-overview-down=['<Super><Alt>Down']
  shift-overview-up=['<Super><Alt>Up']
  toggle-message-tray=@as []
  toggle-quick-settings=@as []

  [org/gnome/tweaks]
  show-extensions-notice=false

  [org/gtk/gtk4/settings/file-chooser]
  show-hidden=true
  sort-directories-first=false

  [system/proxy/socks]
  host='localhost'
  port=9050
  ''
