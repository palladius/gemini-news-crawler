## About

This contains a collection of scripts which create a number of Article objects in JSON or YAML.
why? I could easily feed the fields directly into a rails AR create verb. however, these two parts will be executed in different places in the cloud
so I bellieve an interchange FILE is an easier and more portable thing (ultimately I might put these files on GCS and listen to that folder via GCF).

# File format

A file will have MANDATORY stuff
