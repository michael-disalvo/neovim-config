return {
  'junegunn/fzf.vim',

  enabled = true,

  keys = {
    {
      "<C-f>",
      ":GFiles<CR>",
      mode = "n",
      desc = "Show all git files in current repository",
    }
  },

  config = function()
    vim.g.fzf_action = {
      ["ctrl-s"] = "vsplit",
      ["ctrl-t"] = "tab split",
    }
  end,
}
