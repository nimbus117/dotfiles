-- options {{{
local set = vim.opt

set.diffopt = set.diffopt + "vertical"
set.foldenable = false
set.laststatus = 2
set.linebreak = true
set.listchars = { space = "·", tab = "» ", eol = "¬", nbsp = "␣" }
set.mouse = ""
set.ruler = false
set.scrolloff = 2
set.shortmess = set.shortmess + "I"
set.showmode = false
set.spelllang = "en_gb"
set.splitbelow = true
set.splitright = true
set.startofline = true
set.synmaxcol = 500
set.undofile = true
set.wildignorecase = true
set.wrap = false

set.number = true
set.numberwidth = 4
set.relativenumber = true
set.signcolumn = "number"

set.expandtab = true
set.shiftwidth = 2
set.softtabstop = 2
set.tabstop = 2

vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_list_hide = ".swp$"

vim.o.pumheight = 10
vim.o.updatetime = 250

vim.diagnostic.config({ virtual_text = false })
-- }}}

-- key mappings {{{
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

local kmap = vim.keymap.set

local function defaultOpts(opts)
	local defaults = { noremap = true, silent = true }
	if opts == nil then
		opts = {}
	end
	for k, v in pairs(opts) do
		defaults[k] = v
	end
	return defaults
end

-- insert mode mappings
kmap("i", "jk", "<esc>")

-- command mode mappings
kmap("c", "<c-n>", "<down>")
kmap("c", "<c-p>", "<up>")

-- normal mode mappings
kmap(
	"n",
	"<leader>/",
	":setlocal hlsearch!<cr>:setlocal hlsearch?<cr>",
	defaultOpts({ desc = "Clear search highlights" })
)
kmap("n", "<leader><leader>", "<c-w>w", defaultOpts({ desc = "Go to next window" }))
kmap(
	"n",
	"<leader>e",
	"&ft == 'netrw' ? ':Rexplore<cr>' : ':Explore<cr>'",
	defaultOpts({ desc = "Toggle netrw", expr = true })
)
kmap("n", "<leader>i", ":setlocal list!<cr>:setlocal list?<cr>", defaultOpts({ desc = "Toggle invisibles" }))
kmap("n", "<leader>l", ":setlocal wrap!<cr>:setlocal wrap?<cr>", defaultOpts({ desc = "Toggle line wrapping" }))
kmap(
	"n",
	"<leader>ms",
	':mksession! .vimsess<cr>:echo "Session saved"<cr>',
	defaultOpts({ desc = "Save the current session as .vimsess" })
)
kmap(
	"n",
	"<leader>n",
	":setlocal relativenumber!<cr>:setlocal relativenumber?<cr>",
	defaultOpts({ desc = "Toggle relative line numbers" })
)
kmap(
	"n",
	"<leader>rw",
	":%s/\\<<c-r><c-w>\\>\\C//g<left><left>",
	defaultOpts({ desc = "Find and replace word under cursor", silent = false })
)
kmap("n", "<leader>sp", ":setlocal spell!<cr>:setlocal spell?<cr>", defaultOpts({ desc = "Toggle spell checking" }))
kmap("n", "<leader>ss", ":source .vimsess<cr>", defaultOpts({ desc = "Source the session saved in .vimsess" }))
kmap("n", "<leader>tc", ":tabclose<cr>", defaultOpts({ desc = "Close current tab" }))
kmap("n", "<leader>tn", ":tabnew<cr>", defaultOpts({ desc = "Open new tab" }))
kmap("n", "<leader>to", ":tabonly<cr>", defaultOpts({ desc = "Close all other tabs" }))
kmap("n", "<leader>w", "<c-w>", defaultOpts({ desc = "Same as CTRL-w" }))
kmap("n", "<leader>we", "<c-w>v<c-w>T", defaultOpts({ desc = "Clone the current window in a new tab" }))
kmap("n", "<leader>wt", "<c-w>T", defaultOpts({ desc = "Move the current window to a new tab page" }))
kmap("n", "<leader>x", ":MdCheckboxToggle<cr>", defaultOpts({ desc = "Toggle markdown checkbox" }))
-- }}}

-- packages {{{
-- bootstrap lazy.nvim {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)
-- }}}

require("lazy").setup({
	spec = {
		-- catppuccin {{{
		{
			"catppuccin/nvim",
			name = "catppuccin",
			lazy = false,
			priority = 1000,
			config = function()
				require("catppuccin").setup({
					custom_highlights = function(colors)
						return {
							Folded = { bg = colors.none },
						}
					end,
				})
				vim.o.background = "dark"
				vim.cmd.colorscheme("catppuccin")
			end,
		},
		-- }}}
		-- telescope {{{
		{
			"nvim-telescope/telescope.nvim",
			event = "VimEnter",
			branch = "0.1.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				{ "nvim-telescope/telescope-ui-select.nvim" },
				{ "nvim-tree/nvim-web-devicons" },
			},
			config = function()
				require("telescope").setup({
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown(),
						},
					},
					defaults = {
						sorting_strategy = "ascending",
						layout_strategy = "vertical",
						layout_config = {
							prompt_position = "top",
							vertical = {
								mirror = true,
							},
						},
					},
				})

				pcall(require("telescope").load_extension, "fzf")
				pcall(require("telescope").load_extension, "ui-select")

				local builtin = require("telescope.builtin")
				local oldFiles = function()
					builtin.oldfiles({ only_cwd = true })
				end

				vim.keymap.set("n", "<leader>sb", builtin.buffers, { desc = "Search [B]uffers" })
				vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
				vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
				vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
				vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
				vim.keymap.set("n", "<leader>so", oldFiles, { desc = "Search [O]ld Files" })
				vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
				vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			end,
		},
		-- }}}
		-- lsp {{{
		{
			"folke/lazydev.nvim",
			ft = "lua",
			opts = {
				library = {
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", lazy = true },
		{
			-- Main LSP Configuration
			"neovim/nvim-lspconfig",
			dependencies = {
				{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
				"williamboman/mason-lspconfig.nvim",
				"WhoIsSethDaniel/mason-tool-installer.nvim",
				{ "j-hui/fidget.nvim", opts = {} },
				"hrsh7th/cmp-nvim-lsp",
			},
			config = function()
				vim.api.nvim_create_autocmd("LspAttach", {
					group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
					callback = function(event)
						local map = function(keys, func, desc, mode)
							mode = mode or "n"
							vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
						end

						map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" })
						map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
						map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
						map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
						map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
						map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
						map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
						map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					end,
				})

				-- Change diagnostic symbols in the sign column (gutter)
				local signs = { Error = "", Warn = "", Hint = "", Info = "" }
				for type, icon in pairs(signs) do
					local hl = "DiagnosticSign" .. type
					vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
				end

				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities =
					vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

				local servers = {
					ts_ls = {
						settings = {
							format = { enable = false },
						},
					},

					lua_ls = {
						settings = {
							Lua = {
								completion = {
									callSnippet = "Replace",
								},
								diagnostics = { disable = { "missing-fields" } },
							},
						},
					},
				}

				require("mason").setup()

				local ensure_installed = vim.tbl_keys(servers or {})
				vim.list_extend(ensure_installed, {
					"stylua",
					"eslint_d",
					"prettierd",
				})
				require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

				require("mason-lspconfig").setup({
					ensure_installed = {},
					automatic_enable = true,
					handlers = {
						function(server_name)
							local server = servers[server_name] or {}
							server.capabilities =
								vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
							require("lspconfig")[server_name].setup(server)
						end,
					},
				})
			end,
		},
		-- }}}
		-- autoformat {{{
		{
			"stevearc/conform.nvim",
			event = { "BufWritePre" },
			cmd = { "ConformInfo" },
			keys = {
				{
					"<leader>f",
					function()
						require("conform").format({ async = true, lsp_format = "fallback" })
					end,
					mode = "",
					desc = "[F]ormat buffer",
				},
			},
			opts = {
				notify_on_error = false,
				format_on_save = function(bufnr)
					local disable_filetypes = { c = true, cpp = true }
					local lsp_format_opt
					if disable_filetypes[vim.bo[bufnr].filetype] then
						lsp_format_opt = "never"
					else
						lsp_format_opt = "fallback"
					end
					return {
						timeout_ms = 500,
						lsp_format = lsp_format_opt,
					}
				end,
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "eslint_d", "prettierd" },
					typescript = { "eslint_d", "prettierd" },
					javascriptreact = { "eslint_d", "prettierd" },
					typescriptreact = { "eslint_d", "prettierd" },
				},
			},
		},
		-- }}}
		-- autocompletion {{{
		{
			"hrsh7th/nvim-cmp",
			event = "InsertEnter",
			dependencies = {
				{
					"L3MON4D3/LuaSnip",
					build = (function()
						if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
							return
						end
						return "make install_jsregexp"
					end)(),
					dependencies = {
						{
							"rafamadriz/friendly-snippets",
							config = function()
								require("luasnip.loaders.from_vscode").lazy_load()
							end,
						},
					},
				},
				"saadparwaiz1/cmp_luasnip",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
			},
			config = function()
				-- See `:help cmp`
				local cmp = require("cmp")
				local luasnip = require("luasnip")
				luasnip.config.setup({})

				cmp.setup({
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					completion = { completeopt = "menu,menuone,noinsert,noselect" },
					mapping = cmp.mapping.preset.insert({
						["<C-n>"] = cmp.mapping.select_next_item(),
						["<C-p>"] = cmp.mapping.select_prev_item(),
						["<C-b>"] = cmp.mapping.scroll_docs(-4),
						["<C-f>"] = cmp.mapping.scroll_docs(4),
						["<CR>"] = cmp.mapping.confirm({ select = true }),
						["<C-l>"] = cmp.mapping(function()
							if luasnip.expand_or_locally_jumpable() then
								luasnip.expand_or_jump()
							end
						end, { "i", "s" }),
					}),
					sources = {
						{ name = "lazydev", group_index = 0 },
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
						{ name = "path" },
					},
				})
			end,
		},
		-- }}}
		-- linting {{{
		{
			"mfussenegger/nvim-lint",
			event = { "BufReadPre", "BufNewFile" },
			config = function()
				local lint = require("lint")
				lint.linters_by_ft = {
					typescript = { "eslint_d" },
					typescriptreact = { "eslint_d" },
					javascript = { "eslint_d" },
					javascriptreact = { "eslint_d" },
				}

				local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
				vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave", "TextChanged" }, {
					group = lint_augroup,
					callback = function()
						if vim.opt_local.modifiable:get() then
							lint.try_lint()
						end
					end,
				})
			end,
		},
		-- }}}
		-- treesitter {{{
		{
			"nvim-treesitter/nvim-treesitter",
			build = ":TSUpdate",
			main = "nvim-treesitter.configs",
			opts = {
				ensure_installed = {
					"css",
					"html",
					"javascript",
					"json",
					"lua",
					"luadoc",
					"markdown",
					"markdown_inline",
					"scss",
					"typescript",
				},
				-- auto_install = true,
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "ruby" },
				},
				indent = { enable = true, disable = { "ruby" } },
			},
			config = function()
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			end,
		},
		-- }}}
		-- vim-test {{{
		{
			"vim-test/vim-test",
			dependencies = { "preservim/vimux" },
			config = function()
				vim.cmd('let test#strategy="vimux"')
				vim.cmd('let g:VimuxOrientation = "h"')
				vim.cmd('let g:VimuxHeight = "50%"')
			end,
		},
		-- }}}
		-- tabby {{{
		{
			"nanozuki/tabby.nvim",
			config = function()
				local theme = {
					fill = "TabLineFill",
					line = "TabLine",
					current_tab = { fg = "#1e1e2e", bg = "#89b4fa", style = "bold" },
				}

				require("tabby.tabline").set(function(line)
					return {
						{
							{ "  ", hl = theme.line },
							line.sep(" ", theme.line, theme.fill),
						},
						line.tabs().foreach(function(tab)
							local hl = tab.is_current() and theme.current_tab or theme.line
							---@diagnostic disable-next-line: missing-return-value
							return {
								line.sep("", hl, theme.fill),
								tab.number(),
								tab.name(),
								line.sep(" ", hl, theme.fill),
								hl = hl,
								margin = " ",
							}
						end),
						line.spacer(),
						{
							line.sep(" ", theme.line, theme.fill),
							{ "  ", hl = theme.line },
						},
						hl = theme.fill,
					}
				end)
			end,
		},
		-- }}}
		-- misc {{{
		{
			"jiaoshijie/undotree",
			dependencies = "nvim-lua/plenary.nvim",
			config = true,
			keys = { { "<leader>ut", "<cmd>lua require('undotree').toggle()<cr>" } },
		},
		{ "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" }, config = {} },
		{
			"sindrets/diffview.nvim",
			config = function()
				kmap("n", "<leader>gd", ":DiffviewOpen<cr>", defaultOpts({ desc = "Open git diff in new tab" }))
			end,
		},
		{
			"tpope/vim-fugitive",
			config = function()
				kmap(
					"n",
					"<leader>gl",
					":tab Git log %<cr>",
					defaultOpts({ desc = "Open git log of current file in new tab" })
				)
				kmap("n", "<leader>gs", ":tab Git<cr>", defaultOpts({ desc = "Open git status in new tab" }))
			end,
		},
		{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
		"jremmen/vim-ripgrep",
		"nimbus117/markdown.vim",
		"nimbus117/prettier.vim",
		"tommcdo/vim-exchange",
		"tpope/vim-eunuch",
		"tpope/vim-repeat",
		"tpope/vim-surround",
		"tpope/vim-unimpaired",
		-- }}}
	},
})
-- }}}

-- autocmds {{{
local customGroup = vim.api.nvim_create_augroup("Custom", {
	clear = false,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
	desc = "Return the cursor to where it was the last time the file was closed",
	group = customGroup,
	pattern = "*",
	command = 'silent! normal! g`"zv',
})

vim.api.nvim_create_autocmd({ "BufReadPre", "FileReadPre" }, {
	desc = "Enbale folds using the marker method in certain files",
	group = customGroup,
	pattern = { "init.lua", "zshrc", "vimrc", "tmux.conf" },
	command = "setlocal foldmethod=marker",
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
	desc = "Show line diagnostics on cursor hold",
	group = customGroup,
	pattern = "*",
	callback = function()
		vim.diagnostic.open_float(nil, { focus = false })
	end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	desc = "Don't insert comment leader when pressing o or O in normal mode",
	group = customGroup,
	pattern = "*",
	command = "set formatoptions-=o",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	desc = "Enable spell checking on certain file types",
	group = customGroup,
	pattern = { "markdown", "gitcommit" },
	command = "setlocal spell",
})

vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertLeave", "VimEnter", "WinEnter" }, {
	desc = "Handle enabling cursorline",
	group = customGroup,
	pattern = "*",
	command = "setlocal cursorline",
})

vim.api.nvim_create_autocmd({ "InsertEnter", "WinLeave" }, {
	desc = "Handle disabling cursorline",
	group = customGroup,
	pattern = "*",
	command = "setlocal nocursorline",
})
-- }}}
