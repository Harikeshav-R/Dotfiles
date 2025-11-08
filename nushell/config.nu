# config.nu
#
# Installed by:
# version = "0.108.0"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# Nushell sets "sensible defaults" for most configuration settings, 
# so your `config.nu` only needs to override these defaults if desired.
#
# You can open this file in your default editor using:
#     config nu
#
# You can also pretty-print and page through the documentation for configuration
# options using:
#     config nu --doc | nu-highlight | less -R

# PATH configuration
use std/util "path add"
path add "/opt/homebrew/bin"
path add "/opt/homebrew/sbin"
$env.path ++= ["~/.local/bin"]
$env.path ++= ["~/.dotnet/tools"]
$env.path ++= ["/usr/local/share/dotnet"]

# Set default editor to nvim
$env.config.buffer_editor = "edit"
$env.EDITOR = "edit"

# Use system `open` command
alias nu-open = open
alias open = ^open

# Aliases

alias venv-activate = overlay use .venv/bin/activate.nu

alias lsl = ls -l
alias lsa = ls -a

alias rmrf = rm --recursive

alias bi = brew install
alias bic = brew install --cask

# alias edit = neovide --frame transparent --maximized --fork

alias avante = neovide --frame transparent --maximized --fork -- -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"

# Misc nu settings
$env.config.display_errors.exit_code = true
$env.config.rm.always_trash = false
$env.config.edit_mode = "vi"

# Colorscheme
source "~/library/Application Support/nushell/colorschemes/catppuccin_mocha.nu"

# Spicetify
$env.SPICETIFY_INSTALL = "~/.spicetify"
$env.path ++= ["~/.spicetify"]

# Cargo
source $"($nu.home-path)/.cargo/env.nu"

# Starship
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
