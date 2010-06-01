#!/usr/bin/env python

import bloopsa
import sys
import time

def usage():
    print ("usage: bloopsawhat notes\n"
           " (ex.: bloopsawhat \"a b c d e f g + a b c\"\n")

def main(args=None):
    if args is None:
        args = sys.argv[1:]
    if args:
        B = bloopsa.Bloops()
        P = bloopsa.Phone()
        B.tune(P, args[0])
        B.play()
        while not B.is_done():
            time.sleep(1)
        return 0
    else:
        usage()
        return 1

if __name__ == '__main__':
    sys.exit(main())
