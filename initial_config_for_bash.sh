#!bin/bash

OS=$(uname -s)
DISTRO=$(grep "ID_LIKE" /etc/os-release | awk -F= '{ print $2 }')
CASK=$(if [ $OS == "Darwin" ]; then echo --cask; fi)

function install_homebrew() {
    if brew --version >&/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
}

## Configure bash and set as default
if [ $SHELL != "/bin/bash" ]; then
    chsh -s /bin/bash
    bash
fi

## Configure bashrc / bash_profile
PROFILE=$(find /Users/renanlira/github/ -name "*bash_profile*")
if [ -f $PROFILE ]; then
    if [ ! -f "$HOME/.bash_profile" ]; then
        ln -s $PROFILE $HOME/.bash_profile >&/dev/null
        if [ $OS == "Linux" ]; then
            mv $HOME/.bashrc $HOME/.bashrc_old
            ln -s $PROFILE $HOME/.bashrc
        fi
    fi
fi

if [ $OS == "Darwin" ]; then
    INSTALLER="brew"
    echo "Since you're using MacOS, you need to install Homebrew to go on."
    read -p "Install Homebrew? [y/N] " yn
    case $yn in
        [Yy] )
            install_homebrew;;
        [Nn]* ) ;;
    esac
elif [ $OS == "Linux" ]; then
    if [[ $DISTRO == *"debian"* ]]; then
        INSTALLER="sudo apt -y"
        echo -e "Updating APT sources\n"
        $INSTALLER update
    elif [[ $DISTRO == *"rhel"* ]]; then
        INSTALLER="sudo dnf -y"
        echo -e "Updating DNF sources\n"
        $INSTALLER check-update
    fi
fi

read -p "Install git? [y/N] " yn
case $yn in
    [Yy] ) $INSTALLER install git;;
    [Nn]* ) ;;
esac

if [ ! -d "$HOME/github/therenanlira/" ]; then
    mkdir -p $HOME/github/therenanlira/
fi

if [ ! -d "$HOME/.bash_it" ]; then
    read -p "Install bash-it now? [y/N] " yn
    case $yn in
        [Yy] )
            git clone --depth=1 https://github.com/Bash-it/bash-it.git $HOME/.bash_it && printf 'y' | $HOME/.bash_it/install.sh
            git clone --depth=1 https://github.com/therenanlira/bash-it-themes.git $HOME/github/therenanlira/bash-it-themes \
            | $HOME/github/therenanlira/bash-it-themes/install.sh
            read -p "Change theme? [y/N] " yn
            case $yn in
                [Yy] )
                    PROFILE=$(ls -l ~/.bash_profile | awk '{print $NF}')
                    echo -e "\n" && ls -l .bash_it/themes/ | awk -F" " '{ print $9 }'
                    read -p "Chose one theme from the list above? [write the theme name] "
                    sed -i "" "s/export BASH_IT_THEME=.*/\export BASH_IT_THEME=$REPLY/g" $PROFILE
                    source $HOME/.bash_profile;;
                [Nn]* ) echo -e "Keeping default theme\n";;
            esac;;
        [Nn]* ) echo -e "Cancelled\n";;
    esac
fi

## Basic
read -p "Install neofetch? [y/N] " yn
case $yn in
    [Yy] ) $INSTALLER install neofetch;;
    [Nn]* ) ;;
esac

read -p "Install figlet? [y/N] " yn
case $yn in
    [Yy] ) $INSTALLER install figlet;;
    [Nn]* ) ;;
esac

read -p "Install vim? [y/N] " yn
case $yn in
    [Yy] )
        $INSTALLER install vim
        if [ -f $HOME/.vimrc ]; then
            rm $HOME/.vimrc.old &>/dev/null
            mv $HOME/.vimrc $HOME/.vimrc.old &>/dev/null
        fi
        echo -e 'set ic\nset nu\nset cul\nset cuc\nset bg=dark' >> $HOME/.vimrc;;
    [Nn]* ) ;;
esac

if [[ $OS == "Darwin" ]]; then
    read -p "Install awk? [y/N] " yn
    case $yn in
        [Yy] ) $INSTALLER install awk;;
        [Nn]* ) ;;
    esac
fi

read -p "Install whois? [y/N] " yn
case $yn in
    [Yy] ) $INSTALLER install whois;;
    [Nn]* ) ;;
esac

read -p "Install nmap? [y/N] " yn
case $yn in
    [Yy] ) $INSTALLER install nmap;;
    [Nn]* ) ;;
esac

if [[ $OS == "Darwin" ]]; then
    read -p "Install watch? [y/N] " yn
    case $yn in
        [Yy] ) $INSTALLER install watch;;
        [Nn]* ) ;;
    esac
fi

read -p "Install BalenaEtcher? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install $CASK balenaetcher
        elif [[ $OS == "Linux" ]]; then
            $INSTALLER install curl
            if [[ $DISTRO == *"debian"* ]]; then
                curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.deb.sh' | sudo -E bash
                $INSTALLER update
            elif [[ $DISTRO == *"rhel"* ]]; then
                curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.rpm.sh'  | sudo -E bash
                $INSTALLER check-update
            fi
            $INSTALLER install balena-etcher-electron
        fi;;
    [Nn]* ) ;;
esac

read -p "Install Firefox? [y/N] " yn
case $yn in
    [Yy] ) $INSTALLER install $CASK firefox;;
    [Nn]* ) ;;
esac

read -p "Install Microsoft Edge? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install $CASK microsoft-edge
        elif [[ $OS == "Linux" ]]; then
            $INSTALLER install curl
            if [[ $DISTRO == *"debian"* ]]; then
                curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
                $INSTALLER -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/
                sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" > /etc/apt/sources.list.d/microsoft-edge-dev.list'
                sudo rm microsoft.gpg
                $INSTALLER update
            elif [[ $DISTRO == *"rhel"* ]]; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                $INSTALLER config-manager --add-repo https://packages.microsoft.com/yumrepos/edge
                $INSTALLER check-update
            fi
            $INSTALLER install microsoft-edge-stable
        fi;;
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

read -p "Install NodeJS? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install node
            $INSTALLER install npm
        elif [[ $OS == "Linux" ]]; then
            $INSTALLER install nodejs
            $INSTALLER install npm
        fi;;
    [Nn]* ) ;;
esac

read -p "Install Python 3? [y/N] " yn
case $yn in
    [Yy] ) 
        $INSTALLER install python3
        $INSTALLER install pipx;;
    [Nn]* ) ;;
esac

read -p "Install jq? [y/N] " yn
case $yn in
    [Yy] ) $INSTALLER install jq;;
    [Nn]* ) ;;
esac

read -p "Install VSCode? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install $CASK visual-studio-code
        elif [[ $OS == "Linux" ]]; then
            if [[ $DISTRO == *"debian"* ]]; then
                $INSTALLER install wget gpg
                wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
                $INSTALLER -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
                sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
                sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] \
                https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
                rm -f packages.microsoft.gpg
                $INSTALLER apt-transport-https
                $INSTALLER update
            elif [[ $DISTRO == *"rhel"* ]]; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=\
                https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" \
                > /etc/yum.repos.d/vscode.repo'
                $INSTALLER check-update
            fi
            $INSTALLER install code
        fi;;
    [Nn]* ) ;;
esac

read -p "Install Lens Spaces? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install $CASK lens
        elif [[ $OS == "Linux" ]]; then
            if [[ $DISTRO == *"debian"* ]]; then
                wget "https://downloads.k8slens.dev/ide/Lens-2022.9.280635-latest.amd64.deb"
                sudo dpkg -i Lens-2022.9.280635-latest.amd64.deb
            elif [[ $DISTRO == *"rhel"* ]]; then
                wget "https://downloads.k8slens.dev/ide/Lens-2022.9.280635-latest.x86_64.rpm"
                sudo rpm -i Lens-2022.9.280635-latest.amd64.rpm
            fi
        fi;;
    [Nn]* ) ;;
esac

read -p "Install Docker? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install $CASK docker
        elif [[ $OS == "Linux" ]]; then
            curl -fsSL https://get.docker.com -o get-docker.sh
            sudo sh get-docker.sh
        fi;;
    [Nn]* ) ;;
esac

if [[ $DISTRO != "rhel" ]]; then
    read -p "Install TablePlus? [y/N] " yn
    case $yn in
        [Yy] ) 
            if [[ $OS == "Darwin" ]]; then
                $INSTALLER install $CASK tableplus
            elif [[ $OS == "Linux" ]]; then
                VERSION=$(grep "DISTRIB_RELEASE" /etc/lsb-release | awk -F= '{ print $2 }' | awk -F. '{ print $1 }')
                wget -qO - https://deb.tableplus.com/apt.tableplus.com.gpg.key | sudo apt-key add -
                sudo add-apt-repository "deb [arch=amd64] https://deb.tableplus.com/debian/$VERSION tableplus main"
                $INSTALLER update
                $INSTALLER install tableplus
            fi;;
        [Nn]* ) ;;
    esac
fi

read -p "Install Gitmoji? [y/N] " yn
case $yn in
    [Yy] ) npm i -g gitmoji-cli;;
    [Nn]* ) ;;
esac

read -p "Install Azure CLI? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install azure-cli
        elif [[ $OS == "Linux" ]]; then
            if [[ $DISTRO == *"debian"* ]]; then
                curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
            elif [[ $DISTRO == *"rhel"* ]]; then
                sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
                $INSTALLER install https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
                $INSTALLER install https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm
                echo -e "[azure-cli] \
                name=Azure CLI \
                baseurl=https://packages.microsoft.com/yumrepos/azure-cli \
                enabled=1 \
                gpgcheck=1 \
                gpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/azure-cli.repo
                $INSTALLER install azure-cli
            fi
        fi;;
    [Nn]* ) ;;
esac

read -p "Install Kubernetes tools? (It needs Homebrew to be installed) [y/N] " yn
case $yn in
    [Yy] )
        if [[ $OS == "Linux" ]]; then
            install_homebrew
        fi
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

read -p "Install Openshift tools? (It needs Homebrew to be installed) [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Linux" ]]; then
            install_homebrew
        fi
        brew install openshift-cli;;
    [Nn]* ) ;;
esac

read -p "Install tldr? [y/N] " yn
case $yn in
    [Yy] ) npm install -g tldr;;
    [Nn]* ) ;;
esac

## Virtualization
read -p "Install Multipass? (On Linux it needs Snap to be installed) [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install multipass
        elif [[ $OS == "Linux" ]]; then
            if [[ $DISTRO == *"rhel"* ]]; then
                $INSTALLER install epel-release
                $INSTALLER upgrade
                $INSTALLER install snapd
                sudo systemctl enable --now snapd.socket
                sudo ln -s /var/lib/snapd/snap /snap
            fi
            $INSTALLER snap install multipass
        fi;;
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
            sudo mkdir /usr/local/opt
            sudo ln -s /opt/homebrew/Cellar/openssl\@1.0/1.0.2u /usr/local/opt/openssl
            brew tap sidneys/homebrew
            brew install aria2 cabextract wimlib cdrtools sidneys/homebrew/chntpw
            brew install utm;;
        [Nn]* ) ;;
    esac
fi

## Gaming
read -p "Install Discord? (On RHEL it needs Snap to be installed)  [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install discord
        elif [[ $OS == "Linux" ]]; then
            if [[ $DISTRO == *"debian"* ]]; then
                $INSTALLER install gdebi-core wget
                wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
                gdebi ~/discord.deb && printf "y"
            elif [[ $DISTRO == *"rhel"* ]]; then
                $INSTALLER install epel-release
                $INSTALLER upgrade
                $INSTALLER install snapd
                sudo systemctl enable --now snapd.socket
                sudo ln -s /var/lib/snapd/snap /snap
                snap install discord
            fi
        fi;;
    [Nn]* ) ;;
esac

read -p "Install Steam? [y/N] " yn
case $yn in
    [Yy] ) 
        if [[ $OS == "Darwin" ]]; then
            $INSTALLER install $CASK steam
        elif [[ $OS == "Linux" ]]; then
            $INSTALLER install steam-installer
        fi;;
    [Nn]* ) ;;
esac
