local perf = require("plugins.config.perf")

local config_root = vim.fn.stdpath("config")
local slow_host = perf.is_slow_host()

local function is_in_config(path)
	return path and (path .. "/"):sub(1, #config_root + 1) == config_root .. "/"
end

local function lua_root(bufnr, on_dir)
	local name = vim.api.nvim_buf_get_name(bufnr)
	if name == "" then
		return
	end

	local root = vim.fs.root(name, {
		".luarc.json",
		".luarc.jsonc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		".git",
	})

	if is_in_config(name) then
		on_dir(config_root)
		return
	end

	if slow_host then
		local explicit_root = vim.fs.root(name, { ".luarc.json", ".luarc.jsonc" })
		if explicit_root then
			on_dir(explicit_root)
		end
		return
	end

	on_dir(root or vim.fs.dirname(name))
end

local function workspace_library()
	local library = {
		vim.fs.joinpath(vim.fn.expand("$VIMRUNTIME"), "lua"),
		vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "ui", "nvchad_types"),
		"${3rd}/luv/library",
	}

	if not slow_host then
		table.insert(library, vim.fs.joinpath(vim.fn.stdpath("data"), "lazy", "lazy.nvim", "lua", "lazy"))
	end

	return library
end

return {
	root_dir = lua_root,
	single_file_support = not slow_host,
	settings = {
		Lua = {
			completion = {
				callSnippet = "Replace",
				workspaceWord = not slow_host,
			},
			diagnostics = {
				globals = { "vim" },
			},
			hint = {
				enable = false,
			},
			runtime = {
				version = "LuaJIT",
			},
			semantic = {
				enable = false,
			},
			telemetry = {
				enable = false,
			},
			workspace = {
				checkThirdParty = false,
				ignoreDir = {
					".git",
					".github",
					".lazy",
					".luarocks",
					"build",
					"dist",
					"node_modules",
					"target",
					"tmp",
				},
				library = workspace_library(),
				maxPreload = slow_host and 100 or 1000,
				preloadFileSize = slow_host and 200 or 500,
				userThirdParty = {},
			},
		},
	},
}
