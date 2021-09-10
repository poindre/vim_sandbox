FROM ubuntu:latest

MAINTAINER s-yoyoyo

ARG UID
ARG GID
ARG USERNAME
ARG REPO

# apt-get install実行時のエラー対策
ENV DEBIAN_FRONTEND=noninteractive

# ロケール環境変数の設定
ENV lang="ja_jp.utf-8" language="ja_jp:ja" lc_all="ja_jp.utf-8"

# ユーザとホームディレクトリの環境変数設定
ENV USER $USERNAME
ENV HOME /home/${USER}

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
    curl \
    language-pack-ja-base \
    language-pack-ja \
    neovim \
    python-dev \
    python3-dev \
    python3-pip

# 一般ユーザを追加
RUN groupadd -g ${GID} ${USER}
RUN useradd -g ${GID} -u ${UID} -m ${USER}
# sudo権限を付与
RUN gpasswd -a ${USER} sudo
# パスワードを設定
RUN echo "$USER:yoyoyo_pass" | chpasswd

ADD ./github_id_rsa $HOME/.ssh/id_rsa
ADD ./github_id_rsa.pub $HOME/.ssh/id_rsa.pub

RUN chmod 600 $HOME/.ssh/id_rsa
RUN chown -R ${USER}:${USER} $HOME/.ssh 

# ユーザと作業ディレクトリの変更
USER ${USER}
WORKDIR $HOME

# .dotfilesのクローン
RUN git config --global user.email "<>"
RUN git config --global user.name "s-yoyoyo"
RUN ssh -o StrictHostKeyChecking=no github.com; exit 0
RUN git clone $REPO $HOME/.dotfiles
RUN cd $HOME/.dotfiles && git pull origin main

# .zshディレクトリ、.dotfilesディレクトリの作成
RUN mkdir $HOME/.zsh

# preztoをクローン
RUN git clone --recursive \
        https://github.com/sorin-ionescu/prezto.git \
        $HOME/.zsh/.zprezto

# preztoのシンボリックリンクを設定
RUN ln -s $HOME/.zsh/.zprezto/runcoms/zlogin       $HOME/.zsh/.zlogin \
    && ln -s $HOME/.zsh/.zprezto/runcoms/zlogout   $HOME/.zsh/.zlogout \
    && ln -s $HOME/.dotfiles/.zpreztorc            $HOME/.zsh/.zpreztorc \
    && ln -s $HOME/.zsh/.zprezto/runcoms/zprofile  $HOME/.zsh/.zprofile \
    && ln -s $HOME/.zsh/.zprezto/runcoms/zshenv    $HOME/.zsh/.zshenv \
    && ln -s $HOME/.dotfiles/.zshrc                $HOME/.zsh/.zshrc

# powerlinep10kのシンボリックリンクを設定
RUN ln -s $HOME/.dotfiles/.p10k.zsh $HOME/.zsh/.p10k.zsh

# ZDOTDIRの設定
RUN echo "export ZDOTDIR=$HOME/.zsh" >> $HOME/.zshenv

RUN pip3 install --upgrade neovim
