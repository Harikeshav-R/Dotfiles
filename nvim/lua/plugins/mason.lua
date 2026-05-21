---@type LazySpec
return {
  -- use mason-tool-installer for automatically installing Mason packages
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- overrides `require("mason-tool-installer").setup(...)`
    opts = {
      -- Make sure to use the names found in `:Mason`
      ensure_installed = {
        -- LSPs
        "basedpyright",
        "bash-language-server",
        "clangd",
        "css-lsp",
        "deno",
        "docker-language-server",
        "emmet-ls",
        "eslint-lsp",
        "html-lsp",
        "json-lsp",
        "just-lsp",
        "lua-language-server",
        "marksman",
        "neocmakelsp",
        "ruby-lsp",
        "tailwindcss-language-server",
        "taplo",
        "terraform-ls",
        "vtsls",
        "yaml-language-server",

        -- Formatters / Linters
        "buf",
        "clang-format",
        "cpplint",
        "hadolint",
        "prettierd",
        "rubyfmt",
        "ruff",
        "selene",
        "shellcheck",
        "shfmt",
        "sqlfluff",
        "stylua",
        "tflint",
        "tfsec",

        -- Debuggers
        "bash-debug-adapter",
        "codelldb",
        "debugpy",
        "js-debug-adapter",

        -- Other Tools
        "bacon",
        "pyrefly",
        "tree-sitter-cli",
        "ty",
      },
    },
  },
}
