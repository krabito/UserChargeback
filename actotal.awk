# actotal.awk program called from actotal.sh and is used to
# generate monthly report by project
# Updated 8/19/88. Added project name and percent usage. K. Rabito
#
BEGIN {
	printf "\n"
	printf "____________________________________________ \n"
}
{
	if ( NR == 1)
	{
	printf "********* project number: %10s **********\n",$6
	printf "\n\n"
	printf "      user     login-date hours  rate  cost  project name\n\n"
	}
        printf "%10s %6s %4s %2d %5.2f %5.2f %5.2f %13s\n",$1,$2,$3,$4,$5,$8,$9,$7
	usetot = usetot + $5
	use = usetot / $10
	percent = use * 100
	chgtot = chgtot + $9
}
END {
	printf "\n\n"
	printf "total usage = %6.2f hours\n",usetot
	printf "total cost = %6.2f dollars\n" ,chgtot
	printf "usage = %6.2f percent\n",percent
} 
