# use module
use XML::Simple;
use Data::Dumper;
use Encoding::FixLatin qw(fix_latin);

# create object
$xml = new XML::Simple ( KeyAttr=>'id' );

# read XML file
$data = $xml->XMLin("ddcE.xml");

# print output
print Dumper($data);
