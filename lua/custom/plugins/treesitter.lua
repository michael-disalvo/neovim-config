return {
  {
    "nvim-treesitter/nvim-treesitter", 
    branch = master, 
    lazy = false, 
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
	    ensure_installed = { "c", "lua", "vim", "rust", "c", "go", "python"},
        highlight = {
          enable = true,
          disable = { "rust", "go" }
        },
     }
    end,
  }
}
