## About

This contains a collection of scripts which create a number of Article objects in JSON or YAML.
why? I could easily feed the fields directly into a rails AR create verb. however, these two parts will be executed in different places in the cloud
so I bellieve an interchange FILE is an easier and more portable thing (ultimately I might put these files on GCS and listen to that folder via GCF).

# File format

A file will have MANDATORY stuff

## How Crawler works

It parses a lot of RSS entered manually by me (with my personal work/life bias: news from US, EU, Tech, Ruby, GCP):

```
# sample news RSS, and fields that feedjira feeds me:
📚 ABC News: US:        title,url,summary,categories,published,entry_id,image
📚 BBC Politics:        title,url,summary,published,entry_id,image
📚 BBC Science: title,url,summary,published,entry_id,image
📚 BCC Europe:  title,url,summary,published,entry_id,image
📚 CBSNews.com: title,url,summary,published,entry_id
📚 CNN.com Top Stories: title,url,published,entry_id,image
📚 Everyday Rails:      title_type,title,entry_id,updated,links,content,published
📚 GCP latest releases: title_type,title,entry_id,updated,links,content,published
📚 Google Cloud Blog:   title,url,summary,author,categories,published,entry_id
📚 Il Fatto:    title,url,summary,author,categories,published,entry_id,comments,content,image
📚 Kevin Randles on Medium:     title,url,author,categories,published,entry_id,content
📚 Repubblica - Esteri: title,url,author,categories,published,enclosure_length,enclosure_type,enclosure_url,summary,entry_id
📚 Repubblica - Home:   title,url,summary,author,categories,published,entry_id,updated
📚 Riccardo Carlesso - Blog:    title,url,summary,author,categories,published,entry_id,image
📚 Riccardo Carlesso - Medium:  title,url,author,categories,published,entry_id,content
📚 Romin Irani - Medium:        title,url,author,categories,published,entry_id,content
📚 Ruby (EN RSS):       title,url,summary,published,entry_id
📚 Ruby (IT RSS):       title,url,summary,published,entry_id
```

