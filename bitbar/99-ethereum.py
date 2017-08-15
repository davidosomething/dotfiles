#!/usr/bin/env python
# coding=utf-8
"""
#
# <bitbar.title>Etherium Ticker ($1USD)</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>impshum</bitbar.author>
# <bitbar.author.github>impshum</bitbar.author.github>
# <bitbar.desc>
#   Displays current Etherium price for $1 from Coinmarketcap
# </bitbar.desc>
# <bitbar.image>https://i.imgur.com/Gkj3RHB.jpg</bitbar.image>
#
# by impshum
"""

import json
from urllib import urlopen

URL = urlopen('https://coinmarketcap-nexuist.rhcloud.com/api/eth').read()
RESULT = json.loads(URL)


def flow():
    """
    Display movement icon and ethereum price
    """
    if RESULT['change'] > '0':
        print(
            ' 𝚵%.2f | image=iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABm'
            'JLR0QAyQACAALwzISXAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4AQHACk'
            'SBTjB+AAAALNJREFUOMvVk70NAjEMhb87WYiGBZAQU7ABNSVSWpZgEEagsJDoKBEL'
            'UCEKFuBuCKTw0xyQC0lICe5i+/k9/wT+3opUUJQhcAUqa8I5ZQT4tANwioGTCkQZA'
            '9vmOQE2oUJFhL0DXBz33RpKUfCLfLTQJMx9IlEWuQr6QB3prGtNS1lwiMvEYo7ekN'
            'sKRBkB+y+rH1hDFVOwy7ids+gbVzrsM6CXeYDTF85xroB1ZoHb73ymB5RhJkpZTih'
            'GAAAAAElFTkSuQmCC color=#000000'
            % float(RESULT['price']['usd']))
    else:
        print(
            ' 𝚵%.2f | image=iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABm'
            'JLR0QABACnAADQ9FZaAAAACXBIWXMAAAsTAAALEwEAmpwYAAAAB3RJTUUH4AQHACQ'
            '1FZwK3gAAAMRJREFUOMvNkjEKAjEQRZ+jKNjYKh5AbzCdjVcQj+BFPIKlp7EMeAJr'
            'UbASQVCEr80uG9cNbqe/Cgn/5WUI/DqNfBHM+kCzbs+lPUAr2pwBq5qABbB+M8gsz'
            'kDvS/kOdAG5VBgEM4ApsP0CGLukjxlEoA0wSZR3Lo0qhxhZDIBDAmDA0wsBLD51CZ'
            'eOwLKivHbprZx6AkAHuEXbD5fawYwywMqAzOKeDTTPvKqcTGZBMLsGs0utn5gADYE'
            'HcKp9e9ni//MCDtNCE3qjsIwAAAAASUVORK5CYII= color=#000000'
            % float(RESULT['price']['usd']))


flow()
