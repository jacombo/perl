#!/usr/bin/perl

use Getopt::Long;
use utf8;
use Encode qw( decode );
binmode STDOUT, ":encoding(UTF-8)";
use LWP::Simple;                # From CPAN
use JSON qw( decode_json );     # From CPAN
use Data::Dumper;               # Perl core module
binmode(STDOUT, ":utf8");



my $Obec,$PSC, $Ulice;
GetOptions ("Obec=s" => \$Obec,    
              "PSC=i"   => \$PSC,      
              "Ulice=s"  => \$Ulice,
              "Fajl=s" => \$Fajl)   
              
or die("Parametry -Obec -PSC -Ulice -Fajl\n");

if ($Obec && $PSC) {
    $url = 'https://dip.cezdistribuce.cz/irj/portal/anonymous/rest-api?path=/vyhledaniOdstavek/nactiOdstavky&mesto='.$Obec.'&psc='.$PSC.'&ulice=';

    $Obec = decode('iso-8859-2', $Obec);
    $Ulice = decode('iso-8859-2', $Ulice);



	my $json = get( $url );
	my $decoded_json = decode_json($json);
	
    if ($Fajl) {
		open FILE , ">$Fajl";
			print Dumper %decoded_json;
		close FILE;
    } else {
		
		foreach $item ($decoded_json->{'data'}){
				foreach $item2 (@{$item}) {	   
					print "********************\n";
					print 'dateFormatted: '.$item2->{'dateFormatted'}."\n";
					print 'timeFormatted: '.$item2->{'timeFormatted'}."\n";
					foreach $item3 (@{$item2->{'parts'}}) {	   
						print 'cityPart: '.$item3->{'cityPart'}."\n";
							foreach $item4 (@{$item3->{'streets'}}) {	   
								print  'streetName: '.$item4->{'streetName'}."\n";
								foreach $item5 (@{$item4->{'streetNumbers'}}) {	   
									print 'buildingId: '.$item5->{'buildingId'}."\n";
									print 'streetId: '.$item5->{'streetId'}."\n";
									print 'parcelaId: '.$item5->{'parcelaId'}."\n";
								}
							}

					}
				}
		}
    }

} else {
    die("Chyba.. Parametry maji byt: -Obec -PSC -Ulice -Fajl\n");
    print $Obec."\n";
    print $Ulice."\n";
    print $Fajl."\n";
}
