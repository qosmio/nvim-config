local M = {}

local servers = {
	"bashls",
	"basedpyright",
	"pyrefly",
	"biome",
	"clangd",
	"lua_ls",
	"ts_ls",
}

function M.setup()
	for _, server in ipairs(servers) do
		local ok, config = pcall(require, "plugins.lsp.servers." .. server)
		if ok then
			if type(config) ~= "table" then
				config = {}
			end

			local executable = config.cmd and config.cmd[1]
			if not executable or vim.fn.executable(executable) == 1 then
				vim.lsp.config(server, config)
				vim.lsp.enable(server)
			end
    else
      vim.notify("Failed to load LSP config for " .. server .. ": " .. config, vim.log.levels.ERROR)
		end
	end
end

return M
