set rtp+=.
set rtp+=vendor/plenary.nvim/

runtime plugin/plenary.vim

lua require('plenary.busted')
lua require('stay-in-place').setup({})
