local M = {}

-- NOTE: [source](https://templ.guide/commands-and-tools/ide-support#formatting)
M.format = function()
  local bufnr = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(bufnr)
  local cmd = 'templ fmt ' .. vim.fn.shellescape(filename)

  vim.fn.jobstart(cmd, {
    on_exit = function()
      -- Reload the buffer only if it's still the current buffer
      if vim.api.nvim_get_current_buf() == bufnr then
        vim.cmd 'e!'
      end
    end,
  })
end

return M
