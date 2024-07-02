return {
  { "scrooloose/nerdcommenter" },

  { "tpope/vim-surround" },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    opts = {}     -- this is equalent to setup({}) function}
  },

  {
    "LunarVim/bigfile.nvim",
    event = 'BufReadPre',
    opts = {}
  }
}
