vim.filetype.add {
  pattern = {
    [".*/requirements%.yml"] = "yaml.ansible",
    [".*/requirements/.*%.yml"] = "yaml.ansible",
    [".*/meta/main%.ya?ml"] = "yaml.ansible",
    [".*/vars/.*%.ya?ml"] = "yaml.ansible",
  },
}

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.yml", "*.yaml" },
  callback = function()
    if vim.bo.filetype == "yaml.ansible" then
      return
    end

    if vim.bo.filetype ~= "yaml" then
      return
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false)
    for _, line in ipairs(lines) do
      if line:match "^%s*hosts:" or line:match "^%s*-%s*hosts:" then
        vim.bo.filetype = "yaml.ansible"
        return
      end

      if line:match "ansible%.builtin%." or line:match "ansible%.posix%." then
        vim.bo.filetype = "yaml.ansible"
        return
      end

      if
        line:match "^%s+become:"
        or line:match "^%s+notify:"
        or line:match "^%s+register:"
        or line:match "^%s+loop_control:"
        or line:match "^%s+failed_when:"
        or line:match "^%s+changed_when:"
      then
        vim.bo.filetype = "yaml.ansible"
        return
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "yaml.ansible",
  callback = function()
    vim.keymap.set("n", "<leader>ta", function()
      require("ansible").run()
    end, { buffer = true, desc = "Run Ansible playbook/role" })
  end,
})
