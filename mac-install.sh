#!/bin/bash

set -eu -o pipefail
set -x

#Macbook Setup

mkdir homebrew \
    && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew \
    && rm -rf homebrew \
    && brew update

brew install \
    coreutils \
    findutils \
    git \
    gnu-tar \
    gnu-sed \
    gawk \
    gnutls \
    gnu-indent \
    gnu-getopt \
    grep \
    pyenv \
    jq \
    yamllint \
    zbar \
    oath-toolkit

# For stoken
brew install \
    autoconf \
    automake \
    libtool \
    nettle \
    pkg-config \
    gtk+3 \
    gnome-icon-theme \
    hicolor-icon-theme

# Command line/text editing tools
brew install \
    fzf \
    vim
$(brew --prefix)/opt/fzf/install

# oh-my-zsh - Terminal tool
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
# oh-my-zsh plugins
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
sed -i '' 's/^plugins=.*/plugins=(git zsh-autosuggestions gnu-utils)/' ~/.zshrc

cp aliases ~/.aliases

tee -a ~/.zshrc <<EOF
source ~/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=red'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
EOF


# Python versions for VMS debugging
# User installs are kept per version
for py_version in "3.7.3" "3.6.7"
do
    pyenv install $py_version
    pyenv global $py_version
    pip install --upgrade pip
    pip install \
        jmespath \
        requests \
        ruamel.yaml \
        bs4 \
        boto3 \
        botocore \
        awslogs \
        cfn-lint \
        iterm2 \
        --user
done

sed -i '' 's#export PATH=#export PATH=$(brew --prefix coreutils)/libexec/gnubin:/Users/davidbochenski/.local:$(pyenv root)/shims:/usr/local/Cellar:$HOME/bin:/usr/local/bin:$PATH/' ~/.zshrc

curl https://releases.hashicorp.com/packer/1.4.2/packer_1.4.2_darwin_amd64.zip -o ~/Downloads/packer_1.4.2.zip \
    && unzip ~/Downloads/packer_1.4.2.zip -d ~/.local/bin \
    && rm ~/Downloads/packer_1.4.2.zip

# stoken for RSA seed file import
export LIBTOOL=glibtool
git clone git://github.com/cernekee/stoken
cd stoken
bash autogen.sh
./configure
make
make check
make install
cd ../ && rm -rf ./stoken
#stoken import --file <path to sdtid>
