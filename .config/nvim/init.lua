-- https://github.com/junegunn/vim-plug?tab=readme-ov-file#lua-example-for-neovim
local vim = vim
local Plug = vim.fn['plug#']

-- Plugins
vim.call('plug#begin')

-- https://github.com/nvim-lua/plenary.nvim?tab=readme-ov-file#installation
Plug('nvim-lua/plenary.nvim')

-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#installation
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })

-- https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#vim-plug
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

-- https://github.com/LukasPietzschmann/telescope-tabs?tab=readme-ov-file#installation
Plug('LukasPietzschmann/telescope-tabs')

-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#installation
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = function()
  vim.cmd('TSUpdate')
end })

Plug('EdenEast/nightfox.nvim')

-- https://github.com/mfussenegger/nvim-dap?tab=readme-ov-file#installation
Plug('mfussenegger/nvim-dap')

-- https://github.com/neovim/nvim-lspconfig?tab=readme-ov-file#install
Plug('neovim/nvim-lspconfig')

-- https://github.com/nvimtools/none-ls.nvim?tab=readme-ov-file#setup
Plug('nvimtools/none-ls.nvim')

Plug('tpope/vim-fugitive')

Plug('theHamsta/nvim-treesitter-pairs')

Plug('t-troebst/perfanno.nvim')


vim.call('plug#end')

-- Defaults
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = ''
vim.opt.hlsearch = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.tabpagemax = 1024

vim.cmd.colorscheme('nightfox')

-- https://github.com/nvim-treesitter/nvim-treesitter?tab=readme-ov-file#modules
treesitter_configs = require('nvim-treesitter.configs')
treesitter_configs.setup {
  -- A list of parser names, or "all" (the listed parsers MUST always be installed)
  ensure_installed = { 'c', 'cpp' },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
  auto_install = true,

  highlight = {
    enable = true,
  },

  pairs = {
    enable = true,
    keymaps = {
      goto_partner = '%',
    },
  },
}


vim.lsp.enable({
  "clangd",
})



-- https://neovim.io/doc/user/lsp.html#lsp-config
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = args.buf })
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.code_action({ apply = true })
    end, { buffer = args.buf })
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { buffer = args.buf })

    -- Prevent the column from appearing and disappearing
    for _, window_id in ipairs(vim.fn.win_findbuf(args.buf)) do
      vim.api.nvim_set_option_value('signcolumn', 'yes', {
        scope = 'local',
        win = window_id
      })
    end

    -- https://neovim.io/doc/user/diagnostic.html#vim.diagnostic.config()
    vim.diagnostic.config({
      severity_sort = true,
      virtual_lines = true,
    })
  end
})

-- https://github.com/nvim-telescope/telescope-fzf-native.nvim?tab=readme-ov-file#telescope-setup-and-configuration
local telescope = require('telescope')
telescope.load_extension('fzf')
telescope.load_extension('telescope-tabs')

-- https://github.com/LukasPietzschmann/telescope-tabs/wiki/Configs#configs
local telescope_tabs = require('telescope-tabs')
telescope_tabs.setup {
	entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
		local entry_string = table.concat(vim.tbl_map(function(v)
			return vim.fn.fnamemodify(v, ":.")
		end, file_paths), ', ')
		return string.format('%d: %s%s', tab_id, entry_string, is_current and ' <' or '')
	end,
	entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths, is_current)
		return table.concat(vim.tbl_map(function(v)
			return vim.fn.fnamemodify(v, ":.")
		end, file_paths), ' ')
	end,
}

-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file#usage
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>tf', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>tm', function() telescope.extensions.myles.myles({}) end, { desc = 'Telescope myles' })
vim.keymap.set('n', '<leader>ts', builtin.lsp_dynamic_workspace_symbols, { desc = 'Telescope workspace symbols' })
vim.keymap.set('n', '<leader>tt', telescope_tabs.list_tabs, { desc = 'Telescope list tabs' })

-- https://github.com/t-troebst/perfanno.nvim?tab=readme-ov-file#installation
require("perfanno").setup()


-- ClangIR
function open_corresponding_codegen_path()
  local current_tail = vim.fn.expand('%:t')
  local dirs = {
    vim.fs.normalize(vim.fn.expand('%:h') .. '/../../CodeGen'),
    vim.fs.normalize(vim.fn.expand('%:h') .. '/../../../include/clang/CodeGen'),
  }
  local options = {
    -- https://www.lua.org/pil/5.1.html, suppressing multiple return values
    (current_tail:gsub("CIRGen", "CG")),
    (current_tail:gsub("CIRGen", "CodeGen")),
    (current_tail:gsub("CIRGen", "")),
    (current_tail:gsub("CIR", "CG")),
  }
  for _, option in ipairs(options) do
    for _, dir in ipairs(dirs) do
      path = vim.fs.joinpath(dir, option)
      if vim.fn.filereadable(path) ~= 0 then
        vim.cmd('vsp ' .. path)
        return
      end
    end
  end
end

vim.keymap.set('n', '<leader>cg', open_corresponding_codegen_path)
