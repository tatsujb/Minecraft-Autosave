#!/bin/bash
if cd $HOME/.minecraft && [ -d "assets" ] && [ -d "libraries" ] && [ -d "resourcepacks" ] && [ -d "server-resource-packs" ] && [ -d "versions" ] ; then

  if [ ! -d ".git" ] ; then
    git init
  else
    var1=$(sed -rn 's/.*#!(.*?)/\1/p' .git/config)
    var2=$(sed -rn 's/.*#@(.*?)/\1/p' .git/config)
    var3=$(sed 's/^[ \t]*//' .git/config | sed ':a;N;$!ba;s/\n//g' | sed -rn 's/.*https:\/\/(.*?)fetch.*/\1/p')
  fi
  if [[ -z "$var1" ]] && [[ -z "$var2" ]] && [[ -z "$var3" ]] ; then
    read -p 'please type (or paste) personal Minecraft autosave github repo adress (ending with ".git") : ' var4
    git remote add origin $var4
    var3=$(sed 's/^[ \t]*//' .git/config | sed ':a;N;$!ba;s/\n//g' | sed -rn 's/.*https:\/\/(.*?)fetch.*/\1/p')
    read -p 'please type github username : ' var1
    echo "#!$var1" >> .git/config
    read -sp 'please type github password : ' var2
    echo ""
    echo "#@$var2" >> .git/config
  else
    if whiptail --yesno "Use found variable(s) $var1 $var2 $var3 ?" 7 90 ;then
      if [[ -z "$var3" ]] ; then
        read -p 'please type (or paste) personal Minecraft autosave github repo adress (ending with ".git") : ' var4
        git remote add origin $var4
        var3=$(sed 's/^[ \t]*//' .git/config | sed ':a;N;$!ba;s/\n//g' | sed -rn 's/.*https:\/\/(.*?)fetch.*/\1/p')
      fi
      if [[ -z "$var1" ]] ; then
        read -p 'please type github username : ' var1
        echo "#!$var1" >> .git/config
      fi
      if [[ -z "$var2" ]] ; then
        read -sp 'please type github password : ' var2
        echo ""
        echo "#@$var2" >> .git/config
      fi
    else
      read -p 'please type (or paste) personal Minecraft autosave github repo adress (ending with ".git") : ' var4
      git remote add origin $var4
      var3=$(sed 's/^[ \t]*//' .git/config | sed ':a;N;$!ba;s/\n//g' | sed -rn 's/.*https:\/\/(.*?)fetch.*/\1/p')
      read -p 'please type github username : ' var1
      echo "#!$var1" >> .git/config
      read -sp 'please type github password : ' var2
      echo ""
      echo "#@$var2" >> .git/config
    fi
  fi
  while true; do
  dt=$(date '+%d/%m/%Y %H:%M:%S');
  if pgrep -f minecraft
  then
  git fetch;
  git add -v -A saves;
  git pull origin master --force;
  git commit -m "$dt automated update"; #-q -u[no]
  git remote -v;
  git push https://$var1:$var2@$var3 master --force;
  else
  echo "Minecraft not running, run Minecraft to continue";
  fi
  sleep 60;
  done
else
    echo "There is no .minecraft folder. Run Minecraft first."
fi
