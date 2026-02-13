return {
  'nvim-telescope/telescope.nvim', 
  tag = 'v0.2.0',

  enabled = false,

  dependencies = { 
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },

  keys = {
    {
      "<C-f>",
      function() 
        require('telescope.builtin').git_files()
      end,
      mode = "n",
      desc = "Show all git files in current repository",
    },
  },

  opts = {
      defaults = {
        mappings = {
          i = {
            -- Custom mapping for moving to the next item in Insert mode
            ["<C-j>"] = function() require("telescope.actions").move_selection_next() end,
            -- Custom mapping for moving to the previous item in Insert mode
            ["<C-k>"] = function() require("telescope.actions").move_selection_previous() end,
          },
        },
      },
  }
}
