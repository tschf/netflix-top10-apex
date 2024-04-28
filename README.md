# Netflix Top 10

Using APEX to better consume "Top" lists beyond a single country.

## Requirements

This solution is built on top of APEX 23.2 and DB 23C (free).  
It also leverages The Movie DB (TMDB) to retrieve show artwork. So for the best
experience, you should register an account and request an API token.

## Installation

Create an environment variable for the TMDB read access token - using the exact
name as demonstrated in the snippet below.

```bash
export TMDB_READ_ACCESS_TOKEN="INSERT_ACTUAL_VALUE"
```

Connect to your parsing schema with SQLcl, and initiate the installation:

```sql
lb update -changelog-file controller.xml
```

note: Source files come from a workspace named `APP_DEV` with
ID `10000`.

Afer installation, you should grab the feed file and import it using the APEX application.
The landing page provides a file upload form.

![Region with file upload form](doc/images/upload-tsv.png)

## Feed File

Go to: <https://www.netflix.com/tudum/top10>

At the bottom there are links for

* Global Lists
* Country Lists
* Most Popular Lists

For this sample, we are using "Country Lists" TSV. This is released each week so
if you want to keep up to date, you need to re-upload the latest version (or implement
a sync job, outside the scope of this project).

## Next steps

* Add liquibase.properties for schema and app ID - and set apex_application_install executions for import  
* Show album artwork  
* Show other movies attributes souch as primary audio, country of origin
* Link to the netflix title? This might be inplausible
