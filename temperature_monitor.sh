#!/bin/bash
export LC_NUMERIC="en_US.UTF-8"
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

app_name='Temperature Monitor'

#watch -n 1 -d sensors
temp_normal=60
temp_alta=80
cont_media=0
temp_media=(0 0 0 0 0)
temp_core=(0 0 0 0 0)

echo "$app_name iniciado"
echo
while true
do
    cont_media=$((cont_media+1))
    temp_core[0]=`sudo sensors | grep 'Physical id 0' | awk '{print $4}' | cut -c2-5`
    temp_core[1]=`sudo sensors | grep 'Core 0' | awk '{print $3}' | cut -c2-5`
    temp_core[2]=`sudo sensors | grep 'Core 1' | awk '{print $3}' | cut -c2-5`
    temp_core[3]=`sudo sensors | grep 'Core 2' | awk '{print $3}' | cut -c2-5`
    temp_core[4]=`sudo sensors | grep 'Core 3' | awk '{print $3}' | cut -c2-5`
    temp_core[0]=$( printf "%.0f" ${temp_core[0]} )
    temp_core[1]=$( printf "%.0f" ${temp_core[1]} )
    temp_core[2]=$( printf "%.0f" ${temp_core[2]} )
    temp_core[3]=$( printf "%.0f" ${temp_core[3]} )
    temp_core[4]=$( printf "%.0f" ${temp_core[4]} )
    quente=false
    muito_quente=false
    temp_media[0]=$(( (${temp_media[0]}*($cont_media-1)+${temp_core[0]}) / $cont_media ))
    temp_media[1]=$(( (${temp_media[1]}*($cont_media-1)+${temp_core[1]}) / $cont_media ))
    temp_media[2]=$(( (${temp_media[2]}*($cont_media-1)+${temp_core[2]}) / $cont_media ))
    temp_media[3]=$(( (${temp_media[3]}*($cont_media-1)+${temp_core[3]}) / $cont_media ))
    temp_media[4]=$(( (${temp_media[4]}*($cont_media-1)+${temp_core[4]}) / $cont_media ))

    str_phisical="Phisical normal: ${temp_core[0]}ºC"
    str_core0="Core 0 normal: ${temp_core[1]}ºC"
    str_core1="Core 1 normal: ${temp_core[2]}ºC"
    str_core2="Core 2 normal: ${temp_core[3]}ºC"
    str_core3="Core 3 normal: ${temp_core[4]}ºC"

    if [ ${temp_core[0]} -gt $temp_alta ]
    then
        str_phisical="Phisical em ${temp_core[0]}ºC"
        muito_quente=true
    fi
    if [ ${temp_core[1]} -gt $temp_alta ]
    then
        str_core0="Core 0 em ${temp_core[1]}ºC"
        muito_quente=true
    fi
    if [ ${temp_core[2]} -gt $temp_alta ]
    then
        str_core1="Core 1 em ${temp_core[2]}ºC"
        muito_quente=true
    fi
    if [ ${temp_core[3]} -gt $temp_alta ]
    then
        str_core2="Core 2 em ${temp_core[3]}ºC"
        muito_quente=true
    fi
    if [ ${temp_core[4]} -gt $temp_alta ]
    then
        str_core3="Core 3 em ${temp_core[4]}ºC"
        muito_quente=true
    fi
    if [ "$muito_quente" = true ]
    then
        result="$(date)
            ALERTA: Temperaturas Muito Altas
        $str_phisical
        $str_core0
        $str_core1
        $str_core2
        $str_core3"
        notify-send -u critical -a "$app_name" "$result"
        echo -e "${Red}$result${ICol}"
    fi
    if [ "$muito_quente" = false ]
    then
        if [ ${temp_core[0]} -gt $temp_normal ]
        then
            str_phisical="Phisical em ${temp_core[0]}ºC"
            quente=true
        fi
        if [ ${temp_core[1]} -gt $temp_normal ]
        then
            str_core0="Core 0 em ${temp_core[1]}ºC"
            quente=true
        fi
        if [ ${temp_core[2]} -gt $temp_normal ]
        then
            str_core1="Core 1 em ${temp_core[2]}ºC"
            quente=true
        fi
        if [ ${temp_core[3]} -gt $temp_normal ]
        then
            str_core2="Core 2 em ${temp_core[3]}ºC"
            quente=true
        fi
        if [ ${temp_core[4]} -gt $temp_normal ]
        then
            str_core3="Core 3 em ${temp_core[4]}ºC"
            quente=true
        fi
        if [ "$quente" = true ]
        then
            result="$(date)
            ALERTA: Temperaturas Altas
        $str_phisical
        $str_core0
        $str_core1
        $str_core2
        $str_core3"
            notify-send -u normal -a "$app_name" "$result"
            echo -e "${Red}$result${ICol}"
        fi
    fi
    #calcula media
    if [ "$quente" = false ] && [ "$muito_quente" = false ] 
    then
        result="$(date)
            Tudo ok
        $str_phisical e media ${temp_media[0]}ºC
        $str_core0 e media ${temp_media[1]}ºC
        $str_core1 e media ${temp_media[2]}ºC
        $str_core2 e media ${temp_media[3]}ºC
        $str_core3 e media ${temp_media[4]}ºC"
        echo -e "${Gre}$result${ICol}"
    fi

    #dorme por 5 minuto
    sleep 100
    sudo echo
    sleep 100
    sudo echo
    sleep 100
done