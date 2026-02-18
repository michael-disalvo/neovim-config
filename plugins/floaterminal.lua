local state = {
  floating = {
    buf = -1,
    win = -1,
  }
}

local function create_floating_window(opts)
  opts = opts or {}

  local buf = nil
  if vim.api.nvim_buf_is_valid(opts.buf) then 
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  -- Get editor dimensions
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.6)

  -- Calculate centered position
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  -- Window options
  local win_config = {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  }

  -- Open the floating window
  local win = vim.api.nvim_open_win(buf, true, win_config)

  return {
    buf = buf,
    win = win,
  }
end

local toggle_terminal = function(opts) 
  if not vim.api.nvim_win_is_valid(state.floating.win) then
    state.floating = create_floating_window({ buf = state.floating.buf })
    if vim.bo[state.floating.buf].buftype ~= "terminal" then
      vim.cmd.terminal()
    end
  else
    vim.api.nvim_win_hide(state.floating.win)
  end
end

vim.api.nvim_create_user_command("Floaterminal", toggle_terminal, {})
