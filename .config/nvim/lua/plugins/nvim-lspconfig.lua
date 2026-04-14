-- Brief aside: **What is LSP?**
--
-- LSP is an initialism you've probably heard, but might not understand what it is.
--
-- LSP stands for Language Server Protocol. It's a protocol that helps editors
-- and language tooling communicate in a standardized fashion.
--
-- In general, you have a "server" which is some tool built to understand a particular
-- language (such as `gopls`, `lua_ls`, `rust_analyzer`, etc.). These Language Servers
-- (sometimes called LSP servers, but that's kind of like ATM Machine) are standalone
-- processes that communicate with some "client" - in this case, Neovim!
--
-- LSP provides Neovim with features like:
--  - Go to definition
--  - Find references
--  - Autocompletion
--  - Symbol Search
--  - and more!
--
-- Thus, Language Servers are external tools that must be installed separately from
-- Neovim. This is where `mason` and related plugins come into play.
--
-- If you're wondering about lsp vs treesitter, you can check out the wonderfully
-- and elegantly composed help section, `:help lsp-vs-treesitter`
return {
    "neovim/nvim-lspconfig",

    dependencies = {
        -- Mason must be loaded before its dependents so we need to set it up here.
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "saghen/blink.cmp",
        {
            "williamboman/mason.nvim",
            opts = {},
        },
        {
            "Bilal2453/luvit-meta",
            lazy = true,
        },
        {
            "j-hui/fidget.nvim",
            opts = {},
        },
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    {
                        path = "luvit-meta/library",
                        words = { "vim%.uv" },
                    },
                },
            },
        },
    },

    config = function()
        --  This function gets run when an LSP attaches to a particular buffer.
        --    That is to say, every time a new file is opened that is associated with
        --    an lsp (for example, opening `main.rs` is associated with `rust_analyzer`) this
        --    function will be executed to configure the current buffer
        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup(
                "kickstart-lsp-attach",
                { clear = true }
            ),
            callback = function(event)
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(
                        mode,
                        keys,
                        func,
                        { buffer = event.buf, desc = "LSP: " .. desc }
                    )
                end

                -- Rename the variable under your cursor.
                --  Most Language Servers support renaming across files, etc.
                map("<leader>crn", vim.lsp.buf.rename, "[R]e[n]ame")

                -- Execute a code action, usually your cursor needs to be on top of an error
                -- or a suggestion from your LSP for this to activate.
                map(
                    "<leader>cca",
                    vim.lsp.buf.code_action,
                    "[C]ode [A]ction",
                    { "n", "x" }
                )

                -- Find references for the word under your cursor.
                map(
                    "<leader>cr",
                    require("fzf-lua").lsp_references,
                    "[C]ode [R]eferences"
                )

                -- Jump to the implementation of the word under your cursor.
                --  Useful when your language has ways of declaring types without an actual implementation.
                map(
                    "<leader>ci",
                    require("fzf-lua").lsp_implementations,
                    "[C]ode [I]mplementation"
                )

                -- Jump to the definition of the word under your cursor.
                --  This is where a variable was first declared, or where a function is defined, etc.
                --  To jump back, press <C-t>.
                map(
                    "<leader>cd",
                    require("fzf-lua").lsp_definitions,
                    "[C]ode [D]efinition"
                )

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map(
                    "<leader>cD",
                    vim.lsp.buf.declaration,
                    "[C]ode [D]eclaration"
                )

                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map(
                    "<leader>cds",
                    require("fzf-lua").lsp_document_symbols,
                    "[C]ode [D]ocument [S]ymbols"
                )

                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map(
                    "<leader>cws",
                    require("fzf-lua").lsp_live_workspace_symbols,
                    "[C]ode [W]orkspace [S]ymbols"
                )

                -- Jump to the type of the word under your cursor.
                --  Useful when you're not sure what type a variable is and you want to see
                --  the definition of its *type*, not where it was *defined*.
                map(
                    "<leader>ctd",
                    require("fzf-lua").lsp_typedefs,
                    "[C]ode [T]ype [D]efinition"
                )

                -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
                ---@param client vim.lsp.Client
                ---@param method vim.lsp.protocol.Method
                ---@param bufnr? integer some lsp support methods only in specific files
                ---@return boolean
                local function client_supports_method(client, method, bufnr)
                    if vim.fn.has("nvim-0.11") == 1 then
                        return client:supports_method(method, bufnr)
                    else
                        return client.supports_method(method, { bufnr = bufnr })
                    end
                end

                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if
                    client
                    and client_supports_method(
                        client,
                        vim.lsp.protocol.Methods.textDocument_documentHighlight,
                        event.buf
                    )
                then
                    local highlight_augroup = vim.api.nvim_create_augroup(
                        "kickstart-lsp-highlight",
                        { clear = false }
                    )
                    vim.api.nvim_create_autocmd(
                        { "CursorHold", "CursorHoldI" },
                        {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        }
                    )

                    vim.api.nvim_create_autocmd(
                        { "CursorMoved", "CursorMovedI" },
                        {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        }
                    )

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup(
                            "kickstart-lsp-detach",
                            { clear = true }
                        ),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({
                                group = "kickstart-lsp-highlight",
                                buffer = event2.buf,
                            })
                        end,
                    })
                end

                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if
                    client
                    and client_supports_method(
                        client,
                        vim.lsp.protocol.Methods.textDocument_inlayHint,
                        event.buf
                    )
                then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(
                            not vim.lsp.inlay_hint.is_enabled({
                                bufnr = event.buf,
                            })
                        )
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        -- Diagnostic Config
        -- See :help vim.diagnostic.Opts
        vim.diagnostic.config({
            severity_sort = true,
            float = { border = "rounded", source = "if_many" },
            underline = { severity = vim.diagnostic.severity.ERROR },
            signs = vim.g.have_nerd_font
                    and {
                        text = {
                            [vim.diagnostic.severity.ERROR] = "󰅚 ",
                            [vim.diagnostic.severity.WARN] = "󰀪 ",
                            [vim.diagnostic.severity.INFO] = "󰋽 ",
                            [vim.diagnostic.severity.HINT] = "󰌶 ",
                        },
                    }
                or {},
            virtual_text = {
                source = "if_many",
                spacing = 2,
                format = function(diagnostic)
                    local diagnostic_message = {
                        [vim.diagnostic.severity.ERROR] = diagnostic.message,
                        [vim.diagnostic.severity.WARN] = diagnostic.message,
                        [vim.diagnostic.severity.INFO] = diagnostic.message,
                        [vim.diagnostic.severity.HINT] = diagnostic.message,
                    }
                    return diagnostic_message[diagnostic.severity]
                end,
            },
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
        local capabilities_default = vim.lsp.protocol.make_client_capabilities()
        local capabilities =
            require("blink.cmp").get_lsp_capabilities(capabilities_default)

        -- Broadcast enhanced capabilities to all LSP servers globally.
        vim.lsp.config("*", { capabilities = capabilities })

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
            bashls = {},
            cmake = {},
            markdown_oxide = {},
            nil_ls = {},
            pylsp = {},
            sqlls = {},
            gopls = {},

            docker_language_server = {},
            terraformls = {},
            nginx_language_server = {},

            asm_lsp = {},

            clangd = {
                keys = {
                    {
                        "<leader>ch",
                        "<cmd>ClangdSwitchSourceHeader<cr>",
                        desc = "Switch Source/Header (C/C++)",
                    },
                },
                root_markers = {
                    "Makefile",
                    "configure.ac",
                    "configure.in",
                    "config.h.in",
                    "meson.build",
                    "meson_options.txt",
                    "build.ninja",
                    "compile_commands.json",
                    "compile_flags.txt",
                    ".git",
                },
                cmd = {
                    "clangd",
                    "--background-index",
                    "--clang-tidy",
                    "--header-insertion=iwyu",
                    "--completion-style=detailed",
                    "--fallback-style=llvm",
                    "--query-driver="
                        .. "/nix/store/*/bin/gcc*,"            -- NixOS Nix store gcc (fallback driver path)
                        .. "/nix/store/*/bin/clang*,"          -- NixOS Nix store clang (fallback driver path)
                        .. "/run/current-system/sw/bin/gcc*,"  -- NixOS sw gcc
                        .. "/run/current-system/sw/bin/g++*,"  -- NixOS sw g++
                        .. "/run/current-system/sw/bin/clang*," -- NixOS sw clang
                        .. "/usr/bin/gcc*,"                     -- Linux FHS gcc
                        .. "/usr/bin/g++*,"                     -- Linux FHS g++
                        .. "/usr/bin/clang*,"                   -- Linux FHS clang
                        .. "/usr/local/bin/gcc*,"               -- macOS Homebrew gcc
                        .. "/usr/local/bin/clang*,"             -- macOS Homebrew clang
                        .. "/opt/homebrew/bin/gcc*,"            -- macOS Apple Silicon Homebrew
                        .. "/opt/homebrew/bin/clang*",          -- macOS Apple Silicon Homebrew
                },
                init_options = {
                    usePlaceholders = true,
                    completeUnimported = true,
                    clangdFileStatus = true,
                },
            },

            lua_ls = {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim", "startpath" },
                        },
                    },
                },
            },
        }

        -- Apply per-server config overrides using the nvim 0.11+ API.
        -- vim.lsp.config(name, ...) merges with the server's built-in defaults
        -- so only fields you explicitly set are overridden.
        for server_name, server_config in pairs(servers) do
            if next(server_config) ~= nil then
                vim.lsp.config(server_name, server_config)
            end
        end

        -- Returns true if the LSP server binary is already available system-wide.
        -- Uses lspconfig's bundled server definitions as the source of truth for
        -- the binary name, falling back to replacing underscores with dashes.
        local function is_system_installed(server_name)
            local ok, server_def =
                pcall(require, "lspconfig.configs." .. server_name)
            if
                ok
                and server_def.default_config
                and server_def.default_config.cmd
            then
                return vim.fn.executable(server_def.default_config.cmd[1]) == 1
            end
            return vim.fn.executable((server_name:gsub("_", "-"))) == 1
        end

        -- Enable system-wide servers immediately; collect the rest for Mason.
        -- This supports NixOS (and other distros) where LSPs are system packages.
        local mason_server_names = {}
        for server_name in pairs(servers) do
            if is_system_installed(server_name) then
                vim.lsp.enable(server_name)
            else
                table.insert(mason_server_names, server_name)
            end
        end

        -- Ensure the servers and tools above are installed
        --
        -- To check the current status of installed tools and/or manually install
        -- other tools, you can run
        --    :Mason
        --
        -- You can press `g?` for help in this menu.
        --
        -- `mason` had to be setup earlier: to configure its options see the
        -- `dependencies` table for `nvim-lspconfig` above.
        --
        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = mason_server_names
        local formatters = {
            -- Formatters
            "bibtex-tidy",
            "black",
            "clang-format",
            "cmakelang",
            "csharpier",
            "isort",
            "nginx-config-formatter",
            "prettier",
            "shellharden",
            "sqlfmt",
            "stylua",
            "tex-fmt",
        }

        table.insert(formatters, "nixfmt")

        -- Only pass formatters to Mason if they aren't already available system-wide.
        -- Mason tool names use dashes; try that and the name as-is.
        for _, fmt in ipairs(formatters) do
            if vim.fn.executable(fmt) == 0 and vim.fn.executable((fmt:gsub("-", "_"))) == 0 then
                table.insert(ensure_installed, fmt)
            end
        end
        require("mason-tool-installer").setup({
            ensure_installed = ensure_installed,
            auto_update = true,
        })

        require("mason-lspconfig").setup({
            ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
            automatic_installation = true,
            handlers = {
                -- Called by mason-lspconfig once a server is installed.
                -- Config overrides were already applied above via vim.lsp.config,
                -- so we only need to enable the server here.
                function(server_name)
                    vim.lsp.enable(server_name)
                end,
            },
        })
    end,
}
