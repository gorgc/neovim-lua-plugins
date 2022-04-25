local M = {}

-- functions we need:
-- - vim.keymap.set(...) -> create new keymaps
-- - nvim_get_keymap(...) -> get keymaps

-- vim.api.nvim_get_keymap(...)

local find_mapping = function(maps, lhs)
  -- pairs
  --   iterates over EVERY key in a table
  --   order not guaranteed
  -- ipairs
  --   iterates over ONLY numeric keys in a table
  --   order IS guaranteed
  for _, value in ipairs(maps) do
    if value.lhs == lhs then
      return value
    end
  end
end

M._stack = {}

M.push = function(name, mode, mappings)
  local maps = vim.api.nvim_get_keymap(mode)

  local existing_maps = {}
  for lhs, rhs in pairs(mappings) do
    local existing = find_mapping(maps, lhs)
    if existing then
      existing_maps[lhs] = existing
    end
  end

  for lhs, rhs in pairs(mappings) do
    --TODO: need some way to pass options in here
    vim.keymap.set(mode, lhs, rhs)
  end

  -- TODO: Might wanna use metatables POGCHAMP
  M._stack[name] = M._stack[name] or {}

  M._stack[name][mode] = { 
    existing = existing_maps,
    mappings = mappings,
  }
end

M.pop = function(name, mode)
  local state = M._stack[name][mode]
  M._stack[name][mode] = nil

  for lhs in pairs(state.mappings) do
    if state.existing[lhs] then
      -- Handle mappings that existed
      local og_mapping = state.existing[lhs]

      -- TODO: Handle the options from the table
      vim.keymap.set(mode, lhs, og_mapping.rhs)
    else
      -- Handle mappings that didn't exist
      vim.keymap.del(mode, lhs)
    end
  end
end

M.push("debug_mode", "n", {
  [",st"] = "echo 'Hello'",
  [",sz"] = "echo 'Goodbye'",
})

--[[
-- lua require("stackmap").push("debug_mode", "n", {
--   ["<leader>st"] = "echo 'Hello'",
--   ["<leader>sz"] = "echo 'Goodbye'"
-- })
-- 
-- lua require("stackmap").pop("debug_mode")
--]]

M._clear = function() 
  M._stack = {}
end

return M
