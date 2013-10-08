#!/usr/bin/perl -w

# written by andrewt@cse.unsw.edu.au September 2013
# as a starting point for COMP2041/9041 assignment 
# http://cgi.cse.unsw.edu.au/~cs2041/13s2/assignments/perl2python
# edited by Stefanus Husin z3442577

use Data::Dumper;

@script = <>; 
	
foreach $line (0..$#script){


	if ($script[$line] =~ /<STDIN>|\@ARGV|ARGV/){
		# to cater for the import sys when it encounter STDIN or ARGV
		$IMPORT{'sys'}++;
		
	}
	
	if ($script[$line] =~ /^#!\/usr\/bin/ ) {
		#&& $. == 0 -> just for a note. 
		
		# translate #! line 
		
		$script[$line]= "#!/usr/bin/python2.7 -u\n";

	} elsif ($script[$line] =~ /^\s*#/ || $script[$line] =~ /^\s*$/) {
		
		# Blank & comment lines can be passed unchanged
		$script[$line]= "$script[$line]";
		
	} elsif ($script[$line] =~ /^\s*print\s*/) {
		# ORGINAL ($script[$line] =~ /^\s*print\s*"(.*)\\n"[\s;]*$/)
		# Python's print adds a new-line character by default
		# so we need to delete it from the Perl print statement
		# delete the dollar sign infront of variable after print statement.
		# remove double quote from enclosing the variable. 
		# at the same time by not using $1, and change it to s to keep indentation.

		#IF there is $variable then remove the " else do not remove it. 
		
		if($script[$line] =~ /\$/){

			$script[$line] =~ s/\$|"//g;

		} elsif ($script[$line] =~ /join/){

			#to put the join term in a variable and put it infront. 
			$temp = $script[$line];
			$temp =~ s/print join\(//g;
			$temp =~ s/,.*//g;
			$temp =~ s/\n//g;

			#to choose either its ARGV or non ARGV.
			if($script[$line] =~ /\@ARGV/){
				
				$script[$line] ="$temp.join(sys.argv[1:])";
				
			}else{
				$script[$line] =~ /\((.*),(.*)\)/;
				$var = $2;
				$var =~ s/ //g;
				$script[$line] = "$temp.join($var)";
				
			}

		}

		$script[$line] =~ s/\\n|;|,//g;
		$script[$line]= "$script[$line]";
		
		
	} elsif ($script[$line] =~ /\$/){

		#to remove all variable with $ infront of them and remove 
		#the semi colon after that.
		$script[$line] =~ s/\$//g;
		$script[$line] =~ s/;//g;
		
		#print "THE LINE IS $script[$line]";
		#to remove things with a comma and semi collon inside it 
		#and anchor it at the last part of the sentence to match new line in a double colon
			if ($script[$line] =~ /, ".*"/ | $script[$line] =~ /,/){

				$script[$line] =~ s/, "\\n"$//;

			} elsif ($script[$line] =~ /if/ || $script[$line] =~ /while/){
				

				$script[$line] =~ s/(\)|\()|//g;
				$script[$line] =~ s/{|\}|\{|}//g;
				$script[$line] =~ s/ \n/:\n/;

				
				#IF BELOW TO CHANGE EQ to == 
				if($script[$line] =~ /eq/){

					$script[$line] =~ s/eq/==/g;

				} elsif ($script[$line] =~ /\s.*\s=\s<>/){
					$IMPORT{'fileinput, re'}++;
					#To account for while ($line = <>) 
					
					$script[$line] =~ /\s(\w*)\s(\w*)/;
					$word1 = $1;

					$script[$line] =~ s/while $word1 = <>/for $word1 in fileinput.input()/g;
				}


			} elsif ($script[$line] =~ /<STDIN>/){

				$IMPORT{'sys'}++;
				
				$script[$line] =~ s/<STDIN>/sys.stdin.readline()/g;
			} elsif ($script[$line] =~ /chomp/){

				#CHANGE THE CHOMP TO line.rstrip.
				$script[$line] =~ s/chomp //g;
				$script[$line] =~ s/\n/ = line.rstrip()\n/;

			} elsif ($script[$line] =~ /foreach/){

					$script[$line] =~ s/foreach/for/g;

					if($script[$line] =~ /\@ARGV/){
						$script[$line] =~ s/\@ARGV/in sys.argv[1:]/g;
					}
					
					#if condition to contain for xrange and grep the condition.
					$script[$line] =~ /(\(.*\))/;
					$bracketVar = $1;
					print "THE VAR IS $bracketVar\n";
				#to remove all the opening and closing braces on the same line. 
				$script[$line] =~ s/(\)|\()//g;
				$script[$line] =~ s/{|\}|\{//g;
				$script[$line] =~ s/ \n/:\n/;

			} elsif ($script[$line] =~ /\ss\/.*\/\//){

				$script[$line] =~ /((.*)\s=~\ss\/(.*)\/\/)/;
				$varName = $2;
				$temp = $3;
				$varName =~ s/\s//g;
				
				
				$script[$line] =~ s/=~\ss\/.*\/\/g/= re.sub(r'$temp', '', $varName)/g;

			}
		
		$script[$line]= "$script[$line]";

	} elsif ($script[$line] =~ /^\s*if/ || $script[$line] =~ /^\s*while/){

				# to eliminate braces around the if and while loop.

		
				$script[$line] =~ s/(\)|\()//g;
				$script[$line] =~ s/{|\}|\{|}//g;
				$script[$line] =~ s/ \n/:\n/;

				#change eq to == when encounter it.
				if($script[$line] =~ /eq/){
					$script[$line] =~ s/eq/==/g;
				}

				$script[$line]= "$script[$line]";

	} elsif ($script[$line] =~ /last;/){
		
		#change last to break.
		$script[$line] =~ s/last;/break/;
		$script[$line]= "$script[$line]";

	} elsif ($script[$line] =~ /elsif/){
		$script[$line] =~ s/elsif/elif/;

	} elsif($script[$line] =~ /}/){
			#to remove a single closing brace. 
			$script[$line] =~ s/.*}\n//g;

			if($script[$line] =~ /}\s*.*\s*{/){
			#to remove a single closing brace. 
			$script[$line] =~ s/{|\}|\{|}//g;
			$script[$line] =~ s/ $/:/g;

			} 

	} else {
	
		# Lines we can't translate are turned into comments
		
		$script[$line]= "#$script[$line]";
	}
 
}

foreach $key (keys %IMPORT){
	
	#for every import we have, insert it in the second line
    splice @script, 1, 0, "import $key\n";                 
}

foreach $line2 (@script){
    print "$line2";    #print all the lines
}


