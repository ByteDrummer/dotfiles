return {
  debug_open = false,

  tree_toggle = function (self)
    require 'dapui'.close()
    self.debug_open = false

    vim.cmd("NvimTreeToggle")
    if require 'nvim-tree.view'.is_visible() then
      require 'bufferline.api'.set_offset(34, '')
    else
      require 'bufferline.api'.set_offset(0)
    end
  end,

  outline_toggle = function(self)
    if self.debug_open then
      require 'dapui'.close()
      self.debug_open = false
      require 'bufferline.api'.set_offset(0)
    end

    vim.cmd('SymbolsOutline')
  end,

  debug_toggle = function(self)
    ---@diagnostic disable-next-line: param-type-mismatch
    pcall(vim.cmd, 'SymbolsOutlineClose')
    vim.cmd('NvimTreeClose')

    require 'dapui'.toggle { reset = true }
    self.debug_open = not self.debug_open

    if self.debug_open then
      require 'bufferline.api'.set_offset(40, '')
    else
      require 'bufferline.api'.set_offset(0)
    end
  end
}
