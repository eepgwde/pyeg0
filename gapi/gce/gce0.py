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


def main():
  """Perform OAuth 2 authorization, then start, list, and stop instance(s)."""

  logging.basicConfig(level=logging.INFO)

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

  # List all running instances.
  logging.info('These are your running instances:')
  instances = gce_helper.list_instances()
  for instance in instances:
    logging.info(instance['name'])

if __name__ == '__main__':
  main()
