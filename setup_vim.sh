echo "set nocompatible          \" Режим совместимости с vi отключен
set encoding=utf-8        \" Кодировка по умолчанию UTF-8
set number                \" Показать номера строк
\" set relativenumber        \" Относительные номера строк
set showcmd               \" Показывать вводимые команды
set cursorline            \" Подсветка текущей строки
set wildmenu              \" Расширенное меню автодополнения

\" Настройки табуляции
set expandtab             \" Использовать пробелы вместо табуляции
set tabstop=4             \" Ширина табуляции 4 пробела
set shiftwidth=4          \" Количество пробелов для автозамены табуляции
set softtabstop=4         \" Количество пробелов для табуляции в режиме редактирования

\" Подсветка синтаксиса
syntax on                 \" Включить подсветку синтаксиса
set background=dark       \" Темный фон для подсветки

\" Установка плагинов с помощью vim-plug
call plug#begin('~/.vim/plugged')

\" Плагины
Plug 'tpope/vim-fugitive'          \" Git интеграция
Plug 'preservim/nerdtree'          \" Дерево файлов
Plug 'airblade/vim-gitgutter'      \" Показывать изменения в git
Plug 'nvim-lua/plenary.nvim'       \" Зависимость для многих плагинов
Plug 'hrsh7th/nvim-compe'          \" Автодополнение

call plug#end()

\" Настройки поиска
set ignorecase            \" Игнорировать регистр при поиске
set smartcase             \" Учитывать регистр, если он был использован в поиске
set incsearch             \" Инкрементальный поиск

\" Настройки автозавершения
set completeopt=menu,menuone,noselect \" Настройки автозавершения

\" Настройки буферов и окон
set splitright            \" Открывать вертикальные окна справа
set splitbelow            \" Открывать горизонтальные окна снизу
" >> ~/.vimrc &&
vim -c 'PlugInstall' -c 'qa'
