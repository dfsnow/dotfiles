-- Mirrors tmux/.tmux.conf: ` enters a "prefix" mode,
-- and the next key runs the binding below it
rex.mode("prefix", { exclusive = true })
rex.bind("[Backquote]", "client.mode.enter", { name = "prefix", once = true })
rex.bind("prefix/[Backquote]", "pane.send_key", { key = "`" })
rex.bind("prefix/escape", "client.mode.exit")
rex.bind("prefix/r", "client.config.reload")

rex.bind("prefix/q", "session.close")
rex.bind("prefix/t", "pane.zoom")
rex.bind("prefix/z", "pane.zoom")
rex.bind("prefix/b", "client.tab.new")
rex.bind("prefix/n", "client.tab.new")
rex.bind("prefix/[Minus]", "pane.split.right")
rex.bind("prefix/shift+[Minus]", "pane.split.down")

rex.bind("prefix/h", "pane.focus.left")
rex.bind("prefix/j", "pane.focus.down")
rex.bind("prefix/k", "pane.focus.up")
rex.bind("prefix/l", "pane.focus.right")

-- tmux defaults the tmux config relies on implicitly
rex.bind("prefix/c", "client.tab.new")
rex.bind("prefix/p", "client.tab.previous")
rex.bind("prefix/[Comma]", "client.tab.rename")
rex.bind("prefix/shift+[Digit4]", "session.rename")
rex.bind("prefix/s", "session.switch")
rex.bind("prefix/o", "pane.focus_next")
for i = 1, 9 do
  rex.bind("prefix/" .. i, "client.tab.goto", { index = i })
end

-- Close the focused pane, and its tab when it is the last pane, like tmux's
-- kill-pane. The client's pane.close keeps the last pane in a tab open
rex.action{
  name  = "kill_pane",
  title = "Kill Pane",
  run   = function(ctx)
    local _, err = rex.call("block.close", {
      session_id = ctx.session_id,
      block_id   = ctx.block_id,
    })
    if err ~= nil then error(err, 0) end
  end,
}

rex.bind("prefix/x", "kill_pane")

-- Cycle through the tabs of the current session only, wrapping at the ends
-- like tmux's select-window -t :+ and :-. The app shows the tab only when
-- asked through session.select, so the action queues that for the client
local function cycle_session_tab(ctx, step)
  local view, err = rex.session.view{}
  if err ~= nil then error(err, 0) end
  local block, berr = rex.session.describe_block{ block_id = ctx.block_id }
  if berr ~= nil then error(berr, 0) end

  local windows = view.windows
  for i, w in ipairs(windows) do
    if w.window_id == block.block.window_id then
      local target = windows[(i - 1 + step) % #windows + 1]
      rex.client.queue("session.select", {
        session_id = ctx.session_id,
        window_id  = target.window_id,
      })
      return
    end
  end
end

rex.action{
  name  = "session_tab_next",
  title = "Next Tab in Session",
  run   = function(ctx) cycle_session_tab(ctx, 1) end,
}

rex.action{
  name  = "session_tab_previous",
  title = "Previous Tab in Session",
  run   = function(ctx) cycle_session_tab(ctx, -1) end,
}

-- Add a resize mode
rex.bind("prefix/tab", "session_tab_next")
rex.bind("prefix/shift+tab", "session_tab_previous")

rex.mode("resize", { exclusive = true })
rex.bind("cmd+r", "client.mode.enter", { name = "resize" })

rex.bind("resize/h", "pane.resize", { direction = "left" })
rex.bind("resize/j", "pane.resize", { direction = "down" })
rex.bind("resize/k", "pane.resize", { direction = "up" })
rex.bind("resize/l", "pane.resize", { direction = "right" })

-- Hold shift for bigger steps
rex.bind("resize/shift+h", "pane.resize", {
  direction = "left",
  amount = 15,
})
rex.bind("resize/shift+l", "pane.resize", {
  direction = "right",
  amount = 15,
})

rex.bind("resize/=", "pane.balance")
rex.bind("resize/enter", "client.mode.exit")
