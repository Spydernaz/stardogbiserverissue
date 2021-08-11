# Demo 2: Entity Extraction & Linking #

In this demo, we will be following the Stardog [Entity Extraction & Linking](https://www.stardog.com/tutorials/link-all-the-entities/)

To query the first document:

```SPARQL
select ?mention where {
  graph <tag:stardog:api:docs:movies:article.txt> {
    ?s rdfs:label ?mention .
  }
}
```

Query linked entities (Not Working)

```SPARQL
select ?mention ?entity where {
  graph <tag:stardog:api:docs:movies:article.txt> {
    ?s rdfs:label ?mention ;
    ?s <http://purl.org/dc/terms/references> ?entity .
  }
}
```
