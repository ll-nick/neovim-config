vim.pack.add({ 'https://github.com/rmagatti/auto-session' })

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
require('auto-session').setup({})
