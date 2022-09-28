#!/bin/bash

GITHUB='git@github.com:therenanlira'
REPOS="repo1 repo2 repo3"

for REPO in $REPOS; do
    git clone --bare $GITHUB$REPO.git >> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo -e "\033[0;32mClone $REPO OK";
        else
        echo -e "\033[0;31mClone $REPO NOK";
    fi
done

# function pause(){
#    read -p "$*"
# }

# pause 'Após renomear os repositórios antigos e criar os novos com o mesmo nome, pressione Enter...'

# for REPO in $REPOS; do
#     cd $REPO.git
#     git push --mirror $GITHUB$REPO.git >> /dev/null 2>&1
#     cd ..
#     if [ $? -eq 0 ]; then
#         echo -e "\033[0;32mPush $REPO OK";
#         else
#         echo -e "\033[0;31mPush $REPO NOK";
#     fi
# done
