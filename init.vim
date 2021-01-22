" Keep cursor in the middle of the screen"
set scrolloff=999

" Relative line numbers"
set number relativenumber

" Searches with no capitals are case insensitive, searches with capitals are
" case sensitive
set smartcase
set ignorecase

" Preview changes that will be made by 
set inccommand=nosplit

" Save buffer when switching off of it
set autowriteall

" [q and ]q move around in the search buffer
nnoremap <silent> ]q :cnext <CR>
nnoremap <silent> [q :cprevious <CR>

" Install plugins
call plug#begin()

" File Browser
Plug 'preservim/nerdtree'
" Color scheme plugin
Plug 'gryf/wombat256grf'
" Conquer of Completion (IDE Features)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Vue indentation support
Plug 'posva/vim-vue'
" Git lines indicator
Plug 'airblade/vim-gitgutter'
" Git integration
Plug 'tpope/vim-fugitive'
" JSX Highlighting for React
Plug 'maxmellon/vim-jsx-pretty'

call plug#end()

" Apply color scheme
colorscheme wombat256grf

" NERDTree Config

" If we start nvim with no argument open NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
" Close when opening a file
let NERDTreeQuitOnOpen = 1
" \f to toggle
nnoremap <Leader>f :NERDTreeToggle<Enter>
" Automatically close a tab if the only remaining window is NerdTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" With this function you can reuse the same terminal in neovim.
" You can toggle the terminal and also send a command to the same terminal.
" Source https://gist.github.com/ram535/b1b7af6cd7769ec0481eb2eed549ea23

let s:monkey_terminal_window = -1
let s:monkey_terminal_buffer = -1
let s:monkey_terminal_job_id = -1

function! MonkeyTerminalOpen()
  " Check if buffer exists, if not create a window and a buffer
  if !bufexists(s:monkey_terminal_buffer)
    " Creates a window call monkey_terminal
    new monkey_terminal
    " Moves to the window to the bottom
    wincmd J
    " Resize to specific height
    resize 15
    let s:monkey_terminal_job_id = termopen($SHELL, { 'detach': 1 })

     " Change the name of the buffer to "Terminal 1"
     silent file Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
     let s:monkey_terminal_buffer = bufnr('%')

    " The buffer of the terminal won't appear in the list of the buffers
    " when calling :buffers command
    set nobuflisted
  else
    if !win_gotoid(s:monkey_terminal_window)
    sp
    " Moves to the window to the bottom
    wincmd J
    " Resize to specific height
    resize 15
    buffer Terminal\ 1
     " Gets the id of the terminal window
     let s:monkey_terminal_window = win_getid()
    endif
  endif
endfunction

function! MonkeyTerminalToggle()
  if win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalClose()
  else
    call MonkeyTerminalOpen()
  endif
endfunction

function! MonkeyTerminalClose()
  if win_gotoid(s:monkey_terminal_window)
    " close the current window
    hide
  endif
endfunction

function! MonkeyTerminalExec(cmd)
  if !win_gotoid(s:monkey_terminal_window)
    call MonkeyTerminalOpen()
  endif

  " clear current input
  call jobsend(s:monkey_terminal_job_id, "clear\n")

  " run cmd
  call jobsend(s:monkey_terminal_job_id, a:cmd . "\n")
  normal! G
  wincmd p
endfunction

" With this maps you can now toggle the terminal
nnoremap <Leader>t :call MonkeyTerminalToggle()<cr>
tnoremap <Leader>t <C-\><C-n>:call MonkeyTerminalToggle()<cr>
" Use escape key to exit insert mode
tnoremap <Esc> <C-\><C-n>

" Add Ctrl-L in the terminal to clear it
tnoremap <C-l> <C-\><C-n>:call ClearTerminal()<cr>

let scroll_value=10000

function! ClearTerminal()
  set scrollback=1
  let &g:scrollback=1
  call feedkeys("\i")
  call feedkeys("clear\<CR>")
  call feedkeys("\<C-\>\<C-n>")
  call feedkeys("\i")
  sleep 100m
  let &scrollback=g:scroll_value
endfunction

" Start insert mode and disable line numbers on terminal buffer.
augroup terminalsettings
	autocmd!
	if has('nvim')
		autocmd TermOpen *
			\ setlocal nonumber norelativenumber |
			\ startinsert
	endif
augroup end

" Tab settings
set ts=4 sts=4 sw=4 noexpandtab

" Custom tab settings when editing yml and yaml files
autocmd	Filetype yml,yaml set ts=2 sts=2 sw=2 expandtab
" Custom tab settings when editing jsx files
"
autocmd	Filetype jsx,jsx_pretty,javascriptreact set ts=2 sts=2 sw=2 expandtab

" Auto fix all fixable eslint issues on save
call coc#config('eslint', {'autoFixOnSave': v:true})

" Read folders with package.json as workspace folders for javascript
autocmd FileType javascriptreact let b:coc_root_patterns = ['.eslintrc']

" CoC Configuration
"
" extensions:
let g:coc_global_extensions = [
      \'coc-python',
      \'coc-go',
      \'coc-eslint',
      \'coc-tsserver', 
      \'coc-json'
      \]

" Disable/enable eslint with keys
nnoremap <Leader>e :call coc#config('eslint', {'enable': v:false})<cr>
nnoremap <Leader>E :call coc#config('eslint', {'enable': v:true})<cr>
" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
