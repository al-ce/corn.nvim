local M = {
  config_errors = {}
}

local function valid_config_keys(opts)
  for k, _ in pairs(opts) do
    if opts[k] == nil then
      table.insert(M.config_errors, "invalid option key '" .. k .. "'")
    end
  end
end

local function valid_opt_val(opt, valid_vals, parent_tbl)
  local v = parent_tbl[opt]
  if v and vim.tbl_contains(valid_vals, v) == false then
    table.insert(
      M.config_errors,
      "`" .. opt .. "` must be one of: " .. table.concat(valid_vals, ", ")
    )
  end
end

local function valid_offsets(opts)
  vim.tbl_map(function(k)
    local v = opts.position[k]
    if v and type(v) ~= 'number' then
      table.insert(M.config_errors, "`position." .. k .. "` must be a number")
    end
  end, { 'col_offset', 'row_offset' })
end

---@return table
M.get_config_errs = function(opts)
  if opts == nil then
    return M.config_errors
  end

  valid_config_keys(opts)

  local sort_methods = { 'severity', 'column', 'line_number', 'severity_reverse', 'column_reverse', 'line_number_reverse' }
  valid_opt_val('sort_method', sort_methods, opts)

  valid_opt_val('scope', {'line', 'file'}, opts)

  if opts.position then
    valid_opt_val('anchor', { 'NE', 'NW', 'SE', 'SW' }, opts.position)
    valid_offsets(opts)
  end

  return M.config_errors
end

return M
