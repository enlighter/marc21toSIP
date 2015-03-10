# use module
use XML::Simple;
use Data::Dumper;

# create object
$xml = new XML::Simple ( KeyAttr=>'id' );

# read XML file
$data = $xml->XMLin("ddcE.xml");

# print output
print Dumper($data->{'isComposedBy'}->{'node'}->{'6000'});