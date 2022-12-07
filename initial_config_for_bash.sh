#!bin/bash

OS=$(uname -s)
DISTRO=$(test -f /etc/os-release && grep "ID_LIKE" /etc/os-release | awk -F= '{ print $2 }')
INSTALL="brew install"

function install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

function install_node() {
    $INSTALL node
    $INSTALL npm
}

## Configure bash and set as default
if [ $SHELL != "/bin/bash" ]; then
    chsh -s /bin/bash
    bash
fi

## Configure bashrc / bash_profile
mkdir ~/github &>/dev/null
PROFILE=$(find ~/github/ -name "*bash_profile*" | awk '{ print $NF }')
if [ -f $PROFILE ]; then
    if [ ! -e "$HOME/.bash_profile" ]; then
        ln -s $PROFILE ~/.bash_profile
        if [ $OS == "Linux" ]; then
            if ! grep ". $HOME/.bash_profile"  ~/.bashrc; then
                echo -e "\n. ~/.bash_profile" >> ~/.bashrc
            fi
        fi
    fi
fi

## Set installer up
echo -e "This script needs Homebrew to go on."
read -p "Install Homebrew? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Linux" || $DISTRO == "debian" ]]; then
            sudo apt-get update
            sudo apt-get install curl git-all -y
            install_homebrew
        elif [[ $OS == "Linux" || $DISTRO == "rhel" ]]; then
            sudo dnf update
            sudo dnf install curl git-all -y
            install_homebrew
        elif [[ $OS == "Darwin" ]]; then
            install_homebrew
            $INSTALL git
        fi;;
    [Nn]* ) exit;;
esac

if [ ! -d "$HOME/.bash_it" ]; then
    read -p "Install bash-it now? [y/N] " yn
    case $yn in
        [Yy] )
            mkdir -p ~/github/therenanlira &>/dev/null
            git clone --depth=1 https://github.com/Bash-it/bash-it.git ~/.bash_it && printf 'y' | ~/.bash_it/install.sh
            git clone --depth=1 https://github.com/therenanlira/bash-it-themes.git ~/github/therenanlira/bash-it-themes \
            | ~/github/therenanlira/bash-it-themes/install.sh
            read -p "Want to change the default theme? [y/N] " yn
            case $yn in
                [Yy] )
                    echo -e "\n" && ls -l .bash_it/themes/ | awk -F" " '{ print $9 }'
                    read -p "Chose one theme from the list above? [write the theme name] "
                    sed -i "" "s/export BASH_IT_THEME=.*/\export BASH_IT_THEME=$REPLY/g" ~/.bash_profile
                    source ~/.bash_profile;;
                [Nn]* ) echo -e "Keeping default theme\n";;
            esac;;
        [Nn]* ) ;;
    esac
fi

## Basic and useless
read -p "Install neofetch? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL neofetch;;
    [Nn]* ) ;;
esac

read -p "Install figlet? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL figlet;;
    [Nn]* ) ;;
esac

## Text manipulation
read -p "Install vim? [y/N] " yn
case $yn in
    [Yy] )
        $INSTALL vim
        if [ -f $HOME/.vimrc ]; then
            rm ~/.vimrc.old &>/dev/null
            mv ~/.vimrc ~/.vimrc.old &>/dev/null
        fi
        echo -e 'set ic\nset nu\nset cul\nset cuc\nset bg=dark' >> ~/.vimrc;;
    [Nn]* ) ;;
esac

read -p "Install ed? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL ed;;
    [Nn]* ) ;;
esac

read -p "Install awk? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL awk;;
    [Nn]* ) ;;
esac

read -p "Install jq? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL jq;;
    [Nn]* ) ;;
esac

read -p "Install tldr? [y/N] " yn
case $yn in
    [Yy] ) 
        install_node
        npm install -g tldr;;
    [Nn]* ) ;;
esac

## Packages and network
read -p "Install watch? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL watch;;
    [Nn]* ) ;;
esac

read -p "Install whois? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL whois;;
    [Nn]* ) ;;
esac

read -p "Install nmap? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL nmap;;
    [Nn]* ) ;;
esac

## ISO manipulation
read -p "Install BalenaEtcher? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL --cask balenaetcher;;
    [Nn]* ) ;;
esac

## Browsers
read -p "Install Firefox? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL --cask firefox;;
    [Nn]* ) ;;
esac

read -p "Install Microsoft Edge? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL --cask microsoft-edge;;
    [Nn]* ) ;;
esac

## Developing
if [[ $OS == "Darwin" ]]; then
    read -p "Install XCode? [y/N] " yn
    case $yn in
        [Yy] ) xcode-select --install;;
        [Nn]* ) ;;
    esac
fi

read -p "Install Gitmoji? Needs NodeJS. [y/N] " yn
case $yn in
    [Yy] ) 
        install_node
        npm i -g gitmoji-cli;;
    [Nn]* ) ;;
esac

read -p "Install NodeJS? [y/N] " yn
case $yn in
    [Yy] ) install_node;;
    [Nn]* ) ;;
esac

read -p "Install Python3? [y/N] " yn
case $yn in
    [Yy] ) 
        $INSTALL python3
        $INSTALL pipx;;
    [Nn]* ) ;;
esac

read -p "Install Go? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL go;;
    [Nn]* ) ;;
esac

read -p "Install Docker? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL --cask docker;;
    [Nn]* ) ;;
esac

read -p "Install VSCode? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL --cask visual-studio-code;;
    [Nn]* ) ;;
esac

read -p "Install Postman? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL postman;;
    [Nn]* ) ;;
esac

if [[ $OS == "Linux" || $DISTRO != "rhel" ]]; then
    read -p "Install TablePlus? [y/N] " yn
    case $yn in
        [Yy] ) $INSTALL --cask tableplus;;
        [Nn]* ) ;;
    esac
fi

read -p "Install Azure CLI? [y/N] " yn
case $yn in
    [Yy] ) pipx install azure-cli==2.40.0;;
    [Nn]* ) ;;
esac

read -p "Install Kubernetes tools? [y/N] " yn
case $yn in
    [Yy] )
        $INSTALL kubectl; $INSTALL kubectx
        $INSTALL fzf ## kubectx and kubens with interactive mode
        $INSTALL k9s
        $INSTALL bash-completion
        kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
        $INSTALL helmbrew tap robscott/tap; $INSTALL robscott/tap/kube-capacity
        (
            set -x; cd "$(mktemp -d)" &&
            OS="$(uname | tr '[:upper:]' '[:lower:]')" &&
            ARCH="$(uname -m | sed -e 's/x86_64/amd64/' -e 's/\(arm\)\(64\)\?.*/\1\2/' -e 's/aarch64$/arm64/')" &&
            KREW="krew-${OS}_${ARCH}" &&
            curl -fsSLO "https://github.com/kubernetes-sigs/krew/releases/latest/download/${KREW}.tar.gz" &&
            tar zxvf "${KREW}.tar.gz" &&
            ./"${KREW}" install krew
        )
        kubectl krew install neat
        brew tap oleewere/repo; $INSTALL cmctl; $INSTALL cfssl;;
    [Nn]* ) ;;
esac

read -p "Install Openshift tools? [y/N] " yn
case $yn in
    [Yy] ) 
        $INSTALL openshift-cli
        oc completion bash > $(brew --prefix)/etc/bash_completion.d/oc_bash_completion;;
    [Nn]* ) ;;
esac

read -p "Install Lens Spaces? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL --cask lens;;
    [Nn]* ) ;;
esac

## Virtualization
read -p "Install Multipass? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL multipass;;
    [Nn]* ) ;;
esac

if [ $OS == "Darwin" ]; then
    read -p "Install UTM app [y/N] " yn
    case $yn in
        [Yy] ) 
            if [ -z $(grep 'Patch to correctly select ARM architecture' "/opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb") ]; then
                cp /opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb /opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb.bkp
                sed -i '' 's+  version_scheme 1+  version_scheme 1\n\n  # Patch to correctly select ARM architecture\n  patch do\n  url "https://gist.githubusercontent.com/felixbuenemann/5f4dcb30ebb3b86e1302e2ec305bac89/raw/b339a33ff072c9747df21e2558c36634dd62c195/openssl-1.0.2u-darwin-arm64.patch"\n  sha256 "4ad22bcfc85171a25f035b6fc47c7140752b9ed7467bb56081c76a0a3ebf1b9f"\n  end+' /opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb
                sed -i '' 's+    arch_args = \%w\[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128\]+    # arch_args = \%w\[darwin64-x86_64-cc enable-ec_nistp_64_gcc_128\]\n    arch_args = \%W\[darwin64-#\{Hardware::CPU.arch\}-cc enable-ec_nistp_64_gcc_128\]+' /opt/homebrew/Library/Taps/sidneys/homebrew-homebrew/Formula/openssl@1.0.rb
            fi
            sudo mkdir /usr/local/opt &>/dev/null
            sudo ln -s /opt/homebrew/Cellar/openssl\@1.0/1.0.2u /usr/local/opt/openssl
            brew tap sidneys/homebrew
            $INSTALL aria2 cabextract wimlib cdrtools sidneys/homebrew/chntpw
            $INSTALL utm;;
        [Nn]* ) ;;
    esac
fi

## Gaming
read -p "Install Discord? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL discord;;
    [Nn]* ) ;;
esac

read -p "Install Steam? [y/N] " yn
case $yn in
    [Yy] ) $INSTALL --cask steam;;
    [Nn]* ) ;;
esac
