
# rename all *.txt files to *.csv files
#  	dir /b /a-d | perl -wne "chomp; $a=$_; s/^(.*)\.txt/$1.csv/; rename($a,$_);"
# use the -l option to 'auto-chomp'
#  	dir /b /a-d | perl -wlne "$a=$_; s/^(.*)\.txt/$1.csv/; rename($a,$_);"

# or better yet:
#	dir /b /a-d | perl -wlne"/(.*)\.txt$/&&rename($1.'.txt',$1.'.csv');"
#	dir /b /a-d | perl -wlne"/(.*)\.txt$/&&rename($_,$1.'.csv');"
# and back
#	dir /b /a-d | perl -wlne"/(.*)\.csv$/&&rename(\"$1.csv\",\"$1.txt\");"
#	dir /b /a-d | perl -wlne"/(.*)\.csv$/&&rename($_,$1.'.txt');"