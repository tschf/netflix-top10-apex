# Netflix Top 10

Using APEX to better consume "Top" lists beyond a single country.

## Installation

Connect to your parsing schema with SQLcl, and initiate the installation:

```sql
lb update -changelog-file controller.xml
```

Afer installation, you should grab the feed file and import it to the table
screen_ranking. I used SQL Developer Web to perform this action.

## Data Feed

Go to: https://www.netflix.com/tudum/top10/tv

At the bottom there are links for

* GLobal Lists
* Country Lists
* Most Popular Lists

For this sample, we are using "Country Lists".
