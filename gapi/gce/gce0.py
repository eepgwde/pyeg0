# Copyright 2013 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Google Compute Engine demo using the Google Python Client Library.

Demo steps:

"""
from __future__ import print_function

__author__ = 'kbrisbin@google.com (Kathryn Hurley)'

import logging
try:
  import simplejson as json
except:
  import json

import httplib2
from oauth2client.client import flow_from_clientsecrets
from oauth2client.file import Storage
from oauth2client.tools import run

import gce

import sys
import gflags
FLAGS = gflags.FLAGS

# Flag names are globally defined!  So in general, we need to be
# careful to pick names that are unlikely to be used by other libraries.
# If there is a conflict, we'll get an error at import time.
gflags.DEFINE_string('filename', '', 'input filename')
gflags.DEFINE_integer('count', None, 'arithmetic count', lower_bound=0)
gflags.DEFINE_boolean('debug', False, 'produces debugging output')
gflags.DEFINE_enum('state', 'up', ['up', 'down'], 'operational state')

IMAGE_URL = 'http://storage.googleapis.com/gce-demo-input/photo.jpg'
IMAGE_TEXT = 'Ready for dessert?'
INSTANCE_NAME = 'startup-script-demo'
DISK_NAME = INSTANCE_NAME + '-disk'
INSERT_ERROR = 'Error inserting %(name)s.'
DELETE_ERROR = """
Error deleting %(name)s. %(name)s might still exist; You can use
the console (http://cloud.google.com/console) to delete %(name)s.
"""


def delete_resource(delete_method, *args):
  """Delete a Compute Engine resource using the supplied method and args.

  Args:
    delete_method: The gce.Gce method for deleting the resource.
  """

  resource_name = args[0]
  logging.info('Deleting %s' % resource_name)

  try:
    delete_method(*args)
  except (gce.ApiError, gce.ApiOperationError, ValueError) as e:
    logging.error(DELETE_ERROR, {'name': resource_name})
    logging.error(e)


def main(argv):
  """Perform OAuth 2 authorization, then start, list, and stop instance(s)."""

  logging.basicConfig(level=logging.INFO)

  for x in argv:
    logging.info(x);

  try:
    argv = FLAGS(argv)  # parse flags
  except gflags.FlagsError, e:
    print('%s\\nUsage: %s ARGS\\n%s' % (e, argv[0], FLAGS))
    sys.exit(1)

  if FLAGS.debug:
    logging.info('non-flag arguments: {0}'.format(" ".join(argv)))
  logging.info('filename {0}'.format(FLAGS.filename))
  if FLAGS.count is not None:
    s = 'state %s; count %d'
    logging.info(s % (FLAGS.state, FLAGS.count))

  sys.exit(0)

  # Load the settings for this sample app.
  settings = json.loads(open(gce.SETTINGS_FILE, 'r').read())

  # Perform OAuth 2.0 authorization flow.
  flow = flow_from_clientsecrets(
      settings['client_secrets'], scope=settings['compute_scope'])
  storage = Storage(settings['oauth_storage'])
  credentials = storage.get()

  # Authorize an instance of httplib2.Http.
  if credentials is None or credentials.invalid:
    credentials = run(flow, storage)
  http = httplib2.Http()
  auth_http = credentials.authorize(http)

  # Initialize gce.Gce.
  gce_helper = gce.Gce(auth_http, project_id=settings['project'])

  # List all running insotances.
  logging.info('These are your running instances:')
  instances = gce_helper.list_instances()
  for instance in instances:
    for x in instance:
      logging.info(x['name'])

  instances = gce_helper.zones()
  logging.info("type: {0}".format(type(instances)))
  
  logging.info(gce_helper.zones0)

if __name__ == '__main__':
  main(sys.argv)
