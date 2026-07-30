# Compact completed prompts while keeping the active Starship prompt intact.

$env.TRANSIENT_PROMPT_COMMAND = {||
    let color = if $env.LAST_EXIT_CODE == 0 {
        ansi green_bold
    } else {
        ansi red_bold
    }

    $"($color)❯(ansi reset) "
}
