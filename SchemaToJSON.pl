# Convert an EMu Schema to a D3 bundlemap-ready JSON file

# to run this:
# 0: put this pl file in a folder with schema/e & point the line below ("require 'FMNH_EDIT.pl'") to the schema you want to convert
### - also need to add this "package" line to the head of the schema.pl file: package FMNH_EDIT;
# 2: In terminal/cmd, cd to the folder with this pl file
# 3: [install perl, &] type: perl SchemaToJSON_ALT.pl
### - don't mind the "Egads"
# 4: go check your json output

# made with wisdom from:
### http://stackoverflow.com/questions/15678358/accessing-hash-of-hashes-defined-in-another-file-in-perl-and-printing-it
### http://www.cs.mcgill.ca/~abatko/computers/programming/perl/howto/hash
#   -> "Access and print a reference to a hash of hashes of hashes"
#       [...of hashes--sheesh]

# use strict;
use warnings;

# change this to the schema file you want to convert:
require 'FMNH_EDIT.pl';

# This is where your json file comes out; change it to somewhere sensible/local
my $output = "/Volumes/Toast/DAMS/DataViz/EMuViz/Schemas/originals/output/FMSchema_PL.json";

 open( FH, ">$output" ) || die "Couldn't open $output $!";
    print FH "[\n";

# To grab the module name...
for my $k1 (sort keys %FMNH_EDIT::Schema){

    print FH "{'name':'$k1.irn','size':5,'imports':[]},\n";

    for my $k2 (sort keys %{$FMNH_EDIT::Schema{$k1}}){
        
        # To grab the column name & print "module.column"
        for my $k3 (sort keys %{$FMNH_EDIT::Schema{$k1}->{ $k2 }}){
            # while( my ($k3, $v3) = each %{$FMNH_EDIT::Schema{$k1}->{ $k2 }}){

            if ($k3 eq "irn") {
                print "EGADS ";
            } else {
            print FH "{'name':'$k1.$k3','size':5,'imports':[";
                
            # To grab the linked module.irn
            while( my ($k4, $v4) = each %{$FMNH_EDIT::Schema{$k1}->{ $k2 }->{$k3}}){
                if ($k4 eq "RefTable") {
                # my $v4 = $FMNH_EDIT::Schema{$k1}->{ $k2 }->{ $k3 };
                    print FH "'$v4.irn'";
                } else {
                    print FH "";
                }
            }
            print FH "]},\n";
            }
        }


    }
}
# For FMNH, NEED TO ADD row for "ECOLLECTIONDESCRIPTIONS.irn", "EPROPAGATION.irn",
print FH "{'name':'ecollectiondescriptions.irn','size':5,'imports':[]},\n";
print FH "{'name':'epropagation.irn','size':5,'imports':[]}\n";

print FH "]";

close FH;
