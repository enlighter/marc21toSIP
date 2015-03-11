#!/usr/local/bin/perl -w

#To Build:
#> mkdir import
#> ./build.pl collection.xml


$/ = "</dublin_core>\n"; # record separator

$what = 100001; # dummy id for when there’s no file

while (<>) 
{
	# discard the top and bottom tags
	s/<collection>\n//;
	s/<\/collection>\n//;
	# extract the file path from the identifier
	# use the file name as an id
	# note that identifier element is discarded!
	if (s!<dcvalue element="identifier" qualifier="uri" language="en">http://.*/theses/(.*?)/([^/]+).pdf<\/dcvalue>\n!!s) 
	{
		$path = $1;
		$id = $2;
	} 
	else 
	{
		$path = '';
		$id = $what++;
	}

	# let the operator know where we’re up to
	print "$path/$id\n";
	# create the item directory
	mkdir "import/$id", 0755;
	# create the dublin_core.xml file
	open DC, ">import/$id/dublin_core.xml" or die "Cannot open dublin core for $id, $!\n";

	print DC $_;
	close DC;
	
		# ... create the contents file ...
		open OUT, ">import/$id/contents"
		or die "Cannot open contents for $id, $!\n";
		print OUT "";
		close OUT;
		# ... and create a symbolic link to the actual file

		#symlink "/scratch/dspace/import/theses/$path/$id.pdf", "import/$id/$id.pdf";
	
}
