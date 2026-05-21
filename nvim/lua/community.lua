-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- UI / Aesthetics
  { import = "astrocommunity.colorscheme.catppuccin" },
  { import = "astrocommunity.utility.noice-nvim" },
  { import = "astrocommunity.bars-and-lines.dropbar-nvim" },
  { import = "astrocommunity.recipes.heirline-vscode-winbar" },
  { import = "astrocommunity.scrolling.mini-animate" },
  { import = "astrocommunity.scrolling.neoscroll-nvim" },
  { import = "astrocommunity.scrolling.satellite-nvim" },
  { import = "astrocommunity.indent.mini-indentscope" },
  { import = "astrocommunity.pack.rainbow-delimiter-indent-blankline" },
  { import = "astrocommunity.color.ccc-nvim" },
  { import = "astrocommunity.startup.alpha-nvim" },
  { import = "astrocommunity.bars-and-lines.smartcolumn-nvim" },

  -- Languages
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.typescript-all-in-one" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.eslint" },
  { import = "astrocommunity.pack.prettier" },
  { import = "astrocommunity.pack.python.base" },
  { import = "astrocommunity.pack.python.basedpyright" },
  { import = "astrocommunity.pack.python.ruff" },
  { import = "astrocommunity.pack.toml" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.markdown" },
  { import = "astrocommunity.markdown-and-latex.render-markdown-nvim" },
  -- { import = "astrocommunity.markdown-and-latex.markmap-nvim" },
  { import = "astrocommunity.color.headlines-nvim" },
  { import = "astrocommunity.pack.rust" },
  -- { import = "astrocommunity.pack.go" }, -- Requires 'go' to be installed on the system
  { import = "astrocommunity.pack.ruby" },
  { import = "astrocommunity.pack.bash" },
  { import = "astrocommunity.pack.terraform" },
  { import = "astrocommunity.pack.proto" },
  -- { import = "astrocommunity.pack.sql" }, -- Some SQL tools require 'go'
  { import = "astrocommunity.pack.just" },
  { import = "astrocommunity.pack.cmake" },
  { import = "astrocommunity.pack.cpp" },
  { import = "astrocommunity.pack.docker" },

  -- AI Integrations
  { import = "astrocommunity.completion.copilot-lua" },
  { import = "astrocommunity.completion.blink-copilot" },

  -- Completion (Blink)
  { import = "astrocommunity.completion.blink-cmp" },
  { import = "astrocommunity.completion.blink-cmp-git" },
  { import = "astrocommunity.completion.blink-cmp-emoji" },

  -- Diagnostics
  { import = "astrocommunity.diagnostics.trouble-nvim" },
  { import = "astrocommunity.diagnostics.tiny-inline-diagnostic-nvim" },
  { import = "astrocommunity.diagnostics.lsp_lines-nvim" },

  -- Git
  { import = "astrocommunity.git.diffview-nvim" },
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.blame-nvim" },

  -- Motion
  { import = "astrocommunity.motion.flash-nvim" },
  { import = "astrocommunity.motion.mini-ai" },
  { import = "astrocommunity.motion.mini-surround" },

  -- Search / Fuzzy Finder
  { import = "astrocommunity.search.grug-far-nvim" },
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },
  { import = "astrocommunity.editing-support.telescope-undo-nvim" },

  -- Editing Support
  { import = "astrocommunity.editing-support.todo-comments-nvim" },
  { import = "astrocommunity.editing-support.nvim-treesitter-context" },
  { import = "astrocommunity.editing-support.vim-visual-multi" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },
  { import = "astrocommunity.editing-support.undotree" },
  { import = "astrocommunity.editing-support.comment-box-nvim" },
  { import = "astrocommunity.editing-support.nvim-devdocs" },
  { import = "astrocommunity.editing-support.zen-mode-nvim" },
  { import = "astrocommunity.color.twilight-nvim" },
  { import = "astrocommunity.editing-support.yanky-nvim" },

  -- File Explorer
  { import = "astrocommunity.file-explorer.oil-nvim" },

  -- Project Management
  { import = "astrocommunity.project.project-nvim" },

  -- Media / Analytics / Social
  { import = "astrocommunity.media.image-nvim" },
  -- { import = "astrocommunity.media.vim-wakatime" },
  { import = "astrocommunity.media.presence-nvim" },

  -- Note Taking
  { import = "astrocommunity.note-taking.obsidian-nvim" },

  -- Database
  { import = "astrocommunity.pack.full-dadbod" },

  -- Recipes / Sessions
  { import = "astrocommunity.recipes.auto-session-restore" },

  -- Workflow / Testing / Debugging
  { import = "astrocommunity.motion.harpoon" },
  { import = "astrocommunity.test.neotest" },
  { import = "astrocommunity.code-runner.overseer-nvim" },
  { import = "astrocommunity.code-runner.compiler-nvim" },
  { import = "astrocommunity.code-runner.sniprun" },
  { import = "astrocommunity.debugging.nvim-dap-virtual-text" },
  { import = "astrocommunity.debugging.nvim-dap-repl-highlights" },
  { import = "astrocommunity.debugging.telescope-dap-nvim" },
  { import = "astrocommunity.debugging.persistent-breakpoints-nvim" },
}
