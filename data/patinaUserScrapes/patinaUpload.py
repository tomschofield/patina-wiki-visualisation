#!/usr/bin/env python

import wikitools
import poster

wiki = wikitools.wiki.Wiki("http://wiki.patina.ecs.soton.ac.uk/api.php")
wiki.login(username="TomS", password="sxnu27")

screenshotPage = wikitools.wikifile.File(wiki=wiki, title="TestMonkey.png")

screenshotPage.upload(fileobj=open("/Users/localadmin/Documents/Processing/patina_v2/patinaUserScrapes/monkey2.png", "rb"), ignorewarnings=True)