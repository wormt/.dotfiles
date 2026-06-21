import os
home = os.path.expanduser("~")
config.load_autoconfig(False)
c.url.default_page = f'file://{home}/projects/homepage/index.html'
c.url.start_pages = f'file://{home}/projects/homepage/index.html'
c.tabs.show = 'multiple'
c.tabs.favicons.show = 'never'
c.statusbar.show = 'in-mode'
c.statusbar.widgets = ["keypress", "search_match", "progress", "url"]
c.scrolling.bar = 'never'
c.content.pdfjs = True
c.completion.scrollbar.padding = 0
c.completion.scrollbar.width = 0
c.completion.web_history.max_items = 999
c.completion.favorite_paths = [f"{home}/projects/homepage/index.html"]
c.completion.open_categories = ["quickmarks", "bookmarks", "filesystem", "history", "searchengines"]
#c.editor.command = ["foot", "ed", "-vEp", ":", "{file}"]
c.editor.command = ["foot", "nvim", "{file}"]
c.bindings.commands = {
	"normal": {
		"o": "cmd-set-text -s :open -s",
		"O": "cmd-set-text -s :open -st",
		"go": "cmd-set-text -s :open -s {url:pretty}",
		"gO": "cmd-set-text -s :open -str {url:pretty}",
		"xo": "cmd-set-text -s :open -sb",
		"xO": "cmd-set-text -s :open -sbr {url:pretty}",
		"wo": "cmd-set-text -s :open -sw",
		"wO": "cmd-set-text -s :open -sw {url:pretty}",
		"ga": "open -st",
		"Ctrl+t": "open -st",
		"Ctrl+n": "open -sw",
		"Ctrl+Shift+n": "open -spw",
		";o": "hint links fill :open -s {hint-url}",
		";O": "hint links fill :open -str {hint-url}",
		"pp": "open -s -- {clipboard}",
		"pP": "open -s -- {primary}",
		"Pp": "open -st -- {clipboard}",
		"PP": "open -st -- {primary}",
		"wp": "open -sw -- {clipboard}",
		"wP": "open -sw -- {primary}",
		",cs": "config-source",
		",u": "edit-url",
		",m": "spawn wl-copy {url}",
		",M": "hint links spawn wl-copy {hint-url}",
		",ec": "spawn " + home + "/.config/qutebrowser/yescript.sh -c {url}",
		",eg": "spawn " + home + "/.config/qutebrowser/yescript.sh -g {url}",
		",ei": "spawn " + home + "/.config/qutebrowser/yescript.sh -i {url}",
		",es": "spawn " + home + "/.config/qutebrowser/yescript.sh -s {url}",
		",Ec": "hint links spawn " + home + "/.config/qutebrowser/yescript.sh -c {hint-url}",
		",Eg": "hint links spawn " + home + "/.config/qutebrowser/yescript.sh -g {hint-url}",
		",Ei": "hint links spawn " + home + "/.config/qutebrowser/yescript.sh -i {hint-url}",
		",Er": "hint links spawn " + home + "/.config/qutebrowser/yescript.sh -r {hint-url}",
		",Es": "hint links spawn " + home + "/.config/qutebrowser/yescript.sh -s {hint-url}"
	},
}
c.downloads.location.directory = f"{home}/dl"
c.downloads.location.prompt = True
c.content.headers.accept_language = 'en;q=0.9'
c.content.headers.user_agent = 'Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/126.0.0.0 Safari/537.36'
#c.content.headers.user_agent = 'Mozilla/5.0 (Windows NT 11.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/6.6.3 Chrome/122.0.6261.171 Safari/537.36'
#c.content.headers.user_agent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) QtWebEngine/6.8.2 Chrome/122.0.6261.171 Safari/537.36'
c.content.tls.certificate_errors = 'ask-block-thirdparty'
#c.content.webrtc_ip_handling_policy = 'default-public-interface-only'
c.content.webrtc_ip_handling_policy = 'disable-non-proxied-udp'
c.content.blocking.method = 'both'
c.content.dns_prefetch = False
c.content.cookies.accept = 'never'
c.content.javascript.enabled = False
c.content.images = False
c.content.webgl = False
c.content.canvas_reading = False
c.content.geolocation = False
c.content.notifications.enabled = False
#c.content.media.audio_capture = False
#c.content.media.audio_video_capture = False
#c.content.media.video_capture = False
config.source('engines.py')
config.source('sites-cookies.py')
config.source('sites-javascript.py')
config.source('sites-images.py')
config.source('sites-webgl.py')
#theme
c.fonts.default_family = 'Monaco'
c.fonts.default_size = '10px'
c.fonts.hints = 'bold 12px default_family'
#c.fonts.web.family.standard = 'Monaco'
#c.fonts.web.family.fixed = 'Monaco'
#c.fonts.web.size.default = 16
#c.fonts.web.size.default_fixed = 16
c.colors.webpage.preferred_color_scheme = 'dark'
c.colors.completion.fg = ['black', 'black', 'black']
c.colors.completion.odd.bg = 'white'
c.colors.completion.even.bg = '#f7f7f7'
c.colors.completion.category.fg = 'white'
c.colors.completion.category.bg = '#ec7fac'
c.colors.completion.category.border.top = 'black'
c.colors.completion.category.border.bottom = 'black'
c.colors.completion.item.selected.fg = 'white'
c.colors.completion.item.selected.bg = '#ec7fac'
c.colors.completion.item.selected.match.fg = '#887fec'
c.colors.completion.match.fg = '#0050a0'
c.colors.completion.scrollbar.fg = 'black'
c.colors.completion.scrollbar.bg = 'white'
c.colors.downloads.bar.bg = '#ec7fac'
c.colors.downloads.error.bg = '#a00000'
c.colors.hints.bg = 'rgba(236,127,172,0.75)'
c.colors.hints.fg = 'white'
c.colors.hints.match.fg = '#901050'
c.colors.messages.info.fg = 'black'
c.colors.messages.info.bg = 'white'
c.colors.statusbar.normal.bg = 'white'
c.colors.statusbar.normal.fg = 'black'
c.colors.statusbar.insert.fg = 'black'
c.colors.statusbar.insert.bg = '#00dd00'
c.colors.statusbar.passthrough.fg = 'white'
c.colors.statusbar.passthrough.bg = '#ec7fac'
c.colors.statusbar.command.fg = 'black'
c.colors.statusbar.command.bg = 'white'
c.colors.statusbar.url.fg = '#901050'
c.colors.statusbar.url.hover.fg = '#901050'
c.colors.statusbar.url.success.http.fg = '#804000'
c.colors.statusbar.url.success.https.fg = '#901050'
c.colors.statusbar.url.warn.fg = '#804000'
c.colors.statusbar.url.error.fg = '#a00000'
c.colors.tabs.bar.bg = 'white'
c.colors.tabs.odd.fg = 'black'
c.colors.tabs.odd.bg = 'white'
c.colors.tabs.even.fg = 'black'
c.colors.tabs.even.bg = '#f7f7f7'
c.colors.tabs.selected.odd.fg = 'white'
c.colors.tabs.selected.odd.bg = '#ec7fac'
c.colors.tabs.selected.even.fg = 'white'
c.colors.tabs.selected.even.bg = '#ec7fac'
c.colors.tabs.pinned.odd.fg = 'black'
c.colors.tabs.pinned.odd.bg = '#10e000'
c.colors.tabs.pinned.even.fg = 'black'
c.colors.tabs.pinned.even.bg = '#10e000'
c.colors.tabs.pinned.selected.odd.fg = 'white'
c.colors.tabs.pinned.selected.odd.bg = '#ec7fac'
c.colors.tabs.pinned.selected.even.fg = 'white'
c.colors.tabs.pinned.selected.even.bg = '#ec7fac'
