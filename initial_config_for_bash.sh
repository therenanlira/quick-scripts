#!bin/bash

OS=$(uname -s)

## Configure bash and set as default
if [ $SHELL != "/bin/bash" ]; then
    chsh -s /bin/bash
    bash
fi

## Configure bashrc / bash_profile
if [ ! -f "$HOME/.bash_profile" ]; then
    ln -s $HOME/github/therenanlira/personal/bash_profile $HOME/.bash_profile
    if [ $OS == "Linux" ]; then
        mv $HOME/.bashrc $HOME/.bashrc_old
        ln -s $HOME/github/therenanlira/personal/bash_profile $HOME/.bashrc
    fi
fi

read -p "Install Homebrew? (It's necessary to go on) [y/N] " yn
case $yn in
    [Yy] )
        if [ $OS == "Darwin"]; then
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        elif [ $OS == "Linux" ]; then
            test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
            test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
        eval $($(brew --prefix)/bin/brew shellenv);;
    [Nn]* ) ;;
esac

read -p "Install git? [y/N] " yn
case $yn in
    [Yy] ) brew install git;;
    [Nn]* ) ;;
esac

if [ ! -d "$HOME/github/therenanlira/" ]; then
    mkdir $HOME/github/therenanlira/
fi
if [ ! -d "$HOME/.bash_it" ]; then
    read -p "Install bash-it now? [y/N] " yn
    case $yn in
        [Yy] )
            git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it && printf 'y' | $HOME/.bash_it/install.sh
            git clone git@github.com:therenanlira/bash-it-themes.git $HOME/github/therenanlira/
            read -p "Change theme? [y/N] " yn
            case $yn in
                [Yy] )
                    echo -e "" && ls -l $HOME/github/therenanlira/bash-it-themes | egrep '^d' | awk -F" " '{ print $9 }'
                    read -p "Chose one theme from the list above? [write the theme name] "
                    sed -i "" "s/export BASH_IT_THEME=.*/\export BASH_IT_THEME=$REPLY/g" $HOME/github/therenanlira/personal/bash_profile
                    source $HOME/.bash_profile;;
                [Nn]* ) echo -e "Keeping default theme\n";;
            esac;;
        [Nn]* ) echo -e "Cancelled\n";;
    esac
fi

## Basic
read -p "Install neofetch? [y/N] " yn
case $yn in
    [Yy] ) brew install neofetch;;
    [Nn]* ) ;;
esac

read -p "Install figlet? [y/N] " yn
case $yn in
    [Yy] ) brew install figlet;;
    [Nn]* ) ;;
esac

read -p "Install vim? [y/N] " yn
case $yn in
    [Yy] )
        brew install vim
        if [ -f $HOME/.vimrc ]; then
            rm $HOME/.vimrc.old &>/dev/null
            mv $HOME/.vimrc $HOME/.vimrc.old &>/dev/null
        fi
        echo -e 'set ic\nset nu\nset cul\nset cuc\nset bg=dark' >> $HOME/.vimrc
    [Nn]* ) ;;
esac

read -p "Install awk? [y/N] " yn
case $yn in
    [Yy] ) brew install awk;;
    [Nn]* ) ;;
esac

read -p "Install whois? [y/N] " yn
case $yn in
    [Yy] ) brew install whois;;
    [Nn]* ) ;;
esac

read -p "Install nmap? [y/N] " yn
case $yn in
    [Yy] ) brew install nmap;;
    [Nn]* ) ;;
esac

read -p "Install watch? [y/N] " yn
case $yn in
    [Yy] ) brew install watch;;
    [Nn]* ) ;;
esac

read -p "Install BalenaEtcher? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask balenaetcher;;
    [Nn]* ) ;;
esac

read -p "Install Firefox? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask firefox;;
    [Nn]* ) ;;
esac

read -p "Install Microsoft Edge? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask microsoft-edge;;
    [Nn]* ) ;;
esac

## Developing
read -p "Install XCode? [y/N] " yn
case $yn in
    [Yy] ) xcode-select --install;;
    [Nn]* ) ;;
esac

read -p "Install Node? [y/N] " yn
case $yn in
    [Yy] ) brew install node;;
    [Nn]* ) ;;
esac

read -p "Install Python 3? [y/N] " yn
case $yn in
    [Yy] ) brew install python3; brew install pipx;;
    [Nn]* ) ;;
esac

read -p "Install jq? [y/N] " yn
case $yn in
    [Yy] ) brew install jq;;
    [Nn]* ) ;;
esac

read -p "Install VSCode? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask visual-studio-code;;
    [Nn]* ) ;;
esac

read -p "Install Lens Spaces? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask lens;;
    [Nn]* ) ;;
esac

read -p "Install Docker? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask docker;;
    [Nn]* ) ;;
esac

read -p "Install Postman? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask postman;;
    [Nn]* ) ;;
esac

read -p "Install TablePlus? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask tableplus;;
    [Nn]* ) ;;
esac

read -p "Install Microsoft Azure Storage Explorer? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask microsoft-azure-storage-explorer;;
    [Nn]* ) ;;
esac

read -p "Install Gitmoji? [y/N] " yn
case $yn in
    [Yy] ) brew install gitmoji;;
    [Nn]* ) ;;
esac

read -p "Install Azure CLI? [y/N] " yn
case $yn in
    [Yy] ) brew install azure-cli;;
    [Nn]* ) ;;
esac

read -p "Install Kubernetes tools? [y/N] " yn
case $yn in
    [Yy] )
        brew install kubectl; brew install kubectx;
        brew install fzf; ## kubectx and kubens with interactive mode
        brew install kubecm;
        brew install k9s;
        brew install kubecfg; brew install bash-completion;
        kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl;
        brew install helm; brew tap robscott/tap; brew install robscott/tap/kube-capacity;
        brew tap oleewere/repo; brew install cmctl; brew install cfssl;;
    [Nn]* ) ;;
esac

read -p "Install Openshift tools? [y/N] " yn
case $yn in
    [Yy] ) brew install openshift-cli;;
    [Nn]* ) ;;
esac

read -p "Install TLDR? [y/N] " yn
case $yn in
    [Yy] ) npm install -g tldr;;
    [Nn]* ) ;;
esac

## Virtualization
read -p "Install Multipass? [y/N] " yn
case $yn in
    [Yy] ) brew install multipass;;
    [Nn]* ) ;;
esac

read -p "Install VM Fusion? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask vmware-fusion;;
    [Nn]* ) ;;
esac

read -p "Install UTM app [y/N] " yn
case $yn in
    [Yy] ) 
        if [ -z $(grep 'Patch to correctly select ARM architecture' "/opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb") ]; then
            cp /opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb /opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb.bkp
            sed -i '' 's+  version_scheme 1+  version_scheme 1\n\n  # Patch to correctly select ARM architecture\n  patch do\n  url "https://gist.githubusercontent.com/felixbuenemann/5f4dcb30ebb3b86e1302e2ec305bac89/raw/b339a33ff072c9747df21e2558c36634dd62c195/openssl-1.0.2u-darwin-arm64.patch"\n  sha256 "4ad22bcfc85171a25f035b6fc47c7140752b9ed7467bb56081c76a0a3ebf1b9f"\n  end+' /opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb
            sed -i '' 's+    arch_args = \%w\[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128\]+    # arch_args = \%w\[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128\]\n    arch_args = \%W\[darwin64-#\{Hardware::CPU.arch\}-cc enable-ec_nistp_64_gcc_128\]+' /opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb
        fi
        sudo mkdir /usr/local/opt
        sudo ln -s /opt/homebrew/Cellar/openssl\@1.0/1.0.2u /usr/local/opt/openssl
        brew tap sidneys/homebrew
        brew install aria2 cabextract wimlib cdrtools sidneys/homebrew/chntpw
        brew install utm;;
    [Nn]* ) ;;
esac

## Gaming
read -p "Install Discord? [y/N] " yn
case $yn in
    [Yy] ) brew install discord;;
    [Nn]* ) ;;
esac

read -p "Install Steam? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask steam;;
    [Nn]* ) ;;
esac

read -p "Install NVidia GeForce Now? [y/N] " yn
case $yn in
    [Yy] ) brew install --cask nvidia-geforce-now;;
    [Nn]* ) ;;
esac
