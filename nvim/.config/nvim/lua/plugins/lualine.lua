-- local tip_file_path = os.getenv("HOME") .. "/dotfiles/nvim/.config/nvim/data/tips.txt"
--
-- local count_lines = function(filename)
--   local count = 0
--   for _ in io.lines(filename) do
--     count = count + 1
--   end
--   return count
-- end
--
-- local tip = function()
--   local tip_file = io.open(tip_file_path, "r")
--
--   if not tip_file then
--     print("Error opening tip file " .. tip_file_path)
--     return nil
--   end
--
--   if count_lines == 0 then
--     print("Tip file is empty")
--     tip_file:close()
--     return nil
--   end
--
--   local random_line_number = math.random(1, count_lines(tip_file_path))
--   local current_line = 0
--
--   for line in tip_file:lines() do
--     current_line = current_line + 1
--     if current_line == random_line_number then
--       tip_file:close()
--       return " Today's focus:  " .. line
--     end
--   end
-- end

local config = function()
  require("lualine").setup({
    options = {
      theme = "catppuccin",
      globalstatus = true,
      section_separators = { left = "", right = "" },
      component_separators = { left = "", right = "" },
    },
    sections = {
      lualine_a = { "buffers" },
      -- lualine_c = { tip },
    },
  })
end

return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  config = config,
}
