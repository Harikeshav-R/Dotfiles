# Nushell Environment Config File

def create_left_prompt [] {
    let dir = match (do -i { $env.PWD | path relative-to $nu.home-dir }) {
        null => $env.PWD
        '' => '~'
        $relative_pwd => ([~ $relative_pwd] | path join)
    }

    let path_color = (if (is-admin) { ansi red_bold } else { ansi green_bold })
    let separator_color = (if (is-admin) { ansi light_red_bold } else { ansi light_green_bold })
    let path_segment = $"($path_color)($dir)(ansi reset)"

    $path_segment | str replace --all (char path_sep) $"($separator_color)(char path_sep)($path_color)"
}

$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = {|| "" }

$env.PROMPT_INDICATOR = {|| " ❯ " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| " : " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| " 〉" }
$env.PROMPT_MULTILINE_INDICATOR = {|| " ::: " }

# Append useful directories to PATH
$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend /opt/homebrew/bin
    | append /usr/local/bin
    | append $"($env.HOME)/.cargo/bin"
    | append $"($env.HOME)/.local/bin"
    | uniq
)

# Load Cargo Env
source ~/.cargo/env.nu
source ~/.cache/starship/init.nu

# Vivid LS_COLORS
$env.LS_COLORS = (vivid generate catppuccin-mocha | str trim)

# Yazi directory jumper
def --env yy [] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$in --cwd-file $tmp
	let cwd = (open $tmp)
	if cwd != "" and cwd != $env.PWD {
		cd $cwd
	}
	rm -f $tmp
}
