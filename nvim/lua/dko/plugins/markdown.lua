return {
  {
    "tadmccorkle/markdown.nvim",
    ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
      mappings = {
        inline_surround_toggle = false,
        inline_surround_toggle_line = false,
        inline_surround_delete = false,
        inline_surround_change = false,
        link_add = "gl", -- (string|boolean) add link
        link_follow = false, -- (string|boolean) follow link
        go_curr_heading = false,
        go_parent_heading = false,
        go_next_heading = "]]", -- (string|boolean) set cursor to next section heading
        go_prev_heading = "[[", -- (string|boolean) set cursor to previous section heading
      },
    },
  },
}
