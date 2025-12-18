local line_only = function()
  return string.format(' %l ')
end

return { 
  {
    "echasnovski/mini.nvim",
    enabled = true,
    config = function() 
      local statusline = require 'mini.statusline'
      statusline.setup { 
        use_icons = true,
      }

      local icons = require 'mini.icons'
      icons.setup({})

      local git = require 'mini.git'
      git.setup({})
    end
  }
}

