# Demo 1: Music Ontology and Virtual Graphs #

In this demo, we will be following the Stardog [Virtual Graph Tutorial](https://www.stardog.com/tutorials/using-virtual-graphs/)

1. Set up a database
2. Configure a Virtual Graph
3. Creating a Virtual Graph
4. Querying the Virtual Graph

Query using the following SPARQL:

```SPARQL
SELECT ?member ?name {
   GRAPH <virtual://music> {
      ?band a :Band ;
            :name "The Beatles" .
      ?member :member ?band ;
            :name ?name .
   }
}
```
