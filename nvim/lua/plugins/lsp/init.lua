local M = {}
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

return {
    {
        "neovim/nvim-lspconfig",
        event = "BufReadPre",
        dependencies = {
			"hrsh7th/cmp-nvim-lsp",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function(_, _)
            local mason_lspconfig = require("mason-lspconfig")
			local lspconfig = require("lspconfig")

			mason_lspconfig.setup({
				ensure_installed = {
					"clangd",
					"tsserver",
					"pyright",
					"lua_ls",
					"eslint",
					"bashls",
					"yamlls",
					"jsonls",
					"cssls",
					"html",
				}
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					lspconfig[server_name].setup({

						on_attach = function (client, buffer)
							vim.api.nvim_create_autocmd("LspAttach", {
								callback = function(args)
									local buffer = args.buf
									local client = vim.lsp.get_client_by_id(args.data.client_id)
								end,
							})
						end,
						capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
					})
                end,
                ["pyright"] = function()
                    lspconfig.pyright.setup({
						on_attach = function(client, bufnr)
							-- Enable completion triggered by <c-x><c-o>
							vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
						end,
                        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
                        settings = {
                            python = {
                                analysis = {
                                    typeCheckingMode = "off",
                                },
                            },
                        },
                    })
				end,
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        opts = {
            pip = {
                upgrade_pip = true,
            },
            ui = {
                border = "rounded",
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local packages = {
				"bash-language-server",
				"black",
				"clang-format",
				"clangd",
				"codelldb",
				"cspell",
				"css-lsp",
				"eslint-lsp",
				"graphql-language-service-cli",
				"html-lsp",
				"json-lsp",
				"lua-language-server",
				"markdownlint",
				"prettier",
				"pyright",
				"shfmt",
				"tailwindcss-language-server",
				"taplo",
				"typescript-language-server",
				"yaml-language-server",
				"gopls",
				"editorconfig-checker"
			}
            local function ensure_installed()
                for _, package in ipairs(packages) do
                    local p = mr.get_package(package)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_installed)
            else
                ensure_installed()
            end
        end,
    },
}
