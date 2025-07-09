-- Bootstrap lazy.nvim plugin manager (recommended)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
  -- BEGIN PLUGINS
  "tpope/vim-sensible",
  "tpope/vim-commentary",
  "tpope/vim-dispatch",
  "tpope/vim-surround",
  "tpope/vim-fugitive",
  "easymotion/vim-easymotion",
  "Raimondi/delimitMate",
  "rust-lang/rust.vim",
  "vim-airline/vim-airline",
  "vim-airline/vim-airline-themes",
  "rebelot/kanagawa.nvim",
  "editorconfig/editorconfig-vim",
  "w0rp/ale",
  "sheerun/vim-polyglot",
  "preservim/nerdtree",
  {
    "ibhagwan/fzf-lua",
    -- enable `sk` support instead of the default `fzf`
    opts = { 'skim' }
  },
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-vsnip",
  "hrsh7th/vim-vsnip",
  "hrsh7th/vim-vsnip-integ",
  "hrsh7th/cmp-nvim-lsp-signature-help",
  "yssl/QFEnter",
  "morhetz/gruvbox",
  "mason-org/mason.nvim",
  "mason-org/mason-lspconfig.nvim",
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  "seblyng/roslyn.nvim",
  ft = "cs",
  ---@module 'roslyn.config'
  ---@type RoslynNvimConfig
  opts = {
    -- your configuration comes here; leave empty for default settings
  },
  "b0o/schemastore.nvim",
  "nvim-lua/plenary.nvim",
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },
  "mrcjkb/rustaceanvim",
  -- END PLUGINS
})

-- Options
vim.opt.encoding = "utf-8"
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.cmdheight = 2
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "yes"
vim.opt.title = true
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 20
vim.opt.number = true
vim.opt.expandtab = false
vim.opt.hlsearch = true
vim.opt.linebreak = true
vim.opt.linespace = 2
vim.opt.modeline = true
vim.opt.completeopt = { "menu", "menuone", "noselect" }
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Filetype plugin and indent on
vim.cmd("filetype plugin indent on")
vim.cmd("syntax on")

-- Neovide GUI specific settings
if vim.g.neovide then
  vim.opt.guifont = "GitLab Mono Medium:h10"
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_trail_length = 0.0
  vim.g.neovide_refresh_rate = 100
end

-- Terminal true color support
if vim.fn.exists('+termguicolors') == 1 then
  vim.opt.termguicolors = true
end

-- Kanagawa colorscheme setup
require("kanagawa").setup({
  compile = false,
  undercurl = true,
  commentStyle = { italic = false },
  keywordStyle = { italic = false },
  statementStyle = { bold = true },
  transparent = false,
  dimInactive = false,
  terminalColors = true,
  colors = {
    palette = {},
    theme = {
      wave = {},
      lotus = {},
      dragon = {},
      all = { ui = { bg_gutter = "none" } },
    },
  },
  overrides = function(colors) return {} end,
  theme = "wave",
  background = { dark = "wave", light = "lotus" },
})
vim.cmd("colorscheme kanagawa")
vim.opt.background = "dark"

-- Highlights fixes
vim.cmd("hi ALEWarning cterm=undercurl ctermbg=none")
vim.cmd("hi Todo ctermfg=154 guifg=#afff00")

-- Airline settings
vim.g.airline_theme = "zenburn"
vim.g['airline.extensions.tabline.enabled'] = 1
vim.g.airline_section_a = ""
vim.g.airline_section_z = ""
vim.g.airline_section_error = ""
vim.g.airline_section_warning = ""
vim.g['airline.extensions.tabline.formatter'] = "unique_tail_improved"
vim.g['airline.extensions.fugitiveline.enabled'] = 1
vim.g['airline.extensions.nvimlsp.enabled'] = 1

-- EditorConfig plugin exclusion patterns
vim.g.EditorConfig_exclude_patterns = { "fugitive://.*", "scp://.*" }

-- ALE settings
vim.g.ale_disable_lsp = 1
vim.g.ale_linters_explicit = 1
vim.g.ale_lint_delay = 1000
vim.g.ale_fixers = {
  python = { "autopep8" },
  rust = { "rustfix" },
  javascript = { "eslint" },
  yaml = { "yamlfix" },
}
vim.g.ale_linters = {
  python = { "flake8" },
  rust = { "rls" },
  javascript = { "eslint" },
}

-- Filetype-specific autocmds
vim.api.nvim_create_autocmd("FileType", {
  pattern = "javascript",
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.textwidth = 79
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.fileformat = "unix"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "ruby",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.textwidth = 79
    vim.opt_local.autoindent = true
    vim.opt_local.fileformat = "unix"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "python",
  callback = function()
    vim.b.dispatch = "python -m unittest %"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    vim.opt_local.omnifunc = "javacomplete#Complete"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.opt_local.textwidth = 80
  end,
})

-- Terminal related mappings and autocmds
vim.keymap.set("n", "tt", ":vsplit term://bash<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-t>", ":split term://bash<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-T>", ":tabnew term://bash<CR>", { noremap = true, silent = true })

vim.api.nvim_create_augroup("neovim_terminal", { clear = true })
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.cmd("startinsert")
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  group = "neovim_terminal",
})

-- NERDTree mappings
vim.keymap.set("n", "<M-n>f", ":NERDTreeFind<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-n>o", ":NERDTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<M-n>n", ":NERDTreeFocus<CR>", { noremap = true, silent = true })

-- Window navigation keymaps
vim.keymap.set("n", "<C-j>", "<C-W><C-J>", { noremap = true })
vim.keymap.set("n", "<C-k>", "<C-W><C-K>", { noremap = true })
vim.keymap.set("n", "<C-l>", "<C-W><C-L>", { noremap = true })
vim.keymap.set("n", "<C-h>", "<C-W><C-H>", { noremap = true })

-- fzf Ripgrep command
vim.api.nvim_create_user_command("RG", function(opts)
  local query = table.concat(opts.fargs, " ")
  local command_fmt = "rg --column --line-number --no-heading --color=always --smart-case -- %s || true"
  local initial_command = string.format(command_fmt, vim.fn.shellescape(query))
  local reload_command = string.format(command_fmt, "{q}")
  local spec = {
    options = { "--phony", "--query", query, "--bind", "change:reload:" .. reload_command },
  }
  vim.fn["fzf#vim#grep"](initial_command, 1, vim.fn["fzf#vim#with_preview"](spec), opts.bang)
end, { nargs = "*", bang = true })

vim.g.fzf_preview_window = "right:70%"
vim.g.fzf_buffers_jump = 1

-- Map F10 to show highlight group under cursor
vim.keymap.set("n", "<F10>", function()
  local line = vim.fn.line(".")
  local col = vim.fn.col(".")
  local id1 = vim.fn.synID(line, col, 1)
  local id2 = vim.fn.synID(line, col, 0)
  local trans_id = vim.fn.synIDtrans(id1)
  print(string.format(
    "hi<%s> trans<%s> lo<%s>",
    vim.fn.synIDattr(id1, "name"),
    vim.fn.synIDattr(id2, "name"),
    vim.fn.synIDattr(trans_id, "name")
  ))
end, { noremap = true, silent = true })

-- Vsnip mappings for snippet expansion/jumping
vim.keymap.set({ "i", "s" }, "<C-j>", function()
  return vim.fn["vsnip#expandable"]() == 1 and "<Plug>(vsnip-expand)" or "<C-j>"
end, { expr = true, noremap = true })
vim.keymap.set({ "i", "s" }, "<C-l>", function()
  return vim.fn == 1 and "<Plug>(vsnip-expand-or-jump)" or "<C-l>"
end, { expr = true, noremap = true })
vim.keymap.set({ "i", "s" }, "<Tab>", function()
  return vim.fn == 1 and "<Plug>(vsnip-jump-next)" or "<Tab>"
end, { expr = true, noremap = true })
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
  return vim.fn["vsnip#jumpable"](-1) == 1 and "<Plug>(vsnip-jump-prev)" or "<S-Tab>"
end, { expr = true, noremap = true })
vim.keymap.set({ "n", "x" }, "s", "<Plug>(vsnip-select-text)", { noremap = false })
vim.keymap.set({ "n", "x" }, "S", "<Plug>(vsnip-cut-text)", { noremap = false })

-- Vsnip filetypes mappings
vim.g.vsnip_filetypes = {
  javascriptreact = { "javascript" },
  typescriptreact = { "typescript" },
}

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

if vim.fn.executable('rg') then
  vim.g['grepprg'] = 'rg'
end

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>gf', builtin.git_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>qf', builtin.quickfix, {})
vim.keymap.set('n', '<leader>l', builtin.loclist, {})
vim.keymap.set('n', '<leader>r', builtin.lsp_references, {})

require("mason").setup({
  registries = {
    "github:mason-org/mason-registry",
    -- for roslyn lsp
    "github:Crashdummyy/mason-registry",
  },
})

local mason_registry = require("mason-registry")

local cmp = require 'cmp'

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    -- ['<S-Tab>'] = cmp.mapping.scroll_docs(-4),
    -- ['<Tab>'] = cmp.mapping.scroll_docs(4),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"](1) == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),

    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' }, -- For vsnip users.
    { name = 'nvim_lsp_signature_help' }
  }
  -- {{ name = 'buffer' },}
  )
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
  --      {
  --    { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
  --  }
  sources = cmp.config.sources({
    { name = 'buffer' },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
vim.api.nvim_set_keymap('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

function _normalize_markdown(contents, opts)
  validate({
    contents = { contents, 't' },
    opts = { opts, 't', true },
  })
  opts = opts or {}

  -- 1. Carriage returns are removed
  contents = vim.split(table.concat(contents, '\n'):gsub('\r', ''), '\n', { trimempty = true })

  -- 2. Successive empty lines are collapsed into a single empty line
  contents = collapse_blank_lines(contents)

  -- 3. Thematic breaks are expanded to the given width
  local divider = string.rep('─', opts.width or 80)
  contents = replace_separators(contents, divider)

  return contents
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- using nvim-cmp instead
  -- Enable completion triggered by <c-x><c-o>
  -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<c-space>', 'v:lua.vim.lsp.omnifunc', opts)

  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  if vim.opt.filetype:get() == "rust" then
    vim.keymap.set(
      "n",
      "<leader>a",
      function()
        vim.cmd.RustLsp('codeAction') -- supports rust-analyzer's grouping
        -- or vim.lsp.buf.codeAction() if you don't want grouping.
      end,
      { silent = true, buffer = bufnr }
    )
    vim.keymap.set(
      "n",
      "K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
      function()
        vim.cmd.RustLsp({ 'hover', 'actions' })
      end,
      { silent = true, buffer = bufnr }
    )
  else
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  end
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-t>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>wl',
    '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>f', '<cmd>lua vim.lsp.buf.format({async==true})<CR>', opts)
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local lspconfig = require('lspconfig')

local servers = {
  "ts_ls",
  "solargraph",
  "terraformls",
  "taplo",
  "jsonls",
  "gradle_ls",
  "vue_ls",
  "cssls",
  "html",
  "tailwindcss",
}

for _, lsp in pairs(servers) do
  vim.lsp.config(lsp, {})
end

local root_files = {
  '.vim/', -- Gradle (multi-project)
}

local fallback_root_files = {
  'Gemfile', -- Gradle
  '.git/',   -- Gradle
}

local ruby_root_dir = function(fname)
  local primary = lspconfig.util.root_pattern(unpack(root_files))(fname)
  local fallback = lspconfig.util.root_pattern(unpack(fallback_root_files))(fname)
  return primary or fallback
end

vim.lsp.config("solargraph", {
  root_dir = ruby_root_dir,
  settings = {
    solargraph = {
      commandPath = "/home/mattc/.gem/ruby/3.1.6/bin/solargraph"
    }
  }
})

vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      telemetry = {
        enable = false
      },
      format = {
        enable = true
      }
    }
  }
})

local schemas = require('schemastore').yaml.schemas()

-- add extra filepaths here
for k, v in pairs(schemas) do
  if vim.tbl_contains(v, "azure-pipelines.yml") then
    vim.list_extend(schemas[k], { "*azure-pipelines.yml" })
  end

  if vim.tbl_contains(v, "docker-compose.yml") then
    vim.list_extend(schemas[k], { "*.docker-compose.yml" })
  end
end

function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

vim.lsp.config("yamlls", {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = "",
      },
      schemas = schemas,
      validate = { enabled = true }
    },
  }
})

vim.lsp.config("pyright", {
  root_dir = lspconfig.util.root_pattern('pyproject.toml', 'requirements.txt'),
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true
      }
    }
  }
})

vim.lsp.config("ansiblels", {
  settings = {
    ansible = {
      ansible = {
        path = "ansible"
      },
      executionEnvironment = {
        enabled = false
      },
      python = {
        interpreterPath = "python"
      },
      validation = {
        enabled = true,
        lint = {
          enabled = false,
          path = "ansible-lint"
        }
      }
    }
  }
})

vim.lsp.config("powershell_es", {
  settings = {
    shell = "pwsh"
  }
})

vim.lsp.config("jdtls", {
  init_options = {
    settings = {
      java = {
        implementationsCodeLens = { enabled = true },
        imports = { -- <- this
          gradle = {
            enabled = true,
            wrapper = {
              enabled = true,
              checksums = {
                {
                  sha256 = 'ea56e345f98b3bf206ab15b9210443a8bd9cf35ec7f375686a74e0c54475cecf',
                  allowed = true
                }
              },
            }
          }
        },
      },
    }
  }
})


vim.lsp.config("*", {
  on_attach = on_attach,
  capabilities = capabilities,
})

local servs = {}
vim.g.servs = servs
for k, _ in pairs(vim.lsp.config['_configs']) do
  if k ~= "*" and string.sub(k, 1, 1) ~= "_" then
    table.insert(servs, k)
  end
end

vim.lsp.config('rust-analyzer', {
  on_attach = on_attach,
  capabilities = capabilities
})

if not mason_registry.is_installed("roslyn") then
  vim.notify("roslyn not installed, installing now...", vim.log.levels.WARN)
  local pkg = mason_registry.get_package("roslyn")
  pkg:install()
  vim.notify("...roslyn installed.", vim.log.levels.WARN)
end

vim.lsp.config("roslyn", {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["csharp|inlay_hints"] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ["csharp|code_lens"] = {
      dotnet_enable_references_code_lens = true,
    },
    ["csharp|completion"] = {
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true
    },
    ["csharp|formatting"] = {
      dotnet_organize_imports_on_format = true
    }
  },
})

vim.lsp.enable('roslyn')

local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup {
  ensure_installed = servs
}
