# actotal.sh : processes data from weeky database (yest2)
# for a single project input on command line output summary files project.month
# mail to  account manager (assumed root)
#
mon=`date | cut -c5-7`
grep $6 /usr/adm/tmp/yest3 | awk -f /usr/adm/actotal.awk  > /usr/adm/tmp/rep.$6
