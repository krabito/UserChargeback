# Total_hrs.awk totals all the hours spend on the system(s) and
# is used for calculating percent usage on the system(s).
#
#

BEGIN{ tot = 0;
     }
{
	time = $5;
	tot += time;
}
END{ 
	printf(" %2.2f\n",tot); 
   }
