#!/bin/bash
# quote.sh - Generate a text file with contents from a randomly selected file in a directory of .qt files.
#            Used to display random quotes on a web site.
# 20110214 jah - changed /bin/sh to /bin/bash since ubuntu /bin/sh points to /bin/dash which is not compatible
# 20230108 jah - strip off any passed extensions
#              - set source and destination as variables
#              - rearrange commands to a more logical order

SRC="/root/Scripts/quotes.ic"
DST="/var/www/industrialcomplex.de/random.quote"
EMAIL="asd@asd.com"

cd $SRC

FNAME="${1%.*}"
[ "$1" != "" ] && FILES=`ls $FNAME*.qt` 
[ "$1" = "" ]  && FILES=`ls *.qt`
FILE=($FILES)
NFILES=${#FILE[*]} #count
QUOTE=`echo ${FILE[$((RANDOM%NFILES))]}`
COUNT=`cat $QUOTE | wc -l`
COUNT=`expr $COUNT - 1`
SUBJECT=`cat $QUOTE | head -1`

echo $SUBJECT
cat "$QUOTE" | tail -$COUNT > $DST

# to also send quote as message
{
echo "Subject:$SUBJECT"
echo "Content-Type: text/html; charset=ISO-8859-1"
echo '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
echo "<html>"
echo "<head>"
echo "<meta content=text/html;charset=ISO-8859-1 http-equiv=Content-Type>"
echo "</head>"
echo "<body bgcolor=#ffffff text=#000000>"
cat "$QUOTE" | tail -$COUNT
echo ""
echo "</body>"
echo "</html>"
} >mail.file
# send as a message
#cat mail.file | /usr/sbin/sendmail -ONoRecipientAction=add-to -fquotemailer -oi $EMAIL


