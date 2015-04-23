#!/bin/bash
RCol='\e[0m'    # Text Reset
# Regular           Bold                Underline           High Intensity      BoldHigh Intens     Background          High Intensity Backgrounds
Bla='\e[0;30m';     BBla='\e[1;30m';    UBla='\e[4;30m';    IBla='\e[0;90m';    BIBla='\e[1;90m';   On_Bla='\e[40m';    On_IBla='\e[0;100m';
Red='\e[0;31m';     BRed='\e[1;31m';    URed='\e[4;31m';    IRed='\e[0;91m';    BIRed='\e[1;91m';   On_Red='\e[41m';    On_IRed='\e[0;101m';
Gre='\e[0;32m';     BGre='\e[1;32m';    UGre='\e[4;32m';    IGre='\e[0;92m';    BIGre='\e[1;92m';   On_Gre='\e[42m';    On_IGre='\e[0;102m';
Yel='\e[0;33m';     BYel='\e[1;33m';    UYel='\e[4;33m';    IYel='\e[0;93m';    BIYel='\e[1;93m';   On_Yel='\e[43m';    On_IYel='\e[0;103m';
Blu='\e[0;34m';     BBlu='\e[1;34m';    UBlu='\e[4;34m';    IBlu='\e[0;94m';    BIBlu='\e[1;94m';   On_Blu='\e[44m';    On_IBlu='\e[0;104m';
Pur='\e[0;35m';     BPur='\e[1;35m';    UPur='\e[4;35m';    IPur='\e[0;95m';    BIPur='\e[1;95m';   On_Pur='\e[45m';    On_IPur='\e[0;105m';
Cya='\e[0;36m';     BCya='\e[1;36m';    UCya='\e[4;36m';    ICya='\e[0;96m';    BICya='\e[1;96m';   On_Cya='\e[46m';    On_ICya='\e[0;106m';
Whi='\e[0;37m';     BWhi='\e[1;37m';    UWhi='\e[4;37m';    IWhi='\e[0;97m';    BIWhi='\e[1;97m';   On_Whi='\e[47m';    On_IWhi='\e[0;107m';

app_name='Wi-Fi Auto Reconnect'
echo "$app_name iniciado"
echo
rfkill list
echo
caiu=0
while true
do
    # verifica se ta usando minha ufop
    # iwconfig
    echo 'Tentando conectar...'
    # verifica se ta com internet pegando o ip externo
    # http://www.if-not-true-then-false.com/2010/linux-get-ip-address/
    ip=`curl -connect-timeout 2 -s http://ipecho.net/plain`
    echo "IP: $ip"
    # pega a data atual
    data=`date`
    if [ "$ip" = "" ] || [ "$ip" = "curl: (6) Could not resolve host: ipecho.net" ]
    then
        if [ "$caiu" -eq 1 ]
        then
            notify-send -u low -a "$app_name" 'Internet nao voltou'
            echo -e "${IRed}$data - Internet nao voltou${RCol}"
        else
            notify-send -u low -a "$app_name" 'Internet caiu'
            echo -e "${IRed}$data - Internet caiu${RCol}"
        fi
        caiu=1
        
        echo -e "${IRed}$data - desconectando e reconectando...${RCol}"
        #desliga e religa a interface wi-fi
        rfkill block 0
        sleep 2
        rfkill unblock 0

        #dorme por um minuto
        sleep 60
    else
        if [ "$caiu" -eq 1 ]
        then
            notify-send -u low -a "$app_name" 'Internet voltou'
            echo -e "${IBlu}$data - Internet voltou${RCol}"
        else
            echo -e "${IBlu}$data - Ainda conectado${RCol}"
        fi
        caiu=0
        sleep 30
    fi
    echo
done
