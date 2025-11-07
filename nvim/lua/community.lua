-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.pack.lua" },

  -- AI
  { import = "astrocommunity.ai.opencode-nvim" },

  -- Bars and lines
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  { import = "astrocommunity.bars-and-lines.scope-nvim" },
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },

  -- Code runners
  { import = "astrocommunity.code-runner.overseer-nvim" },

  -- Color
  { import = "astrocommunity.color.headlines-nvim" },

  -- Color scheme
  { import = "astrocommunity.colorscheme.catppuccin" },

  -- Completion
  { import = "astrocommunity.completion.avante-nvim" },
  -- { import = "astrocommunity.completion.blink-cmp-git" },
  { import = "astrocommunity.completion.blink-cmp" },

  -- Debugging
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },

  -- Diagnostics
  -- { import = "astrocommunity.diagnostics.error-lens-nvim" },
  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  -- { import = "astrocommunity.diagnostics.trouble-nvim" },

  -- Docker
  { import = "astrocommunity.docker.lazydocker" },

  -- Editing support
  { import = "astrocommunity.editing-support.auto-save-nvim" },
  { import = "astrocommunity.editing-support.codecompanion-nvim" },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  -- { import = "astrocommunity.editing-support.nvim-context-vt" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.editing-support.rainbow-delimiters-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.rustowl" },

  -- Fuzzy finders
  { import = "astrocommunity.fuzzy-finder.telescope-nvim" },

  -- Git
  { import = "astrocommunity.git.blame-nvim" },
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.gitgraph-nvim" },

  -- Indent
  { import = "astrocommunity.indent.indent-blankline-nvim" },
  -- { import = "astrocommunity.indent.indent-rainbowline" },
  { import = "astrocommunity.indent.indent-tools-nvim" },
  { import = "astrocommunity.indent.snacks-indent-hlchunk" },

  -- LSP
  { import = "astrocommunity.lsp.actions-preview-nvim" },
  { import = "astrocommunity.lsp.inc-rename-nvim" },
  { import = "astrocommunity.lsp.lsp-lens-nvim" },
  { import = "astrocommunity.lsp.lsp-signature-nvim" },
  { import = "astrocommunity.lsp.nvim-lsp-file-operations" },

  -- Markdown
  { import = "astrocommunity.markdown-and-latex.markdown-preview-nvim" },

  -- Media
  { import = "astrocommunity.media.codesnap-nvim" },
  { import = "astrocommunity.media.cord-nvim" },

  -- Pack
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.pack.python-ruff" },
  { import = "astrocommunity.pack.rust" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.xml" },
  { import = "astrocommunity.pack.yaml" },

  -- Quickfix
  { import = "astrocommunity.quickfix.nvim-bqf" },

  -- Recipes
  { import = "astrocommunity.recipes.auto-session-restore" },
  { import = "astrocommunity.recipes.diagnostic-virtual-lines-current-line" },

  -- Scrolling
  { import = "astrocommunity.scrolling.neoscroll-nvim" },

  -- Test
  { import = "astrocommunity.test.neotest" },

  -- Utility
  -- { import = "astrocommunity.utility.hover-nvim" },
  { import = "astrocommunity.utility.neodim" },

  -- import/override with your plugins folder
}
