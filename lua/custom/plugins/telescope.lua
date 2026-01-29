return {
  'nvim-telescope/telescope.nvim', 
  tag = 'v0.2.0',
  dependencies = { 
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  },
  config = function()
    vim.keymap.set("n", "<C-f>", require('telescope.builtin').git_files)
    vim.keymap.set("n", "<space>ff", require('telescope.builtin').find_files)

    local telescope = require("telescope")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            -- Custom mapping for moving to the next item in Insert mode
            ["<C-j>"] = require("telescope.actions").move_selection_next,
            -- Custom mapping for moving to the previous item in Insert mode
            ["<C-k>"] = require("telescope.actions").move_selection_previous,
          },
        },
      },
    })

  end
}
