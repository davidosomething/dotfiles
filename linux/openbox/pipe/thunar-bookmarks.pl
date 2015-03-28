#!/usr/bin/env perl
use strict;
use warnings;
use autodie;
use File::Basename;

# dbbolton
# danielbarrettbolton@gmail.com

my $filemanager = "thunar";
my $bookmarks_file = "$ENV{HOME}/.gtk-bookmarks";
open(my $in, "<", "$bookmarks_file");

my @lines = <$in>;
chomp(@lines);

# Heading #############################
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    . "<openbox_pipe_menu>\n"

# Default bookmarks in thunar #########
    . "<item label=\"".$ENV{USER}."\">\n"
    . " <action name=\"Execute\">\n"
    . "  <execute>\n"
    . "   ".$filemanager." $ENV{HOME} \n"
    . "  </execute>\n"
    . " </action>\n"
    . "</item>\n"

    . "<item label=\"Trash\">\n"
    . " <action name=\"Execute\">\n"
    . "  <execute>\n"
    . "   ".$filemanager." trash:// \n"
    . "  </execute>\n"
    . " </action>\n"
    . "</item>\n"

    . "<item label=\"Desktop\">\n"
    . " <action name=\"Execute\">\n"
    . "  <execute>\n"
    . "   ".$filemanager." /home/$ENV{USER}/Desktop \n"
    . "  </execute>\n"
    . " </action>\n"
    . "</item>\n"

    . "<item label=\"File System\">\n"
    . " <action name=\"Execute\">\n"
    . "  <execute>\n"
    . "   ".$filemanager." / \n"
    . "  </execute>\n"
    . " </action>\n"
    . "</item>\n"

    . "<separator />\n";

# User-specified bookmarks ############
for (@lines) {
    my $label = basename $_;
    
    print "<item label=\"".$label."\">\n"
        . " <action name=\"Execute\">\n"
        . "  <execute>\n"
        . "   ".$filemanager." ".$_."\n"
        . "  </execute>\n"
        . " </action>\n"
        . "</item>\n";
}
print "</openbox_pipe_menu>\n";
close $in;

