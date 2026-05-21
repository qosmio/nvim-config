return {
	on_init = function(client, _)
		client.server_capabilities.inlayHintProvider = false -- Neovim 0.12.2 can render stale Python hint positions
	end,
	settings = {
		python = {
			pyrefly = {
				displayTypeErrors = "force-on",
			},
		},
	},
}
