-- reload with super+shift+r
package.path = hs.configdir .. "/?.lua;" .. package.path

local ok, fennel = pcall(require, "fennel")
if not ok then
  hs.alert.show("fennel.lua failed to load", 6)
  print(fennel)
  return
end

fennel.install()
package.path = hs.configdir .. "/?.fnl;" .. package.path

local loaded, err = xpcall(function()
  fennel.dofile(hs.configdir .. "/init.fnl")
end, fennel.traceback)

if not loaded then
  hs.alert.show("init.fnl error, see console", 6)
  print(err)
end
