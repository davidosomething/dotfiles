#!/usr/bin/env python
import sys, shutil, os.path
if len(sys.argv) != 3:
    sys.stderr.write('%(prog)s will copy all files in an iTunes playlist to a specific directory.\n\nUsage: %(prog)s <iTunes-exported-playlist> <destination-folter>\n\n' % {'prog': sys.argv[0]})
    sys.exit(1)
exported, dest = sys.argv[1:]
dest = unicode(dest, 'utf8')
lines = unicode(open(exported).read(), 'utf16').split('\r')[1:]
files = ['/Volumes/' + line.split('\t')[-1].replace(':', '/') for line in lines]
for file in files:
    if os.path.exists(file) and os.path.isfile(file):
        print 'Copying %s...' % os.path.basename(file)
        shutil.copy(file, dest)
print 'Done.'
