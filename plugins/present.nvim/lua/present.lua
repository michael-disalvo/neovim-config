local M = {}

M.setup = function()
  -- nothing
end


local function create_floating_window(opts)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, true)

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

---@class present.Slides
---@fields slides stirng[]: The slides of the file 

--- Takes some lines and parses them
--- @param lines string[]: The lines in the buffer 
--- @return present.Slides
local parse_slides = function(lines)
  local slides = { slides = {} }
  local current_slide = {}

  local separator = "^#"
  for _, line in ipairs(lines) do 
    if line:find(separator) then 
      if #current_slide > 0 then
        table.insert(slides.slides, current_slide)
      end
      current_slide = {}
    end

    table.insert(current_slide, line)
  end

  if #current_slide > 0 then
    table.insert(slides.slides, current_slide)
  end

  return slides
  -- nothing
end

M.start_presentation = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0

  local lines = vim.api.nvim_buf_get_lines(opts.bufnr, 0, -1, false)
  local parsed = parse_slides(lines)
  local float = create_floating_window()

  local current_slide = 1
  vim.keymap.set("n", "n", function() 
    current_slide = math.min(current_slide + 1 , #parsed.slides)
    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[current_slide])
  end, {
    buffer = float.buf -- sets these keymaps to only work inside the buffer attached to the floating window
  })

  vim.keymap.set("n", "p", function() 
    current_slide = math.max(current_slide - 1 , 1)
    vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[current_slide])
  end, {
    buffer = float.buf
  })

  vim.keymap.set("n", "q", function() 
    vim.api.nvim_win_close(float.win, true)
  end)

  vim.api.nvim_buf_set_lines(float.buf, 0, -1, false, parsed.slides[1])
end

-- vim.print(parse_slides( {
--   "# Hellow",
--   "this is something else",
--   "# World",
--   "this is another",
-- }))

-- M.start_presentation( { bufnr = 4 } )

return M
