* weaves

# Getting Started with Compute Engine and the Google Python Client Library

Google Compute Engine features a RESTful API that allows developers to
run virtual machines in the cloud. This sample python command-line application
demonstrates how to access the Compute Engine API using the Google Python API
Client Library. For more information about the library, read the
[Getting Started: Google Python Client Library documentation][1].

To run the demo:

- Update the variables in the settings.json file.
    - &lt;your-project-id>: your Compute Engine [project ID][2].
- Update the client_secrets.json file with your client id and secret found in
  the [Google APIs Console][3].
- Run the sample using the command:

python main.py

Demo steps:

- Create an instance with a start up script and metadata. 
- Print out the URL where the modified image will be written.
- The start up script executes these steps on the instance:
    - Installs Image Magick on the machine.
    - Downloads the image from the URL provided in the metadata.
    - Adds the text provided in the metadata to the image.
    - Copies the edited image to Cloud Storage.
- After recieving input from the user, shut down the instance.

## Products
- [Google Compute Engine][4]
- [Google Cloud Storage][5]

## Language
- [Python][6]

## Dependencies
- [Google APIs Client Library for Python][7]
- [python-gflags][8]
- [httplib2][9]

[1]: https://developers.google.com/compute/docs/api/python_guide
[2]: https://developers.google.com/compute/docs/overview#concepts
[3]: https://code.google.com/apis/console
[4]: https://developers.google.com/compute
[5]: https://developers.google.com/storage
[6]: https://python.org
[7]: http://code.google.com/p/google-api-python-client/
[8]: https://code.google.com/p/python-gflags/
[9]: https://code.google.com/p/httplib2/

* Local

Used Ubuntu 14.04 packages 

 python-googleapi
 python-googleapi-samples
 python-gflags

 python-oauth2client
 python-httplib2

A lot of what can be done with the system can be carried out with the Python
Google cloud SDK and with the web interface.

I believe that this code (gce.py, etc.) uses earlier versions of this
SDK. It is all based on an underlying REST API.

** Authentication and Setup 

I needed to use  my walterd account in my browser to get the OAuth to
authenticate against that account so that it would access the projects.

The file client_secrets.json can be taken from the Project API and Auth
menu. Use "Create New Client ID" as an installed application. Download and
copy to this directory as client_secrets.json.

 https://console.developers.google.com/project/apps~coastal-cascade-654/apiui/credential

You can then run the script

 python main.py 

This will launch some authentication in the browser. In response, it
creates the oauth.dat file (just a .json file).

To restart authentication, delete the oauth.dat file.

* Process

After collecting the initial information. It invokes the open
authentication components (flow_from_...) and these are placed in a OAuth
Storage() object, which is the 'oauth2.dat' name in the settings.json
file. 



** 


** This file's Emacs file variables

[  Local Variables: ]
[  mode:text ]
[  mode:outline-minor ]
[  mode:auto-fill ]
[  fill-column: 75 ]
[  coding: iso-8859-1-unix ]
[  comment-column:50 ]
[  comment-start: "[  "  ]
[  comment-end:"]" ]
[  End: ]
