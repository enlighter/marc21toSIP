# use module
use XML::Simple;
use Data::Dumper;

# create object
$xml = new XML::Simple;

# read XML file
$data = $xml->XMLin("ddcE.xml");

# print output
print Dumper($data->{id});