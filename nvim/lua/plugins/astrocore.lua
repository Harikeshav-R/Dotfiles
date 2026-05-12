-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    -- Configure core features of AstroNvim
    features = {
      large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
      autopairs = true, -- enable autopairs at start
      cmp = true, -- enable completion at start
      diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
      highlighturl = true, -- highlight URLs at start
      notifications = true, -- enable notifications at start
    },
    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    diagnostics = {
      virtual_text = true,
      underline = true,
    },
    -- passed to `vim.filetype.add`
    filetypes = {
      -- see `:h vim.filetype.add` for usage
      extension = {
        foo = "fooscript",
      },
      filename = {
        [".foorc"] = "fooscript",
      },
      pattern = {
        [".*/etc/foo/.*"] = "fooscript",
      },
    },
    -- vim options can be configured here
    options = {
      opt = { -- vim.opt.<key>
        relativenumber = true, -- sets vim.opt.relativenumber
        number = true, -- sets vim.opt.number
        spell = false, -- sets vim.opt.spell
        signcolumn = "yes", -- sets vim.opt.signcolumn to yes
        wrap = false, -- sets vim.opt.wrap
      },
      g = { -- vim.g.<key>
        -- configure global vim variables (vim.g)
        -- NOTE: `mapleader` and `maplocalleader` must be set in the AstroNvim opts or before `lazy.setup`
        -- This can be found in the `lua/lazy_setup.lua` file
      },
    },
    -- Mappings can be configured through AstroCore as well.
    -- NOTE: keycodes follow the casing in the vimdocs. For example, `<Leader>` must be capitalized
    mappings = {
      -- first key is the mode
      n = {
        -- second key is the lefthand side of the map

        -- navigate buffer tabs
        ["]b"] = { function() require("astrocore.buffer").nav(vim.v.count1) end, desc = "Next buffer" },
        ["[b"] = { function() require("astrocore.buffer").nav(-vim.v.count1) end, desc = "Previous buffer" },

        -- mappings seen under group name "Buffer"
        ["<Leader>bd"] = {
          function()
            require("astroui.status.heirline").buffer_picker(
              function(bufnr) require("astrocore.buffer").close(bufnr) end
            )
          end,
          desc = "Close buffer from tabline",
        },

        -- tables with just a `desc` key will be registered with which-key if it's installed
        -- this is useful for naming menus
        -- ["<Leader>b"] = { desc = "Buffers" },

        -- setting a mapping to false will disable it
        -- ["<C-S>"] = false,

        -- AI / Avante prefix
        ["<Leader>a"] = { desc = "AI (Avante)" },

        -- Harpoon mappings
        ["<Leader>h"] = { desc = "Harpoon" },
        ["<Leader>ha"] = { function() require("harpoon"):list():add() end, desc = "Harpoon Add file" },
        ["<Leader>hh"] = { function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Menu" },
        ["<C-e>"] = { function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Harpoon Menu (Alt)" },
        ["<C-1>"] = { function() require("harpoon"):list():select(1) end, desc = "Harpoon File 1" },
        ["<C-2>"] = { function() require("harpoon"):list():select(2) end, desc = "Harpoon File 2" },
        ["<C-3>"] = { function() require("harpoon"):list():select(3) end, desc = "Harpoon File 3" },
        ["<C-4>"] = { function() require("harpoon"):list():select(4) end, desc = "Harpoon File 4" },

        -- Diagnostics (Trouble)
        ["<Leader>x"] = { desc = "Diagnostics (Trouble)" },
        ["<Leader>xx"] = { "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
        ["<Leader>xX"] = { "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer Diagnostics (Trouble)" },
        ["<Leader>xs"] = { "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols (Trouble)" },
        ["<Leader>xl"] = { "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP Definitions / references / ... (Trouble)" },
        ["<Leader>xL"] = { "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
        ["<Leader>xq"] = { "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix List (Trouble)" },

        -- Git (Diffview)
        ["<Leader>gd"] = { "<cmd>DiffviewOpen<cr>", desc = "Diffview Open" },
        ["<Leader>gh"] = { "<cmd>DiffviewFileHistory %<cr>", desc = "Diffview File History" },
        ["<Leader>gx"] = { "<cmd>DiffviewClose<cr>", desc = "Diffview Close" },

        -- Database (Dadbod)
        ["<Leader>D"] = { desc = "Database" },
        ["<Leader>Du"] = { "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
        ["<Leader>Df"] = { "<cmd>DBUIFindBuffer<cr>", desc = "Find DBUI Buffer" },
        ["<Leader>Dr"] = { "<cmd>DBUIRenameBuffer<cr>", desc = "Rename DBUI Buffer" },
        ["<Leader>Dl"] = { "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },

        -- Search & Replace (Spectre)
        ["<Leader>S"] = { desc = "Search / Replace (Spectre)" },
        ["<Leader>Ss"] = { function() require("spectre").toggle() end, desc = "Toggle Spectre" },
        ["<Leader>Sw"] = { function() require("spectre").open_visual({select_word=true}) end, desc = "Search current word" },
        ["<Leader>Sf"] = { function() require("spectre").open_file_search({select_word=true}) end, desc = "Search on current file" },

        -- Refactoring
        ["<Leader>R"] = { desc = "Refactoring" },
        ["<Leader>Re"] = { function() require('refactoring').refactor('Extract Function') end, desc = "Extract Function" },
        ["<Leader>Rf"] = { function() require('refactoring').refactor('Extract Function To File') end, desc = "Extract Function To File" },
        ["<Leader>Rv"] = { function() require('refactoring').refactor('Extract Variable') end, desc = "Extract Variable" },
        ["<Leader>Ri"] = { function() require('refactoring').refactor('Inline Variable') end, desc = "Inline Variable" },
        ["<Leader>Rb"] = { function() require('refactoring').refactor('Extract Block') end, desc = "Extract Block" },
        ["<Leader>RB"] = { function() require('refactoring').refactor('Extract Block To File') end, desc = "Extract Block To File" },

        -- Undo (Undotree)
        ["<Leader>U"] = { "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },

        -- Editing Support
        ["<Leader>T"] = { "<cmd>TodoTelescope<cr>", desc = "Find TODOs" },
        ["<Leader>cb"] = { desc = "Comment Box" },
        ["<Leader>cbb"] = { "<cmd>CBbox<cr>", desc = "Comment Box" },
        ["<Leader>cbl"] = { "<cmd>CBline<cr>", desc = "Comment Line" },

        -- Testing (Neotest)
        ["<Leader>n"] = { desc = "Testing (Neotest)" },
        ["<Leader>nr"] = { function() require("neotest").run.run() end, desc = "Run nearest test" },
        ["<Leader>nf"] = { function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run current file" },
        ["<Leader>nd"] = { function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug nearest test" },
        ["<Leader>ns"] = { function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
        ["<Leader>no"] = { function() require("neotest").output.open({ enter = true }) end, desc = "Show output" },
        ["<Leader>np"] = { function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },

        -- Tasks (Overseer / Compiler)
        ["<Leader>o"] = { desc = "Tasks (Overseer)" },
        ["<Leader>oo"] = { "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
        ["<Leader>or"] = { "<cmd>OverseerRun<cr>", desc = "Run Task" },
        ["<Leader>oi"] = { "<cmd>OverseerInfo<cr>", desc = "Overseer Info" },
        ["<Leader>ob"] = { "<cmd>OverseerBuild<cr>", desc = "Overseer Build" },
        ["<Leader>oa"] = { "<cmd>OverseerTaskAction<cr>", desc = "Task Action" },

        -- Compiler UI
        ["<Leader>m"] = { desc = "Compiler (Menu)" },
        ["<Leader>mm"] = { "<cmd>CompilerOpen<cr>", desc = "Open Compiler Menu" },
        ["<Leader>mr"] = { "<cmd>CompilerRedo<cr>", desc = "Redo Last Compilation" },
        ["<Leader>mt"] = { "<cmd>CompilerToggleResults<cr>", desc = "Toggle Compilation Results" },

        -- Markdown
        ["<Leader>M"] = { desc = "Markdown" },
        ["<Leader>Mm"] = { "<cmd>MarkmapOpen<cr>", desc = "Open Mindmap (Markmap)" },
        ["<Leader>Mt"] = { "<cmd>MarkmapWatch<cr>", desc = "Watch Mindmap (Markmap)" },

        -- Oil
        ["<Leader>O"] = { function() require("oil").open() end, desc = "Open Oil" },
        ["-"] = { function() require("oil").open() end, desc = "Open Oil" },

        -- Zoxide
        ["<Leader>fz"] = { "<cmd>Telescope zoxide list<cr>", desc = "Find Zoxide" },

        -- SnipRun
        ["<Leader>os"] = { "<cmd>SnipRun<cr>", desc = "SnipRun" },

        -- DevDocs
        ["<Leader>K"] = { desc = "Knowledge (Docs/Notes)" },
        ["<Leader>Kd"] = { "<cmd>DevdocsOpen<cr>", desc = "Open DevDocs" },
        ["<Leader>Kf"] = { "<cmd>DevdocsOpenFloat<cr>", desc = "Open DevDocs (Float)" },

        -- Obsidian
        ["<Leader>N"] = { desc = "Notes (Obsidian)" },
        ["<Leader>No"] = { "<cmd>ObsidianOpen<cr>", desc = "Open in Obsidian" },
        ["<Leader>Nn"] = { "<cmd>ObsidianNew<cr>", desc = "New Note" },
        ["<Leader>Ns"] = { "<cmd>ObsidianSearch<cr>", desc = "Search Notes" },
        ["<Leader>Nt"] = { "<cmd>ObsidianTemplate<cr>", desc = "Insert Template" },

        -- Color
        ["<Leader>C"] = { desc = "Color" },
        ["<Leader>Cc"] = { "<cmd>CccPick<cr>", desc = "Color Picker" },
        ["<Leader>Cv"] = { "<cmd>CccConvert<cr>", desc = "Color Convert" },
      },
      v = {
        -- Visual mode refactoring
        ["<Leader>R"] = { desc = "Refactoring" },
        ["<Leader>Re"] = { function() require('refactoring').refactor('Extract Function') end, desc = "Extract Function" },
        ["<Leader>Rf"] = { function() require('refactoring').refactor('Extract Function To File') end, desc = "Extract Function To File" },
        ["<Leader>Rv"] = { function() require('refactoring').refactor('Extract Variable') end, desc = "Extract Variable" },
        ["<Leader>Ri"] = { function() require('refactoring').refactor('Inline Variable') end, desc = "Inline Variable" },

        -- SnipRun
        ["<Leader>os"] = { "<cmd>SnipRun<cr>", desc = "SnipRun" },
      }
    },
  },
}
