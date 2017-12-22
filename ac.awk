#	ac.awk routine formats daily records,whitespace is the field separator
#	       reduce fields, calculate cost per login
#	updated 8/17/88 for adding project name to report.  KRR
#
# input:
#                        last login           logout  total   
#	user   tty       day mon dathr min -  hr min  hr  min  project number       project name   rate
#	guest1 pty/ttyp1 Fri Aug 28 09 46  -  17 14   07  27   XXXX-XX-XXXX-XXXXX   wiz computer   1.00
#       $1     $2        $3  $4  $5 $6 $7 $8  $9 $10  $11 $12       $13                  $14       $15
#
# output:
#	user   day mon dat time  project number      project name  rate  charge
#       guest1 Fri Aug 28  7.45  XXXX-XX-XXXX-XXXXX  wiz computer  1.00  7.45
#
{
	if ( NR != 1 && a != $1)
	# print out the cululative data for this user when different user pending
	{
	        printf "%10s %3s %3s %2d %5.2f %s %s %5.2f %5.2f\n",a,b,c,d,hr_dec,\
                        e,g,f,cost
		#re-initialize the time variables , new user pending
		tot_hr = 0
		tot_min = 0
	}
	else
	{
		if ( tot_min >= 60 )
		{
			tot_min -= 60
			tot_hr += 1
		}
	}
	a = $1
	b = $3
	c = $4
	d = $5
	e = $13 
	f = $15 
	g = $14 
	tot_hr += $11
	tot_min += $12
	hr_dec = tot_hr+tot_min/60.0
	cost = hr_dec * f 
}
END{
	# this is needed to pick up final output since EOF is unknown
        printf "%10s %3s %3s %2d %5.2f %s %s %5.2f %5.2f\n",a,b,c,d,hr_dec,\
                e,g,f,cost
}
