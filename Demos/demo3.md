# Using the BI Server #

The BI server is an addon to Stardog that allows users to connect BI Tools such as PowerBI and Tableau to connect to Stardog and query data using an SQL interface.

To query Stardog, you use a mysql connection. The following command can be run to access the BI Server in this example setup:

```sh
# Default Password is 'admin'
mysql -h 127.0.0.1 -P5806 -u admin -p
```

The schema / databases wont update during a connection so go ahead and disconnect.

Make sure you run either demo one or demo 2 before continuing by the following:

```sh
# You can change the 1 to a 2 if you want the second demo
./demostardog.sh demo 1 && ./demostardog.sh demo 2
```

Once connected to MySQL, you can see the Stardog databases by the following query:

```sql
show databases;
```

For this example, we want to select the movies database and then show the available tables:

```sql
use movies;
show tables;
```

Finally, we want to query a table to select data:

```sql
select * from Person;
```
