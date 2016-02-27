# vimrc-gitfree  
### 文件描述
.vimrc -- daily used vim config  
.vimrc -- temporarily used vim config, less special effect, no plug-in  
.tmux.conf -- tmux config  

### 安装步骤
#### 1. 安装vim
```bash  
brew install vim --with-cscope --with-lua --with-python --enable-gui=yes --override-system-vim
```
#### 2. 安装vundle
```bash
mkdir -p ~/.vim/vimfiles/bundle
cd ~/.vim/vimfiles/bundle
git clone https://github.com/VundleVim/Vundle.vim.git vundle
```

#### 3. 安装vundle插件
启动vim，执行 :PluginInstall  

#### 4. 安装依赖软件
1. 字体（airline依赖）  
双击Monaco for Powerline.otf安装字体 
设置iterm字体为 Monaco for Powerline
2. jedi-vim依赖  
sudo pip install jedi
3. syntastic依赖  
sudo pip install flake8
brew install tidy-html5
4. vim-autopep8依赖  
sudo pip install autopep8
5. editorconfig-vim  
brew install editorconfig
6. vim-instant-markdown  
npm -g install instant-markdown-d
