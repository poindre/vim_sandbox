FROM ubuntu:latest

ARG UID
ARG GID
ARG USERNAME
ARG PASSWORD
ARG REPO

MAINTAINER $USERNAME

# ロケール環境変数の設定
ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

# apt-get install実行時のエラー対策
ENV DEBIAN_FRONTEND=noninteractive

# ロケール環境変数の設定
ENV lang="ja_jp.utf-8" language="ja_jp:ja" lc_all="ja_jp.utf-8"

# ユーザとホームディレクトリの環境変数設定
ENV USER $USERNAME
ENV HOME /home/${USER}
ENV DOTDIR ${HOME}/.dotfiles

# zshと必要なパッケージをインストール
RUN apt-get update \
   && apt-get install -y zsh vim sed git

# zshを実行
RUN zsh

# 環境変数の設定
ENV SHELL /usr/bin/zsh

# ログインシェルを指定
# RUN sed -i.bak "s|$HOME:|$HOME:$SHELL|" /etc/passwd
RUN chsh -s /bin/zsh

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:neovim-ppa/stable && \
    apt-get update -y && \
    apt-get install -y \
    make \
    build-essential \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    llvm \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    curl \
    zip \
    unzip \
    openssl \
    language-pack-ja-base \
    language-pack-ja \
    tig \
    neovim \
    ripgrep \
    screen

# 一般ユーザを追加
RUN groupadd -g ${GID} ${USER}
RUN useradd -g ${GID} -u ${UID} -m ${USER}
# sudo権限を付与
RUN gpasswd -a ${USER} sudo
# パスワードを設定
RUN echo "$USER:$PASSWORD" | chpasswd

ADD ./github_id_rsa $HOME/.ssh/id_rsa

RUN chmod 600 $HOME/.ssh/id_rsa
RUN chown -R ${USER}:${USER} $HOME/.ssh 

# ユーザと作業ディレクトリの変更
USER ${USER}
WORKDIR $HOME

# ディレクトリの作成
RUN mkdir $HOME/.zsh
RUN mkdir $HOME/.vim
RUN mkdir -p $HOME/.config/nvim
RUN mkdir -p $HOME/.cache/dein/repos/github.com/Shougo

# .dotfilesのクローン
RUN git config --global user.email "<>"
RUN git config --global user.name "$USERNAME"
RUN ssh -o StrictHostKeyChecking=no github.com; exit 0
RUN git clone $REPO $DOTDIR
RUN cd $DOTDIR && git pull origin main

# zshファイルのシンボリックリンクを設定
RUN ln -s $DOTDIR/.zshrc.d $HOME/.zsh/.zshrc.d
# init.vimのシンボリックリンクを設定
RUN ln -s $DOTDIR/init.vim $HOME/.config/nvim/init.vim

# preztoをクローン
RUN git clone --recursive \
        https://github.com/sorin-ionescu/prezto.git \
        $HOME/.zsh/.zprezto

# preztoのシンボリックリンクを設定
RUN ln -s $HOME/.zsh/.zprezto/runcoms/zlogin      $HOME/.zsh/.zlogin \
    && ln -s $HOME/.zsh/.zprezto/runcoms/zlogout  $HOME/.zsh/.zlogout \
    && ln -s $DOTDIR/.zpreztorc                   $HOME/.zsh/.zpreztorc \
    && ln -s $HOME/.zsh/.zprezto/runcoms/zprofile $HOME/.zsh/.zprofile \
    && ln -s $HOME/.zsh/.zprezto/runcoms/zshenv   $HOME/.zsh/.zshenv \
    && ln -s $DOTDIR/.zshrc                       $HOME/.zsh/.zshrc

# powerlinep10kのシンボリックリンクを設定
RUN ln -s $DOTDIR/.p10k.zsh $HOME/.zsh/.p10k.zsh

# coc-setting.jsonのシンボリックリンクを設定
RUN ln -s $DOTDIR/coc-setting.json $HOME/.vim/coc-setting.json

# anyenvをクローン
RUN git clone https://github.com/anyenv/anyenv \
        $HOME/.anyenv

RUN ln -s $DOTDIR/.tigrc $HOME/.tigrc

ADD ./.zshenv $HOME/.zshenv

RUN $HOME/.anyenv/bin/anyenv install --force-init
RUN $HOME/.anyenv/bin/anyenv install nodenv
RUN $HOME/.anyenv/bin/anyenv install rbenv
RUN $HOME/.anyenv/bin/anyenv install pyenv

COPY ./setup.sh $HOME/setup.sh
