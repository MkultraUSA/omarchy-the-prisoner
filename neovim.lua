-- The Prisoner: dark editor palette matching the hand-tuned terminal palettes.
-- Omarchy would otherwise generate Neovim colors from the light colors.toml,
-- which puts dark text on the charcoal terminal background.
-- Only the full install (install.sh) uses this file; `omarchy theme install`
-- skips theme Lua and keeps the generated light editor, which matches its
-- generated light terminals.
return {
  {
    "bjarneo/aether.nvim",
    branch = "v3",
    name = "aether",
    priority = 1000,
    opts = {
      colors = {
        bg = "#191c1a",
        dark_bg = "#141715",
        darker_bg = "#0f110f",
        lighter_bg = "#232824",

        fg = "#eee7d3",
        dark_fg = "#b9b29f",
        light_fg = "#d6cfbb",
        bright_fg = "#fff7e1",
        muted = "#8c9587",

        red = "#f17a74",
        yellow = "#e8c65e",
        orange = "#eb9a62",
        green = "#98c883",
        cyan = "#88c7c5",
        blue = "#98b5eb",
        magenta = "#c0a1db",
        brown = "#c9a27e",

        bright_red = "#ff9790",
        bright_yellow = "#ffe089",
        bright_green = "#b5db97",
        bright_cyan = "#a7e1da",
        bright_blue = "#b7ceff",
        bright_magenta = "#d8b9ed",

        accent = "#f17a74",
        cursor = "#fff7e1",
        foreground = "#eee7d3",
        background = "#191c1a",
        selection = "#43534b",
        selection_foreground = "#fff7e1",
        selection_background = "#43534b",
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "aether",
    },
  },
}
