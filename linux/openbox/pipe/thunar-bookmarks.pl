#!/usr/bin/env perl

# openbox pipe menu: Open GTK Bookmarks in Thunar
#
# Original by dbbolton <danielbarrettbolton@gmail.com>
# https://github.com/dbbolton/pipemenus/blob/master/thunar-bookmarks.pl
#
# Modified by davidosomething <me@davidosomething.com>
# https://github.com/davidosomething/dotfiles/blob/master/linux/openbox/pipe/thunar-bookmarks.pl
#

use strict;
use warnings;
use autodie;
use File::Basename;
use URI::Escape;

my $filemanager = "thunar";
my $bookmarks_file = "$ENV{HOME}/.gtk-bookmarks";
open(my $in, "<", "$bookmarks_file");

my @lines = <$in>;
chomp(@lines);

# Heading #############################
print "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
    . "<openbox_pipe_menu>\n"

# Places #########
    . "<item label=\"".$ENV{USER}."\">\n"
    . "<action name=\"Execute\">"
    . "<execute>" . $filemanager . " $ENV{HOME}</execute>"
    . "</action>"
    . "</item>\n"

    . "<separator />\n";

# Bookmarks ############
for (@lines) {
    my $label = uri_unescape(basename $_);
    print "<item label=\"". $label ."\">"
        . "<action name=\"Execute\">"
        . "<execute>" . $filemanager . " " . $_ . "</execute>"
        . "</action>"
        . "</item>";
}

# Trash ############
print "<separator />\n"

    . "<item label=\"Trash\">\n"
    . "<action name=\"Execute\">"
    . "<execute>" . $filemanager . " trash://</execute>"
    . "</action>"
    . "</item>\n";

print "</openbox_pipe_menu>";
close $in;

