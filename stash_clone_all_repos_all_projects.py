#!/usr/bin/env python

import stashy
from pprint import pprint
import argparse
from os import environ as env
import sys
import git
import os
import shutil
try:
    import json
except ImportError:
    import simplejson as json

if "STASH_ENDPOINT" in env:
    pass
else:
    print "Must export STASH_{ENDPOINT,USERNAME,PASSWORD} envvars!"
    exit(1)

STASH_ENDPOINT = env['STASH_ENDPOINT']
STASH_USERNAME = env['STASH_USERNAME']
STASH_PASSWORD = env['STASH_PASSWORD']
HOMEDIR = env['HOME']

stash = stashy.connect(STASH_ENDPOINT, STASH_USERNAME, STASH_PASSWORD)

projects = stash.projects.list()

def main():
    for p in projects:
        repos = stash.projects[p["key"]].repos.list()
        for r in repos:
            project = r["project"]["key"]
            slug = r["slug"]
            cloneurlUpper= r["links"]["clone"]
            urlvalues = [i['href'] for i in cloneurlUpper if 'href' in i]
            urllistvalues = [i for i, s in enumerate(urlvalues) if 'ssh' in s]
            urlindex = urllistvalues[0]
            url = urlvalues[urlindex]

            clonePath = "{0}/src/phg/stash/{1}/{2}".format(HOMEDIR,project,slug)
            if os.path.isdir(clonePath):
                shutil.rmtree(clonePath)
            if not os.path.exists("{0}/src/phg/stash/".format(HOMEDIR)):
                os.mkdir("{0}/src/phg/stash/".format(HOMEDIR))
            if not os.path.exists("{0}/src/phg/stash/{1}/".format(HOMEDIR,project)):
                os.mkdir("{0}/src/phg/stash/{1}/".format(HOMEDIR,project))

            os.mkdir(clonePath)

            print "Cloning {0} in {1}/{2}".format(url,project,slug)
            repo = git.Repo.init(clonePath)
            origin = repo.create_remote('origin',url)
            origin.fetch()
            origin.pull(origin.refs[0].remote_head)

if __name__ == '__main__':
    sys.exit(main())
