#! /bin/bash

#Check report.txt file for the MoM records

URL='https://inductions.delta.nitt.edu/sysad-task-1-attendance.log'
wget -N "$URL"

DATE1=$1
DATE2=$2

awk '{ a[$3]++ } END { for (b in a) { print substr(b, 1, length(b)-1) } }' sysad-task-1-attendance.log | sort > dates.txt

>report.txt
>list.txt
>genmom.txt
for i in {01..10}
do
	sed 's/\://g' sysad-task-1-attendance.log | awk '{printf("%-15s%10s%10s\n"), $1, substr($3, 1, length($3)-1), $4}' | grep -E "sysAd_${i}|webDev_${i}|appDev_${i}" >>list.txt
done

while read date
do
	grep $date list.txt | awk -v max=0 '{if($3>max){max=$3; want=$1}}END{print want,$2}' >>genmom.txt
done <dates.txt

while read line
do
	IFS=' '
	read -ra data <<< "$line"
	if [ -z "${data[0]}" ]
	then
		true
	else
		if [[ ${data[1]//-} -ge ${DATE1//-} && ${data[1]//-} -le ${DATE2//-} ]]
		then
			time=$(cat "/home/${data[0]}/${data[1]}_mom.txt")
			echo "${data[0]} ${data[1]} ${time}" >>report.txt
		fi
	fi
done <genmom.txt

