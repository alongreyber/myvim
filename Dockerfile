FROM alpine

# Install neovim
RUN apk add neovim curl

# Install vim-plug
RUN sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Copy in our vimrc
COPY init.vim /root/.config/nvim/init.vim

# Install plugins
RUN nvim -i NONE -c PlugInstall -c quitall > /dev/null 2>&1

WORKDIR /code
CMD nvim
