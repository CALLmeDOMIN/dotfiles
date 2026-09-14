return {
    { -- Highlight, edit, and navigate code
        "nvim-treesitter/nvim-treesitter",
        branch = "master",
        build = ":TSUpdate",
        opts = {
            -- Union of what the macOS and arch configs each installed, so
            -- neither machine loses parsers it was relying on.
            ensure_installed = {
                "bash", "c", "diff", "go", "html", "javascript", "jsdoc",
                "lua", "luadoc", "markdown", "markdown_inline", "query",
                "rust", "typescript", "vim", "vimdoc",
            },

            sync_install = false,
            auto_install = true,

            highlight = {
                enable = true,

                -- Bail out on very large files - treesitter highlighting is the
                -- main cost when opening generated/minified sources.
                disable = function(_, buf)
                    local max_filesize = 100 * 1024 -- 100 KB
                    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                    if ok and stats and stats.size > max_filesize then
                        vim.notify(
                            "File larger than 100KB, treesitter disabled for performance",
                            vim.log.levels.WARN,
                            { title = "Treesitter" }
                        )
                        return true
                    end
                end,

                -- Languages whose indent rules still need vim's regex engine.
                additional_vim_regex_highlighting = { "ruby", "markdown" },
            },

            indent = { enable = true, disable = { "ruby" } },
        },

        config = function(_, opts)
            require("nvim-treesitter.configs").setup(opts)

            -- templ (Go templating) has no parser upstream - register it by hand.
            local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
            parser_config.templ = {
                install_info = {
                    url = "https://github.com/vrischmann/tree-sitter-templ.git",
                    files = { "src/parser.c", "src/scanner.c" },
                    branch = "master",
                },
            }
            vim.treesitter.language.register("templ", "templ")
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        after = "nvim-treesitter",
        config = function()
            require("treesitter-context").setup({
                enable = true,
                multiwindow = false,
                max_lines = 0,
                min_window_height = 0,
                line_numbers = true,
                multiline_threshold = 20,
                trim_scope = "outer",
                mode = "cursor",
                separator = nil,
                zindex = 20,
                on_attach = nil,
            })
        end,
    },

    { "nvim-treesitter/playground" },
}
