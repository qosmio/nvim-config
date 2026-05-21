return {
	autostart = true,
	on_init = function(client, _)
		client.server_capabilities.completionProvider = false -- use pyrefly for fast response
		client.server_capabilities.definitionProvider = true -- use pyrefly for fast response
		client.server_capabilities.documentHighlightProvider = false -- use pyrefly for fast response
		client.server_capabilities.inlayHintProvider = false -- Neovim 0.12.2 can render stale Python hint positions
		client.server_capabilities.renameProvider = false -- use pyrefly as I think it is stable
		client.server_capabilities.semanticTokensProvider = false -- use pyrefly it is more rich
	end,
	settings = {
		basedpyright = {
			disableOrganizeImports = true, -- use ruff instead of it
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				-- diagnosticMode = "openFilesOnly",
				-- typeCheckingMode = "standard",
				diagnosticSeverityOverrides = {
					reportMissingTypeStubs = false,
					reportPrivateImportUsage = false,
				},
			},
		},
	},
}
