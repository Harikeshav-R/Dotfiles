---@type LazySpec
return {
  "akinsho/toggleterm.nvim",
  opts = {
    shell = vim.fn.executable "nu" == 1 and "nu" or nil,
  },
}
