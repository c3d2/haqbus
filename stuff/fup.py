#!/usr/bin/env python

import random



def blah(numnew) :
	a = [0 for i in range(32)]
	for i in range(numnew):
		slt = random.randint(0,31)
		a[slt] = a[slt] + 1
	if 1 in a:
		print a
	else :
		print "fail!"





