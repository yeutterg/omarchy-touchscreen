-- Generic touchscreen behavior for Omarchy laptops, tablets and detachables.
local binder = os.getenv("HOME") .. "/.local/bin/omarchy-touchscreen-bind"

-- Resolve the connector from kernel display state while the config loads, so
-- ordinary `hyprctl reload` keeps the mapping. The start hook applies it once
-- more after the compositor is fully ready on a fresh login.
local pipe = io.popen(binder .. " --print-output")
local output = pipe and pipe:read("*l") or nil
if pipe then pipe:close() end

if output and output ~= "" then
  hl.config({
    input = {
      touchdevice = { output = output },
      tablet = { output = output },
    },
  })
end

o.exec_on_start(binder)

