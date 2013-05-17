#!/usr/bin/perl -w

# The source code files, properties files, other text files, and other files
# in this package (the Software) are
#
# Copyright (c) by the Regents of the University of Michigan
#
# and were written or modified from other sources by the development team
# of the National Center for Integrative Biomedical Informatics, University
# of Michigan.
#
# Development of the software is supported by National Institutes of Health,
# Grant U54 DA021519
#
# see www.ncibi.org for details.
#
# By using, modifying, or using derivative products of the software, you are
# agreeing to these Terms of Use:
# (see http://portal.ncibi.org/gateway/pdf/Terms%20of%20use-web.pdf)
#
# General Use Policy:
#
# For academic and non-profit institutions:
#   - Permission is granted to access, use and/or download the Tools for
#     internal use only
#   - Users must inform NCIBI of any derivative works of the Tools created
#     (e-mail: ncibihelp@umich.edu)
#   - Use of the Tools must be acknowledged in resulting publications
#     (see citation policy below)
#
# For commercial and for-profit institutions:
#   - Permission is granted to access, use, and/or download the Tools for
#     internal use only
#   - To create derivative works of the Tools for commercial purposes, source
#     code or access to databases may be permitted through negotiation for a
#     commercial license. Please send request through: ncibi-help@umich.edu
#
# Citation of use of this software must include reference to:
#
# National Center for Integrative Biomedical Informatics,
# University of Michigan.
#
# Disclaimer:
# THE USER AGREES THAT THE TOOLS ARE PROVIDED AS IS, WITHOUT REPRESENTATION
# OR WARRANTY BY THE UNIVERSITY OF MICHIGAN OF ANY KIND, EITHER EXPRESS OR
# IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. The Regents of the
# University of Michigan shall not be liable for any damages, including
# special, indirect, incidental or consequential damages, with respect to any
# claim arising out of, or in connection with, the use of these Tools,
# Software, or derivative products, even if it has been or is hereafter
# advised of the possibility of such damages. Nothing in this license shall
# be deemed to grant any rights of the University of Michigan except as
# expressly stated herein. The names and trademarks of the University of
# Michigan may NOT be used in advertising or publicity pertaining to your
# use of the Tools, except as expressly stated herein.

# This script gets a list of PMIDs from Pubmed, retrieves the genes tagged in the abstracts for those PMIDs
# from the NCIBI NLP web services, then gets the top 10 MeSH headings for each of those genes from
# Gene2MeSH, and finally gets the interacting genes for those genes from MiMI.

use strict;
use warnings;
use XML::XPath;
use XML::XPath::XMLParser;
use LWP::UserAgent qw($ua get);

my $ua = new LWP::UserAgent;
my %geneList = ();
my %genesMesh = ();
my %meshList = ();
my %intGenes = ();

#get PMIDs from Pubmed
my $response = 
$ua->get('http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=kretzler%20m[au]&maxdate=2009&mindate=2009');

my $pubXP = XML::XPath->new(xml => $response->content);

print "*** Tagged Sentences from NCIBI NLP Web Service for Mattias Kretzler's Publications in 2009 ***\n\n";

foreach my $pmidNode ($pubXP->find('//Id')->get_nodelist) {
	my $pmid = $pmidNode->string_value;
	
	# get tagged sentences from nlp.ncibi.org
	$response = $ua->get("http://nlp.ncibi.org/fetch?tagger=nametagger&type=gene&pmid=$pmid");
	my $nlpXP = XML::XPath->new(xml => $response->content);
	
	# print sentences 
	foreach my $sentenceNode ($nlpXP->find('//Sentence')->get_nodelist){
		print $sentenceNode->string_value . "\n";
	}
	print "____________________________________________________________________________________\n";
	foreach my $geneNode ($nlpXP->find('//Gene')->get_nodelist) {
		my $geneIDList = $geneNode->find('@id')->string_value;
		my $geneSymbol = $geneNode->string_value;
		$geneList {$geneSymbol} = $geneIDList;
	} #foreach genenode
	
} # foreach pmidnode

print "*** Tagged Genes from Pubmed Abstracts ***\n\n";

# print the unique gene symbols and gene IDs
while(my ($key, $value) = each(%geneList)){
	print $key . " => " . $value . "\n";
}

# get MeSH terms for each GeneID
while(my ($key, $value) = each(%geneList)){
	my @ids = split(/,/,$value);
	
	# get the top 10 Gene2MeSH results for each GeneID and interacting genes from MiMI
	foreach (@ids) {
	
		# Gene2MeSH results
		$response = $ua->get("http://gene2mesh.ncibi.org/fetch?geneid=$_&limit=10");
		my $g2mXP = XML::XPath->new(xml => $response->content);		
		my @g2mNodeList = $g2mXP->find('//Descriptor/Name')->get_nodelist;
		
		# add the MeSH terms to the hash holding each gene name
		foreach my $g2mNode (@g2mNodeList) {
			if ($g2mNode) {
				my $meshDesc = $g2mNode->string_value;
				$genesMesh {$key} .= $meshDesc . ' | ';
				if (exists $meshList{$meshDesc}) {
					$meshList{$meshDesc}++;
				}
				else {
					$meshList{$meshDesc} = 1;	
				}
			}
		}#foreach $g2mNode		
		
		# MiMI Results
		$response = $ua->get("http://mimi.ncibi.org/MimiWeb/fetch.jsp?geneid=$_&type=interactions");
		my $mimiXP = XML::XPath->new(xml => $response->content);
		my $mimiNodeSet = $mimiXP->find('//InteractingGene');
		
		# add the interacting genes 
		foreach my $mimiNode ($mimiNodeSet->get_nodelist) {
			my $geneIDNode =  $mimiXP->find('./GeneID', $mimiNode);
			my $geneSymbolNode =  $mimiXP->find('./GeneSymbol', $mimiNode);
			$intGenes {$key} .= $geneSymbolNode->string_value . " (" . $geneIDNode->string_value . ")" . ',';
		}#foreach miminode
	}#foreach ids
}#while geneList


print "____________________________________________________________________________________\n";

# print sorted MeSH descriptors and counts

print "*** Top MeSH terms for Genes Tagged in Abstracts ***\n\n";

sub hashValueAscendingNum {
   $meshList{$b} <=> $meshList{$a};
}

foreach my $key (sort hashValueAscendingNum (keys(%meshList))) {
	if ($meshList{$key} > 2) {
   		print "$key => $meshList{$key}\n";
	}
}

print "____________________________________________________________________________________\n";

print "*** Interacting Genes from MiMI ***\n\n";

# print the gene symbols and the interacting genes
while(my ($key, $value) = each(%intGenes)){
	print $key . 
	"\n_________________________________________________________________\n" . 
	$value . "\n\n";
}








