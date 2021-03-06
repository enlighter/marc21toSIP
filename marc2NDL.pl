#!/usr/local/bin/perl -w

use MARC::Crosswalk::DublinCore;
use MARC::File::USMARC;

$/ = chr(29); # MARC record separator

print qq|<collection>\n|;
while (my $blob = <>) 
{ # suck in one MARC record at a time
	print qq|<dublin_core schema="dc">\n|;

	#set publisher as Springer
	printf qq| <dcvalue element="%s"|, 'publisher';
	printf qq| qualifier="%s"|, 'none';
	printf qq| language="en">%s</dcvalue>\n|, 'Springer';

	# convert the MARC to DC
	my $marc = MARC::Record->new_from_usmarc( $blob );
	my $crosswalk = MARC::Crosswalk::DublinCore->new( qualified => 1 );
	my $dc = $crosswalk->as_dublincore( $marc );

	## This is the code snippet for retrieving table fo contents. Put them properly in the actual code#######
	## TOC values will go into 'dc.description.tableofcontents' fields ######################################
    my @toc = $marc->field('505');
    foreach my $toc (@toc)
    {
        if (defined($toc->subfield('a')))
            {
                printf qq| <dcvalue element="%s"|, 'description';
                printf qq| qualifier="%s"|, 'tableofcontents';
                printf qq| language="en">%s</dcvalue>\n|, $toc->subfield('a');
            }
    }
    ###################### TOC code snippet ###################

	# output the DC as XML
	for( $dc->elements ) 
	{
		my $element = $_->name;
		my $qualifier = $_->qualifier;
		my $scheme = $_->scheme;
		my $content = $_->content;

		#convert all strings except content to lower case
		$element = lc $element;
		$qualifier = lc $qualifier;
		$scheme = lc $scheme;

		#remove date entry from records
		next if $element eq 'date';

		# escape reserved characters
		$content =~ s/&/&amp;/gs;
		$content =~ s/</&lt;/gs;
		$content =~ s/>/&gt;/gs;

		# munge attributes for DSpace compatibility
		if( not ($scheme))		#check if scheme is empty
		{
			$scheme = 'none';	#default qualifier 'none'
		}

		if( not ($qualifier))	#check if qualifier is empty
		{
			$qualifier = $scheme;	#if empty reassign scheme to qualifier
		}
		$scheme = '';		# delete all scheme

		if ($element eq 'creator') 
		{
			$element = 'contributor';
			$qualifier = 'author';
		}
		if ($element eq 'format') 
		{
			$element = 'description';
			$qualifier = 'none';
		}
		if ($element eq 'type') 
		{
			#$element = 'description';
			$qualifier = 'none';
		}
		if ($element eq 'subject' && $qualifier eq 'lcsh')
		{
			$qualifier = 'none';
		}
		if ($element eq 'language') 
		{
			if ($qualifier eq 'iso 639-2') 
			{
				$qualifier = 'iso';
				#$scheme = '';
			} 
			else 
			{
				$element = 'description';
				$qualifier = 'none';
			}
		}
		if ($qualifier eq 'ispartof') 
		{
			$qualifier = 'ispartofseries';
		}

		printf qq| <dcvalue element="%s"|, $element;
		printf qq| qualifier="%s"|, $qualifier if $qualifier;
		printf qq| scheme="%s"|, $scheme if $scheme;
		printf qq| language="en">%s</dcvalue>\n|, $content;
	}
	print qq|</dublin_core>\n|;
}
print qq|</collection>\n|;
exit; 
