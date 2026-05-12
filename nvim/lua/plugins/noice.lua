---@type LazySpec
return {
  "folke/noice.nvim",
  opts = function(_, opts)
    opts.routes = opts.routes or {}
    -- Silence the Neovim 0.11+ deprecation warning for `require('lspconfig')`
    -- and its accompanying stack trace.
    table.insert(opts.routes, {
      filter = {
        event = "notify",
        warning = true,
        any = {
          { find = "require%('lspconfig'%)" },
          { find = "lspconfig%.lua:.*in function '__index'" },
          { find = "stack traceback:" }, -- Fallback: the trace is usually fired right after
        },
      },
      opts = { skip = true },
    })
  end,
}