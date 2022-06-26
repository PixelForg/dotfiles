-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float, opts)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
   client.resolved_capabilities.document_formatting = false
   client.resolved_capabilities.document_range_formatting = false

   -- Enable completion triggered by <c-x><c-o>
   vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

   -- Mappings.
   -- See `:help vim.lsp.*` for documentation on any of the below functions
   local bufopts = { noremap = true, silent = true, buffer = bufnr }
   vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
   vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
   vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
   vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
   vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
   vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
   vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
   vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
   end, bufopts)
   vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
   vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
   vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
   vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
   vim.keymap.set("n", "<space>f", vim.lsp.buf.formatting, bufopts)
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "html", "cssls", "clangd", "tsserver", "jsonls", "bashls" }
for _, lsp in pairs(servers) do
   require("lspconfig")[lsp].setup {
      on_attach = on_attach,
      capabilities = capabilities,
   }
end

--copied from nvchad lspconfig.lua
require("lspconfig").sumneko_lua.setup {
   on_attach = on_attach,
   capabilities = capabilities,

   settings = {
      Lua = {
         diagnostics = {
            globals = { "vim" },
         },
         workspace = {
            library = {
               [vim.fn.expand "$VIMRUNTIME/lua"] = true,
               [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
         },
      },
   },
}
