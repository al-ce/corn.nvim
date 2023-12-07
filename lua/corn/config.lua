require 'corn.types'

local validate_opts = require 'corn.validate_opts'

local M = {}

-- default config
M.default_opts = {
  ---@type boolean
  auto_cmds = true,

  sort_method = 'severity',

  scope = 'line',

  ---@type { error: string, warn: string, hint: string, info: string, trunc: string }
  highlights = {
    error = "DiagnosticFloatingError",
    warn = "DiagnosticFloatingWarn",
    info = "DiagnosticFloatingInfo",
    hint = "DiagnosticFloatingHint",
  },

  ---@type { error: string, warn: string, hint: string, info: string, trunc: string }
  icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
    -- trunc = "...",
  },

  position = {
    anchor = 'NE', ---@type 'NE' | 'NW' | 'SE' | 'SW
    col_offset = -1,
    row_offset = 0,
  },

  ---@param item Corn.Item
  ---@return Corn.Item
  item_preprocess_func = function(item)
    local trunc_tail = "..."
    local max_width = vim.api.nvim_win_get_width(0) / 4

    if #item.message > max_width then
      item.message = string.sub(item.message, 1, max_width - #trunc_tail) .. trunc_tail
      item.source = trunc_tail
    end

    return item
  end,

  ---@type function(boolean) nil
  on_toggle = function(is_hidden)
  end,
}

M.opts = {}


M.apply = function(opts)
  local config_errors = validate_opts.get_config_errs(opts)
  if #config_errors > 0 then
    table.insert(config_errors, 1, "Config errors:\n")
    vim.notify(table.concat(config_errors, "\n- "), vim.log.levels.ERROR, { title = "corn.nvim" })
    return false
  else
    M.opts = vim.tbl_deep_extend("force", M.default_opts, opts or {})
    return true
  end
end

return M
