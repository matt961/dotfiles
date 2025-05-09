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

require("mason").setup()

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
  vim.api.nvim_buf_set_keymap(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
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
local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
  automatic_installation = true
})

local servers = {
  "tsserver",
  "solargraph",
  "terraformls",
  "taplo",
  "jsonls",
  "gradle_ls",
  "volar",
  "cssls",
  "html",
  "tailwindcss",
  "csharp_ls"
}
for _, lsp in pairs(servers) do
  lspconfig[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      -- This will be the default in neovim 0.7+
      debounce_text_changes = 150,
    }
  }
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

lspconfig.solargraph.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  root_dir = ruby_root_dir,
  settings = {
    solargraph = {
      commandPath = "/home/mattc/.gem/ruby/3.1.6/bin/solargraph"
    }
  }
}

lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

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
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

lspconfig.yamlls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

lspconfig.ansiblels.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

lspconfig.powershell_es.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    shell = "pwsh"
  }
}

lspconfig.jdtls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
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
}

vim.g.rustaceanvim = {
  server = {
    on_attach = on_attach
  }
}
