# acct.prg main program to generate daily and monthly formatted reports 
# sorted by project
# Updated on 8/2/88 by K. Rabito. Added sleep command before the lp command.
# Hopefully this will stop the cut off of the print that comes out.
# Variables for program. Do not remove!

PATH=$PATH:/etc:/usr/adm:/bin:/norden/accounting:/usr/bin
export PATH
FILESERVER="system5"
SYSTEM=`hostname`
LAST_DATE=`dec_date`
if [ "$SYSTEM" = "$FILESERVER" ]
	then
	SYS1="/usr/adm/tmp/network/system1"
	SYS2="/usr/adm/tmp/network/system2"
	SYS3="/usr/adm/tmp/network/system3"
	SYS4="/usr/adm/tmp/network/system4"
	SYS6="/usr/adm/tmp/network/system6"
	SYS7="/usr/adm/tmp/network/system7"
	SYS8="/usr/adm/tmp/network/system8"
	CHECK="Z"
fi

# Tests for certain files,then removes them.

if test -s /usr/adm/daily.tot -eq0
	then rm /usr/adm/daily.tot
fi

if test -s /usr/adm/tmp/*store -eq0
	then rm /usr/adm/tmp/*store
fi


# Test to see if anyone logged in during the day

if test -s /norden/accounting/chrgstore -eq0
	then sort /norden/accounting/chrgstore > /usr/adm/tmp/chargestore
	 cat /usr/adm/tmp/chargestore | xargs -n12 >> /usr/adm/tmp/chrgstore
	 last -100 | grep "$LAST_DATE" | sed 's/[():]/ /g' | sed '/^.*still logged in.*$/d' | sort |
	 xargs -n12 /usr/adm/rates
	 # data is now in yest1 for possible editing before ac.awk assigns costs
	 awk -f /usr/adm/ac.awk /usr/adm/yest1 |
	 tee -a /usr/adm/daily.tot >> /usr/adm/yest2
	 rm /norden/accounting/chrgstore
	 rm /usr/adm/yest1
         else echo "`date` WARNING" >> /usr/adm/acct.error
	 echo "Chrgstore file is empty or missing.  Possibly no logins today." >> /usr/adm/acct.error
	 echo "" >> /usr/adm/acct.error
fi

# On Friday the report will be generated on the fileserver from all the other systems.

day=`date | cut -c1-3`
if [ $day = "Fri" ]
then 
     # The fileserver will wait here until all the reports are in from all the satillite stations
     
      if [ "$SYSTEM" = "$FILESERVER" ]
        then if test -s /usr/adm/weekly.report -eq0
     	        then rm /usr/adm/weekly.report
             fi
	     if test -s /usr/adm/tmp/rep.* -eq0
	        then rm /usr/adm/tmp/rep.*
	     fi
        until test "$CHECK" = "OK"
        do if test -s "$SYS1" -a -s "$SYS2" -a -s "$SYS3" -a -s "$SYS4" -a -s "$SYS6" -a -s "$SYS7" -a -s "$SYS8"
           then CHECK="OK"
	     cat /usr/adm/tmp/network/system* >> /usr/adm/yest2
     	     sort -u /usr/adm/yest2 > /usr/adm/tmp/yest2
	     TOT=`cat /usr/adm/tmp/yest2 | xargs -n9 | awk -f /usr/adm/total_hrs.awk`
             sed -e "s/^.*$/& $TOT/" /usr/adm/tmp/yest2 > /usr/adm/tmp/yest3
             cat /usr/adm/tmp/yest3 | xargs -n10 /usr/adm/actotal.sh
             echo "report finished"
             cat /usr/adm/tmp/rep.* >> /usr/adm/weekly.report
             rm /usr/adm/tmp/yest2 /usr/adm/yest2 /usr/adm/tmp/network/system*
	     sleep 30
     	     pr -h "CAE WEEKLY Backup      " /usr/adm/weekly.report | lp -dlaser -on
           fi
        done
	# If the host is not the fileserver,then copy /usr/adm/yest2 on the host to the fileserver.
        else rcp -r /usr/adm/yest2 $FILESERVER:/usr/adm/tmp/network/`hostname`
	     rm /usr/adm/yest2
     fi
fi
# End of program
