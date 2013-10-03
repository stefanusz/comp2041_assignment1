#!/usr/bin/perl -w

# written by andrewt@cse.unsw.edu.au September 2013
# as a starting point for COMP2041/9041 assignment 
# http://cgi.cse.unsw.edu.au/~cs2041/13s2/assignments/perl2python

while ($line = <>) {

	if ($line =~ /^#!/ && $. == 1) {
	


		# translate #! line 
		
		print "#!/usr/bin/python2.7 -u\n";
	} elsif ($. == 2){

		$GLOBALSECOND = "\n";
		 if ($line =~ /^\s*$/) {
		 	print "$GLOBALSECOND";
		 }else{
		 	
		 	print "$GLOBALSECOND";
		 	
		 	print "$line";
		 }
	}elsif ($line =~ /^\s*#/ || $line =~ /^\s*$/) {
	
		# Blank & comment lines can be passed unchanged
		
		print $line;
	} elsif ($line =~ /^\s*print\s*"(.*)\\n"[\s;]*$/) {
		# Python's print adds a new-line character by default
		# so we need to delete it from the Perl print statement
		# delete the dollar sign infront of variable after print statement.
		# remove double quote from enclosing the variable. 
		# at the same time by not using $1, and change it to s to keep indentation.

		$line =~ s/"|\\n|\$|;//g;
		print "$line";
		
		
	} elsif ($line =~ /\$/){

		#to remove all variable with $ infront of them and remove 
		#the semi colon after that.
		$line =~ s/\$//g;
		$line =~ s/;//g;

		#to remove things with a comma and semi collon inside it 
		#and anchor it at the last part of the sentence to match new line in a double colon
			if($line =~ /, ".*"/){
				$line =~ s/, "\\n"$//;
			}  

			if ($line =~ /if/ || $line =~ /while/){
				

				$line =~ s/(\)|\()//g;
				$line =~ s/{|\}|\{|}//g;
				$line =~ s/ \n/:\n/;

				if($line =~ /eq/){
					$line =~ s/eq/==/g;
				}

			}

		print $line;

	} elsif ($line =~ /^if/ || $line =~ /^while/){
		
				$line =~ s/(\)|\()//g;
				$line =~ s/{|\}|\{|}//g;
				$line =~ s/ \n/:\n/;

				if($line =~ /eq/){
					$line =~ s/eq/==/g;
				}
				print $line;

	} elsif ($line =~ /<STDIN>/){

		print "LINE COME THROUGH\n";

	}elsif($line =~ /}/){
			$line =~ s/}//g;
	}else {
	
		# Lines we can't translate are turned into comments
		
		print "#$line\n";
	}
}