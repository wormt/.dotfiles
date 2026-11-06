;; super == option
;; prefix: ctrl+super+b, then hjkl focus, HJKL send to monitor, m/r move/resize,
;; arrows snap halves, - = [ ] snap quarters, s shrug, t/T thorn, . ellipsis.
;; minimize, fill, close: native shortcuts

(local mod [:alt])
(local mod-shift [:alt :shift])

;; macos raises on focus
(local focus-follows-mouse true)

(set hs.window.animationDuration 0)
(hs.autoLaunch true)

;; start ayu dark
(fn hex [s alpha]
  (let [n (tonumber (s:sub 2) 16)]
    {:red (/ (// n 65536) 255)
     :green (/ (% (// n 256) 256) 255)
     :blue (/ (% n 256) 255)
     :alpha (or alpha 1)}))

(let [style hs.alert.defaultStyle]
  (set style.fillColor (hex "#0F1419" 0.96))
  (set style.strokeColor (hex "#FF8F40"))
  (set style.textColor (hex "#E6E1CF"))
  (set style.strokeWidth 2)
  (set style.radius 8)
  (set style.textFont "Menlo")
  (set style.textSize 18)
  (set style.padding 14))
;; end ayu dark

(fn mod-only? [e]
  (let [f (e:getFlags)]
    (and f.alt (not f.cmd) (not f.ctrl) (not f.shift))))

(fn contains? [f pt]
  (and (>= pt.x f.x) (<= pt.x (+ f.x f.w)) (>= pt.y f.y) (<= pt.y (+ f.y f.h))))

(fn window-at [pt]
  (var found nil)
  (each [_ w (ipairs (hs.window.orderedWindows)) &until found]
    (when (and (w:isStandard) (w:isVisible) (contains? (w:frame) pt))
      (set found w)))
  found)

(fn focused []
  (hs.window.focusedWindow))

(local min-size 120)
(var drag nil)

;; throttle bc slow apps like ghostty with resize queue too often
(local drag-interval 0.008)

;; start vibeslop
(fn drag-apply [p]
  (when (not (and drag.last (= drag.last.x p.x) (= drag.last.y p.y)))
    (set drag.last {:x p.x :y p.y})
    (let [dx (- p.x drag.p0.x)
          dy (- p.y drag.p0.y)
          f drag.f0]
      (if (= drag.kind :move)
          (drag.win:setTopLeft {:x (+ f.x dx) :y (+ f.y dy)})
          (let [w (math.max min-size (if drag.left (- f.w dx) (+ f.w dx)))
                h (math.max min-size (if drag.top (- f.h dy) (+ f.h dy)))
                x (if drag.left (+ f.x (- f.w w)) f.x)
                y (if drag.top (+ f.y (- f.h h)) f.y)]
            ;; not setFrame: it sets size twice
            (when (or drag.left drag.top)
              (drag.win:setTopLeft {:x x :y y}))
            (drag.win:setSize {:w w :h h}))))))

(fn drag-move [p]
  (let [t (hs.timer.secondsSinceEpoch)]
    (when (>= (- t drag.t) drag-interval)
      (drag-apply p)
      ;; stamp after the call
      (set drag.t (hs.timer.secondsSinceEpoch)))))

(fn drag-end [p]
  (when drag
    (when p (drag-apply p))
    (set drag nil)))

(fn drag-begin [kind e]
  (let [p (e:location)
        w (window-at p)]
    (when w
      (w:focus)
      (let [f (w:frame)]
        (set drag {:kind kind
                   :win w
                   :t 0
                   :p0 {:x p.x :y p.y}
                   :f0 {:x f.x :y f.y :w f.w :h f.h}
                   :left (< (- p.x f.x) (/ f.w 2))
                   :top (< (- p.y f.y) (/ f.h 2))})
        true))))

(local T hs.eventtap.event.types)

(fn mouse-handler [e]
  (let [t (e:getType)]
    (if (= t T.leftMouseDown) (and (mod-only? e) (drag-begin :move e))
        (= t T.rightMouseDown) (and (mod-only? e) (drag-begin :resize e))
        (or (= t T.leftMouseDragged) (= t T.rightMouseDragged))
        (when drag (drag-move (e:location)) true)
        (or (= t T.leftMouseUp) (= t T.rightMouseUp))
        (when drag (drag-end (e:location)) true)
        false)))

;; globals: a local would be garbage-collected and the tap would stop
(global wm-mouse-tap
        (: (hs.eventtap.new [T.leftMouseDown T.leftMouseDragged T.leftMouseUp
                             T.rightMouseDown T.rightMouseDragged T.rightMouseUp]
                            mouse-handler) :start))

;; macOS disables slow taps
(global wm-tap-watchdog
        (hs.timer.doEvery 5 (fn [] (when (not (wm-mouse-tap:isEnabled))
                                     (wm-mouse-tap:start)))))

(var hover-dirty false)
(var hover-last nil)
(when focus-follows-mouse
  (global wm-focus-tap
          (: (hs.eventtap.new [T.mouseMoved] (fn [] (set hover-dirty true) false)) :start))
  ;; focus once the pointer has settled
  (global wm-focus-timer
          (hs.timer.doEvery 0.1
                            (fn []
                              (when hover-dirty
                                (let [p (hs.mouse.absolutePosition)]
                                  (if (and hover-last (= hover-last.x p.x) (= hover-last.y p.y))
                                      (let [w (window-at p)
                                            cur (focused)]
                                        (set hover-dirty false)
                                        (when (and w (or (not cur) (not= (w:id) (cur:id))))
                                          (w:focus)))
                                      (set hover-last {:x p.x :y p.y}))))))))

(fn to-monitor [dir]
  (fn []
    (let [w (focused)]
      (when w
        (let [s ((. (w:screen) dir) (w:screen))]
          (when s (w:moveToScreen s)))))))

(fn focus-monitor [dir]
  (fn []
    (let [cur (let [w (focused)] (if w (w:screen) (hs.mouse.getCurrentScreen)))
          target (and cur ((. cur dir) cur))]
      (when target
        (var win nil)
        (each [_ w (ipairs (hs.window.orderedWindows)) &until win]
          (when (and (w:isStandard) (w:isVisible) (= (: (w:screen) :id) (target:id)))
            (set win w)))
        (let [f (if win (win:frame) (target:frame))]
          (when win (win:focus))
          (hs.mouse.absolutePosition {:x (+ f.x (/ f.w 2)) :y (+ f.y (/ f.h 2))}))))))

(local step-big 40)
(local step-small 10)

(fn nudge [dx dy dw dh]
  (fn []
    (let [w (focused)]
      (when w
        (let [f (w:frame)]
          (w:setFrame {:x (+ f.x dx)
                       :y (+ f.y dy)
                       :w (math.max min-size (+ f.w dw))
                       :h (math.max min-size (+ f.h dh))}))))))

(fn edit-mode [label binds]
  (let [m (hs.hotkey.modal.new)]
    (set m.entered (fn [] (hs.alert.closeAll)
                     (hs.alert.show label {} (hs.screen.mainScreen) "never")))
    (set m.exited (fn [] (hs.alert.closeAll)))
    (each [_ [mods key f] (ipairs binds)]
      (m:bind mods key f nil f))
    (m:bind [] :return (fn [] (m:exit)))
    (m:bind [] :escape (fn [] (m:exit)))
    m))

(local move-mode
       (edit-mode "move  (hjkl, HJKL fine, Enter done)"
                  [[[] :h (nudge (- step-big) 0 0 0)]
                   [[] :l (nudge step-big 0 0 0)]
                   [[] :k (nudge 0 (- step-big) 0 0)]
                   [[] :j (nudge 0 step-big 0 0)]
                   [[:shift] :h (nudge (- step-small) 0 0 0)]
                   [[:shift] :l (nudge step-small 0 0 0)]
                   [[:shift] :k (nudge 0 (- step-small) 0 0)]
                   [[:shift] :j (nudge 0 step-small 0 0)]]))

(local resize-mode
       (edit-mode "resize  (h/l width, j/k height, HJKL fine, Enter done)"
                  [[[] :h (nudge 0 0 (- step-big) 0)]
                   [[] :l (nudge 0 0 step-big 0)]
                   [[] :k (nudge 0 0 0 (- step-big))]
                   [[] :j (nudge 0 0 0 step-big)]
                   [[:shift] :h (nudge 0 0 (- step-small) 0)]
                   [[:shift] :l (nudge 0 0 step-small 0)]
                   [[:shift] :k (nudge 0 0 0 (- step-small))]
                   [[:shift] :j (nudge 0 0 0 step-small)]]))
;; end vibeslop

(local wm-prefix-mods [:ctrl :alt])
(local wm-prefix-key :b)
(local wm-timeout 1.5)

(local wm (hs.hotkey.modal.new))
(var wm-timer nil)

(fn wm-leave []
  (when wm-timer (wm-timer:stop) (set wm-timer nil))
  (wm:exit))

(fn wm-arm []
  (when wm-timer (wm-timer:stop))
  (set wm-timer (hs.timer.doAfter wm-timeout wm-leave)))

(fn warp-to-focused []
  (let [w (focused)]
    (when w
      (let [f (w:frame)]
        (hs.mouse.absolutePosition {:x (+ f.x (/ f.w 2)) :y (+ f.y (/ f.h 2))})))))

(fn cycle-window [step]
  (fn []
    (let [wins (icollect [_ w (ipairs (hs.window.orderedWindows))]
                 (when (w:isStandard) w))
          cur (focused)
          n (# wins)]
      (table.sort wins (fn [a b] (< (a:id) (b:id))))
      (var idx 0)
      (each [i w (ipairs wins)]
        (when (and cur (= (w:id) (cur:id))) (set idx i)))
      (when (> n 0)
        (let [w (. wins (+ 1 (% (+ idx step -1) n)))
              f (w:frame)]
          (w:focus)
          (hs.mouse.absolutePosition {:x (+ f.x (/ f.w 2)) :y (+ f.y (/ f.h 2))}))))))

(fn toggle-fullscreen []
  (let [w (focused)]
    (when w (w:toggleFullScreen))))

(fn focus-window [dir]
  (fn []
    (let [w (focused)]
      (when w
        ((. w dir) w)
        (warp-to-focused)))
    (wm-arm)))

(fn send-to-monitor [dir]
  (let [move (to-monitor dir)]
    (fn [] (move) (wm-leave))))

(set wm.entered (fn [] (hs.alert.closeAll) (hs.alert.show "window" 1)))
(set wm.exited (fn [] (hs.alert.closeAll)))

(wm:bind [] :h (focus-window :focusWindowWest))
(wm:bind [] :j (focus-window :focusWindowSouth))
(wm:bind [] :k (focus-window :focusWindowNorth))
(wm:bind [] :l (focus-window :focusWindowEast))
(wm:bind [:shift] :h (send-to-monitor :toWest))
(wm:bind [:shift] :j (send-to-monitor :toSouth))
(wm:bind [:shift] :k (send-to-monitor :toNorth))
(wm:bind [:shift] :l (send-to-monitor :toEast))
(fn snap [item unit]
  (fn []
    (let [app (hs.application.frontmostApplication)
          w (focused)]
      (when (not (and app (app:selectMenuItem [:Window "Move & Resize" item])))
        (when w (w:moveToUnit unit))))
    (wm-leave)))

(wm:bind [] :left (snap "Left" (hs.geometry.rect 0 0 0.5 1)))
(wm:bind [] :right (snap "Right" (hs.geometry.rect 0.5 0 0.5 1)))
(wm:bind [] :up (snap "Top" (hs.geometry.rect 0 0 1 0.5)))
(wm:bind [] :down (snap "Bottom" (hs.geometry.rect 0 0.5 1 0.5)))
(wm:bind [] "-" (snap "Top Left" (hs.geometry.rect 0 0 0.5 0.5)))
(wm:bind [] "=" (snap "Top Right" (hs.geometry.rect 0.5 0 0.5 0.5)))
(wm:bind [] "[" (snap "Bottom Left" (hs.geometry.rect 0 0.5 0.5 0.5)))
(wm:bind [] "]" (snap "Bottom Right" (hs.geometry.rect 0.5 0.5 0.5 0.5)))
(fn type-text [text]
  (fn [] (wm-leave) (hs.eventtap.keyStrokes text)))

(wm:bind [] :s (type-text "\u{AF}\\_(\u{30C4})_/\u{AF}"))
(wm:bind [] :t (type-text "\u{FE}"))
(wm:bind [:shift] :t (type-text "\u{DE}"))
(wm:bind [] "." (type-text "\u{2026}"))
(wm:bind [] :m (fn [] (wm-leave) (move-mode:enter)))
(wm:bind [] :r (fn [] (wm-leave) (resize-mode:enter)))
(wm:bind [] :escape wm-leave)

(hs.hotkey.bind wm-prefix-mods wm-prefix-key (fn [] (wm:enter) (wm-arm)))

(fn terminal []
  (let [app (hs.application.find "com.mitchellh.ghostty")]
    (if app
        (do (app:activate) (app:selectMenuItem [:File "New Window"]))
        (hs.application.launchOrFocus :Ghostty))))

(hs.hotkey.bind mod :return terminal)
(hs.hotkey.bind mod :j (cycle-window 1))
(hs.hotkey.bind mod :k (cycle-window -1))
(hs.hotkey.bind mod :f toggle-fullscreen)
(hs.hotkey.bind mod-shift :up (to-monitor :toNorth))
(hs.hotkey.bind mod-shift :down (to-monitor :toSouth))
(hs.hotkey.bind mod-shift :left (to-monitor :toWest))
(hs.hotkey.bind mod-shift :right (to-monitor :toEast))
(hs.hotkey.bind [:cmd :alt] :h (focus-monitor :toWest))
(hs.hotkey.bind [:cmd :alt] :j (focus-monitor :toSouth))
(hs.hotkey.bind [:cmd :alt] :k (focus-monitor :toNorth))
(hs.hotkey.bind [:cmd :alt] :l (focus-monitor :toEast))
(hs.hotkey.bind mod-shift :r hs.reload)

(hs.alert.show "Hammerspoon loaded")
