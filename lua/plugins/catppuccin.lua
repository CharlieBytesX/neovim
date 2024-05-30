local originalColors = {

  rosewater = "#f5e0dc",
  flamingo = "#f2cdcd",
  pink = "#f5c2e7",
  mauve = "#cba6f7",
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = "#fab387",
  yellow = "#f9e2af",
  green = "#a6e3a1",
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = "#89b4fa",
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = "#1e1e2e",
  mantle = "#181825",
  crust = "#11111b",

}

local new_colors = {
  green = "#9CDF97",
  red = "#F1809E",
  bg = "#1C1C29",
  blue = "#7EABF9",
  yellow = "#F8DEA6",
  orange = "#F9AA7C"
}
local modifedColors = {

  rosewater = "#f5e0dc",
  flamingo = new_colors.green,
  pink = new_colors.green,
  mauve = new_colors.red,
  red = "#f38ba8",
  maroon = "#eba0ac",
  peach = new_colors.orange,
  yellow = new_colors.blue,
  green = new_colors.yellow,
  teal = "#94e2d5",
  sky = "#89dceb",
  sapphire = "#74c7ec",
  blue = new_colors.green,
  lavender = "#b4befe",
  text = "#cdd6f4",
  subtext1 = "#bac2de",
  subtext0 = "#a6adc8",
  overlay2 = "#9399b2",
  overlay1 = "#7f849c",
  overlay0 = "#6c7086",
  surface2 = "#585b70",
  surface1 = "#45475a",
  surface0 = "#313244",
  base = new_colors.bg,
  mantle = "#181825",
  crust = "#11111b",
}

require("catppuccin").setup(
  {
    color_overrides = {
      mocha = modifedColors
    }
  }
)
