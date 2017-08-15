#!/usr/bin/env python
# coding=utf-8
"""
#
# <bitbar.title>Etherium Ticker ($1USD)</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>impshum</bitbar.author>
# <bitbar.author.github>impshum</bitbar.author.github>
# <bitbar.desc>
#   Displays current Ethereum price for $1 from Coinmarketcap
# </bitbar.desc>
# <bitbar.image>https://i.imgur.com/Gkj3RHB.jpg</bitbar.image>
#
# by impshum
"""

import json
from urllib import urlopen

URL = urlopen('https://coinmarketcap-nexuist.rhcloud.com/api/btc').read()
RESULT = json.loads(URL)


def flow():
    """
    Show output and data-uri image
    """
    if RESULT['change'] > '0':
        print(
            ' B%.2f | image=iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAB'
            'mJLR0QAyQACAALwzISXAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4AQHA'
            'CkSBTjB+AAAALNJREFUOMvVk70NAjEMhb87WYiGBZAQU7ABNSVSWpZgEEagsJDoK'
            'BELUCEKFuBuCKTw0xyQC0lICe5i+/k9/wT+3opUUJQhcAUqa8I5ZQT4tANwioGTC'
            'kQZA9vmOQE2oUJFhL0DXBz33RpKUfCLfLTQJMx9IlEWuQr6QB3prGtNS1lwiMvEY'
            'o7ekNsKRBkB+y+rH1hDFVOwy7ids+gbVzrsM6CXeYDTF85xroB1ZoHb73ymB5RhJ'
            'kpZTihGAAAAAElFTkSuQmCC color=#000000' %
            float(RESULT['price']['usd']))
    else:
        print(
            ' B%.2f | image=iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAAB'
            'mJLR0QABACnAADQ9FZaAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4AQHA'
            'CQ1FZwK3gAAAMRJREFUOMvNkjEKAjEQRZ+jKNjYKh5AbzCdjVcQj+BFPIKlp7EMe'
            'AJrUbASQVCEr80uG9cNbqe/Cgn/5WUI/DqNfBHM+kCzbs+lPUAr2pwBq5qABbB+M'
            '8gszkDvS/kOdAG5VBgEM4ApsP0CGLukjxlEoA0wSZR3Lo0qhxhZDIBDAmDA0wsBL'
            'D51CZeOwLKivHbprZx6AkAHuEXbD5fawYwywMqAzOKeDTTPvKqcTGZBMLsGs0utn'
            '5gADYEHcKp9e9ni//MCDtNCE3qjsIwAAAAASUVORK5CYII= color=#000000' %
            float(RESULT['price']['usd']))


flow()
