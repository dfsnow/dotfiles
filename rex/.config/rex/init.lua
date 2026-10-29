-- Mirrors tmux/.tmux.conf: ` enters a "prefix" mode,
-- and the next key runs the binding below it
rex.mode("prefix", { exclusive = true })
rex.bind("[Backquote]", "client.mode.enter", { name = "prefix", once = true })
rex.bind("prefix/[Backquote]", "pane.send_key", { key = "`" })
rex.bind("prefix/escape", "client.mode.exit")

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

rex.bind("prefix/tab", "client.tab.next")
rex.bind("prefix/shift+tab", "client.tab.previous")
rex.bind("prefix/r", "client.config.reload")

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
