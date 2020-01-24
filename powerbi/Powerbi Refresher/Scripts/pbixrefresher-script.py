#!c:\python\python37\python.exe
# EASY-INSTALL-ENTRY-SCRIPT: 'pbixrefresher==0.1.6','console_scripts','pbixrefresher'
__requires__ = 'pbixrefresher==0.1.6'
import re
import sys
from pkg_resources import load_entry_point

if __name__ == '__main__':
    sys.argv[0] = re.sub(r'(-script\.pyw?|\.exe)?$', '', sys.argv[0])
    sys.exit(
        load_entry_point('pbixrefresher==0.1.6', 'console_scripts', 'pbixrefresher')()
    )
