-- YAML
return {
  settings = {
    yaml = {
      customTags = {
        -- Home Assistant
        "!secret",
        "!include_dir_named",
        "!include_dir_list",
        "!include_dir_merge_named",
        "!include_dir_merge_list",
        "!lambda",
        "!input",
      },
    },
  },
}
