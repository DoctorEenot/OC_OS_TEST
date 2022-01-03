local w, h
local screen = component.list("screen", true)()
local gpu = screen and component.list("gpu", true)()
if gpu then
  gpu = component.proxy(gpu)
  if not gpu.getScreen() then
    gpu.bind(screen)
  end
  _G.boot_screen = gpu.getScreen()
  w, h = gpu.maxResolution()
  gpu.setResolution(w, h)
  gpu.setBackground(0x000000)
  gpu.setForeground(0xFFFFFF)
  gpu.fill(1, 1, w, h, " ")
end

local y = 1
local uptime = computer.uptime
local pull = computer.pullSignal
local last_sleep = uptime()
local function status(msg)
  if gpu then
    gpu.set(1, y, msg)
    if y == h then
      gpu.copy(1, 2, w, h - 1, 0, -1)
      gpu.fill(1, h, w, 1, " ")
    else
      y = y + 1
    end
  end
  if uptime() - last_sleep > 1 then
    local signal = table.pack(pull(0))
    if signal.n > 0 then
      computer.pushSignal(table.unpack(signal, 1, signal.n))
    end
    last_sleep = uptime()
  end
end


while true do
    status("Ya zaebalsya")
    --os.sleep(0.5)
end
