#!/bin/bash

set -eux -o pipefail

# Macbook Setup

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

brew doctor
brew update
# TODO: Needs vituralbox 6.0 - 6.1 incompatible as at 01/01/2020
# https://download.virtualbox.org/virtualbox/6.0.0/
#brew cask install virtualbox
curl https://download.virtualbox.org/virtualbox/6.0.0/VirtualBox-6.0.0-127566-OSX.dmg -o ~/Downloads/VirtualBox-6.0.0-127566-OSX.dmg \
    && INSTALL_MOUNT="$(hdiutil mount ~/Downloads/VirtualBox-6.0.0-127566-OSX.dmg | tail -1)" \
    && sudo installer -pkg "$(echo "$INSTALL_MOUNT" | awk 'print($3)')/VirtualBox.pkg" -target ~/Applications/ \
    && hdiutil unmount "$(echo "$INSTALL_MOUNT" | awk 'print($1)')" \
    && rm -f ~/Downloads/VirtualBox-6.0.0-127566-OSX.dmg
brew cask install vagrant
vagrant plugin install vagrant-vbguest #vboxsf filesystem


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
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$HOME/.local/bin:$(pyenv root)/shims:/usr/local/Cellar:/usr/local/bin:$PATH

source ~/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=red'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

eval $(dircolors ~/.dircolors/custom)

zstyle ':completion:*:ssh:*' hosts off

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

source ~/Desktop/git/versent/gomi/working/flybuys/cli/bob
source ~/Desktop/git/other/fzf-tab-completion/zsh/fzf-zsh-completion.sh
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
        awscli \
        cfn-lint \
        iterm2 \
        websockets \
        remarshal \
        beautifulsoup4 \
        setuptools \
        git+https://github.com/mattgwwalker/msg-extractor \
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

curl --silent --location "https://github.com/weaveworks/eksctl/releases/download/latest_release/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin/eksctl
chmod 775 /usr/local/bin/eksctl

curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/darwin/amd64/kubectl"
mv ./kubectl /usr/local/bin/kubectl
chmod 775 /usr/local/bin/kubectl

curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash

cd /tmp && curl -L https://istio.io/downloadIstio | bash \
&& chmod 775 ./istio-*/bin/istioctl \
&& mv ./istio-*/bin/istioctl /usr/local/bin/ \
&& mv ./istio-*/tools/_istioctl ~/.oh-my-zsh/completions/

# Install Java 7
# Install Java 7 JCE inside Java 7

# RDP applescript to auto log into
```
tell application "Microsoft Remote Desktop"
    activate
    tell application "System Events"
        set frontmost of process "Microsoft Remote Desktop" to true
        tell process "Microsoft Remote Desktop"
            keystroke "f" using {command down}
            keystroke "OPDGW" --search query
            delay 1
            keystroke tab
            delay 1
            key code 125 -- down
            key code 36 --enter
        end tell
    end tell
end tell
```
