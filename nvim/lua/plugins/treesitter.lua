---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      highlight = true, -- enable/disable treesitter based highlighting
      indent = true, -- enable/disable treesitter based indentation
      auto_install = true, -- enable/disable automatic installation of detected languages
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "python",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "css",
        "json",
        "yaml",
        "markdown",
        "markdown_inline",
        "bash",
        "rust",
        "go",
        "cpp",
        "nu",
      },
    },
  },
}
