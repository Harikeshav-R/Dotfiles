# Nushell Config File

# Catppuccin Mocha Theme
let catppuccin_mocha = {
    separator: "#9399b2"
    leading_trailing_space_bg: { attr: "n" }
    header: { fg: "#a6e3a1" attr: "b" }
    empty: "#89b4fa"
    bool: {|| if $in { "#89dceb" } else { "light_gray" } }
    int: "#9399b2"
    filesize: {|e|
        if $e == 0b {
            "#9399b2"
        } else if $e < 1mb {
            "#89dceb"
        } else {{ fg: "#89b4fa" }}
    }
    duration: "#9399b2"
    datetime: { fg: "#f38ba8" attr: "b" }
    range: "#9399b2"
    float: "#9399b2"
    string: "#9399b2"
    nothing: "#9399b2"
    binary: "#9399b2"
    cell-path: "#9399b2"
    row_index: { fg: "#a6e3a1" attr: "b" }
    record: "#9399b2"
    list: "#9399b2"
    block: "#9399b2"
    hints: "dark_gray"
    search_result: { fg: "#1e1e2e" bg: "#f38ba8" }

    shape_and: { fg: "#cba6f7" attr: "b" }
    shape_binary: { fg: "#cba6f7" attr: "b" }
    shape_block: { fg: "#89b4fa" attr: "b" }
    shape_bool: "#89dceb"
    shape_closure: { fg: "#a6e3a1" attr: "b" }
    shape_custom: "#a6e3a1"
    shape_datetime: { fg: "#89dceb" attr: "b" }
    shape_directory: "#89dceb"
    shape_external: "#89dceb"
    shape_externalarg: { fg: "#a6e3a1" attr: "b" }
    shape_filepath: "#89dceb"
    shape_flag: { fg: "#89b4fa" attr: "b" }
    shape_float: { fg: "#cba6f7" attr: "b" }
    shape_garbage: { fg: "#FFFFFF" bg: "#FF0000" attr: "b" }
    shape_globpattern: { fg: "#89dceb" attr: "b" }
    shape_int: { fg: "#cba6f7" attr: "b" }
    shape_internalcall: { fg: "#89dceb" attr: "b" }
    shape_keyword: { fg: "#cba6f7" attr: "b" }
    shape_list: { fg: "#89dceb" attr: "b" }
    shape_literal: "#89b4fa"
    shape_match_pattern: "#a6e3a1"
    shape_matching_brackets: { attr: "u" }
    shape_nothing: "#89dceb"
    shape_operator: "#f9e2af"
    shape_or: { fg: "#cba6f7" attr: "b" }
    shape_pipe: { fg: "#cba6f7" attr: "b" }
    shape_range: { fg: "#f9e2af" attr: "b" }
    shape_record: { fg: "#89dceb" attr: "b" }
    shape_redirection: { fg: "#cba6f7" attr: "b" }
    shape_signature: { fg: "#a6e3a1" attr: "b" }
    shape_string: "#a6e3a1"
    shape_string_interpolation: { fg: "#89dceb" attr: "b" }
    shape_table: { fg: "#89b4fa" attr: "b" }
    shape_variable: "#cba6f7"
    shape_vardecl: "#cba6f7"
}

$env.config = {
    show_banner: false
    ls: {
        use_ls_colors: true
        clickable_links: true
    }
    rm: {
        always_trash: false
    }
    table: {
        mode: rounded
        index_mode: always
        show_empty: true
    }
    history: {
        max_size: 100_000
        sync_on_enter: true
        file_format: "plaintext"
        isolation: false
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
    }
    color_config: $catppuccin_mocha
    cursor_shape: {
        emacs: line
        vi_insert: line
        vi_normal: block
    }
    edit_mode: emacs
}

# Aliases
alias ll = eza -l -g --icons
alias la = eza -a -l -g --icons
alias l = eza --icons
alias tree = eza --tree --icons
alias cat = bat
alias v = nvim

# Load zoxide
source ~/.cache/zoxide/init.nu

# Load carapace
source ~/.cache/carapace/init.nu

# Load atuin
source ~/.cache/atuin/init.nu

# Direnv Integration
$env.config.hooks.env_change.PWD = ($env.config.hooks.env_change.PWD? | default [])
$env.config.hooks.env_change.PWD ++= [
    { ||
        if (which direnv | is-empty) {
            return
        }
        direnv export json | from json | default {} | load-env
        if "PATH" in $env {
            $env.PATH = ($env.PATH | split row (char esep))
        }
    }
]

# Maximalist Workflow Tools
alias lg = lazygit

# Fuzzy find and edit file (using fd, fzf, nvim)
def --env fv [] {
    let file = (fd --type f --hidden --exclude .git | fzf)
    if ($file != "") {
        nvim $file
    }
}

# Fuzzy cd into directory
def --env fcd [] {
    let dir = (fd --type d --hidden --exclude .git | fzf)
    if ($dir != "") {
        cd $dir
    }
}

# Run fastfetch on startup to complete the maximalist aesthetic
fastfetch
