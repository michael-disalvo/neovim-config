local M = {}

M.setup = function()
  -- nothing
end


local function create_floating_window(config)
  opts = opts or {}

  local buf = vim.api.nvim_create_buf(false, true)

  local win = vim.api.nvim_open_win(buf, true, config)

  return {
    buf = buf,
    win = win,
  }
end

---@class present.Slides
---@fields slides present.Slide[]: The slides of the file 

---@class present.Slide
---@field title string: the title of slide
---@field body string[]: the body of slide

--- Takes some lines and parses them
--- @param lines string[]: The lines in the buffer 
--- @return present.Slides
local parse_slides = function(lines)
  local slides = { slides = {} }

  local current_slide = {
    title = "",
    body = {}
  }

  local separator = "^#"
  for _, line in ipairs(lines) do 
    if line:find(separator) then 
      -- if current_slide is inititalized, then insert
      if #current_slide.title > 0 then
        table.insert(slides.slides, current_slide)
      end
      -- start the new current slide
      current_slide = {
        title = line,
        body = {}
      }
    else
      table.insert(current_slide.body, line)
    end
  end

  if #current_slide.title > 0 then
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

  -- local win_config = {
  --   relative = "editor",
  --   width = width,
  --   height = height,
  --   row = row,
  --   col = col,
  --   style = "minimal",
  --   border = { " ", " ", " ", " ", " ", " ", " ", " ", }
  -- }

  local width = vim.o.columns
  local height = vim.o.lines

  ---@type keyset.win_config
  local windows = {
    background = {
      relative = "editor",
      width = width,
      height = height,
      style = "minimal",
      col = 0,
      row = 0,
      zindex = 1, 
    },
    header = {
      relative = "editor",
      width = width,
      height = 1,
      style = "minimal",
      border = "rounded",
      col = 0,
      row = 0,
      zindex = 3,
    },
    body = {
      relative = "editor",
      width = width - 8,
      height = height - 5,
      style = "minimal",
      border = { " ", " ", " ", " ", " ", " ", " ", " " },
      col = 8,
      row = 4,
    }
    -- footer = {}
  }

  local background = create_floating_window(windows.background)
  local header = create_floating_window(windows.header)
  local body = create_floating_window(windows.body)

  vim.bo[header.buf].filetype = "markdown"
  vim.bo[body.buf].filetype = "markdown"

  local set_slide_content = function(idx) 
    local slide = parsed.slides[idx]
    local padding = string.rep(" ", (width - #slide.title) / 2)
    local title = padding .. slide.title
    vim.api.nvim_buf_set_lines(header.buf, 0, -1, false, { title })
    vim.api.nvim_buf_set_lines(body.buf, 0, -1, false, slide.body)
  end

  local current_slide = 1
  vim.keymap.set("n", "n", function() 
    current_slide = math.min(current_slide + 1, #parsed.slides)
    set_slide_content(current_slide)
  end, {
    buffer = body.buf -- sets these keymaps to only work inside the buffer attached to the floating window
  })

  vim.keymap.set("n", "p", function() 
    current_slide = math.max(current_slide - 1 , 1)
    set_slide_content(current_slide)
  end, {
    buffer = body.buf
  })

  vim.keymap.set("n", "q", function() 
    vim.api.nvim_win_close(header.win, true)
    vim.api.nvim_win_close(body.win, true)
    vim.api.nvim_win_close(background.win, true)
  end, { buffer = body.buf })

  local restore = {
    cmdheight = {
      original = vim.o.cmdheight,
      present = 0,
    }
  }

  -- set the options we want during presentation
  for option, config in pairs(restore) do 
    vim.opt[option] = config.present
  end

  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = body.buf,
    callback = function() 
      -- reset the values when we are done with the presentation
      for option, config in pairs(restore) do
        vim.opt[option] = config.original
      end
    end
  })

  set_slide_content(current_slide)
end

-- parse_slides( {
--   "# Hellow",
--   "this is something else",
--   "# World",
--   "this is another",
-- })

M.start_presentation( { bufnr = 5 } )

return M
