#!/usr/bin/env python

import stashy
from pprint import pprint
import argparse
from os import environ as env
from sys import exit
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

stash = stashy.connect(STASH_ENDPOINT, STASH_USERNAME, STASH_PASSWORD)

projects = stash.projects.list()

for p in projects:
    print p["key"]
    repos = stash.projects[p["key"]].repos.list()
    for r in repos:
        try:
          print "\t", r["name"]
          pullrequests = list(stash.projects[p["key"]].repos[r["name"]].pull_requests.all())
        except stashy.errors.NotFoundException:
            continue
        for pr in pullrequests:
            print "\t\t", pr["author"]["user"]["displayName"]
            self = pr["links"]["self"]
            for h in self:
                print "\t\t", h["href"]
