######## CANNOT REMOVE THE BOTTOM LINES FROM HERE.  ####
if [[ -f ~/.bashrc ]]; then                         ####
  source ~/.bashrc      # DO NOT DELETE THIS LINE.  ####
fi                                                  ####
if [[ -f ~/.bash.bashrc ]]; then                    ####
  source ~/.bash.bashrc # DO NOT DELETE THIS LINE.  ####
fi                                                  ####
if [[ -n "${INTR}" ]]; then                         ####
  if [ -f ~/.bash_profile.intr ]; then              ####
    source ~/.bash_profile.intr                     ####
  fi                                                ####
elif [[ ${HOSTNAME} =~ login ]]; then               ####
  if [ -f ~/.bash_profile.login ]; then             ####
    source ~/.bash_profile.login                    ####
  fi                                                ####
fi                                                  ####
######## CANNOT REMOVE THE LINES UP TO THIS PLACE.  ####

