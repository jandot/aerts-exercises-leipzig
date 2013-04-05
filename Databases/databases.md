**Table of Contents**

1. [Relational databases](#relational-databases)
1. [Developing the database schema](#schema)
    1. [Normal forms](#normal-forms)
       1. [First normal form](#first-normal-form)
       1. [Second normal form](#second-normal-form)
       1. [Third normal form](#third-normal-form)
    1. [Other best practices](#best-practices)
1. [SQL - Structured Query Language](#sql)
1. [Getting data in](#getting-data-in)
    1. [INSERT INTO](#insert-into)
    1. [Importing a datafile](#import)
    1. [Using scripting](#scripted-import)
1. [Getting data out](#getting-data-out)
    1. [Single tables](#single-tables)
    1. [Combining tables](#combining-tables)
    1. [JOIN](#join)
1. [Additional functions](#additional-functions)
    1. [AND, OR, IN](#and-or-in)
    1. [DISTINCT](#distinct)
    1. [ORDER BY](#order-by)
    1. [COUNT](#count)
    1. [MAX-MIN-AVG](#max-min-avg)
    1. [GROUP BY](#group-by)
    1. [UNION, INTERSECT](#union-intersect)
    1. [LIKE](#like)
    1. [LIMIT](#limit)
    1. [Subqueries](#subqueries)
1. [Drawbacks of RDBMS](#drawbacks)
1. [Perl-DBI](#perl-dbi)
1. [Exercises](#exercises)


# <a id="databases"></a> Databases #
Jan Aerts; March 4, 2013

_(Part of the content of this lecture is taken from the database lectures from the yearly Programming for Biology course at CSHL, and the EasySoft tutorial at http://bit.ly/x2yNDb)_

Data management is critical in any science, including biology. In this session, we will focus on relational (SQL) databases (RDBMS) as these are the most common. If time permits we might venture into the world of NoSQL databases (_e.g._ MongoDB) to allow storing of huge datasets.

For relational databases, I will discuss the basic concepts (tables, tuples, columns, queries) and explain the different normalizations for data. There will also be an introduction on writing SQL queries as well as accessing a relational database from perl using DBI (for future reference). Document-oriented and other NoSQL databases (such as MongoDB) can often also be accessed through either an interactive shell and/or APIs (application programming interfaces) in languages such as perl, ruby, java, clojure, ...

## <a id="database-types"></a> Types of databases ##
There is a wide variety of database systems to store data, but the most-used in the relational database management system (RDBMS). These basically consist of tables that contain rows (which represent instance data) and columns (representing properties of that data). Any table can be thought of as an Excel-sheet.

# <a id="relational-databases"></a> Relational databases #
Relational databases are the most wide-spread paradigm used to store data. They use the concept of tables with each row containing an instance of the data, and each column representing different properties of that instance of data. Different implementations exist, include ones by Oracle and MySQL. For many of these (including Oracle and MySQL), you need to run a database server in the background. People (or you) can then connect to that server via a client. In this session, however, we'll use SQLite3. This RDBMS is much more lightweight; instead of relying on a database server, it holds all its data in a single file (and is in that respect more like MS Access). `sqlite3 my_db.sqlite` is the only thing you have to do to create a new database-file (named my_db.sqlite). SQLite is used by Firefox, Chrome, Android, Skype, ...

## <a id="schema"></a> Developing the database schema ##

For the purpose of this lecture, let's say you want to store individuals and their genotypes. In Excel, you could create a sheet that looks like this:
 
individual | ethnicity | rs12345 | rs12345_amb | chr_12345 | pos_12345 | rs98765 | rs98765_amb | chr_98765 | pos_98765 | rs28465 | rs28465_amb | chr_28465 | pos_28465
:----------|:----------|:--------|:------------|:----------|:-----------|:----------|:-----------|:----------|:----------|:--------|:------------|:----------|:---------
individual_A | caucasian | A/A | A | 1 | 12345 | A/G | R | 1 | 98765 | G/T | K | 5 | 28465
individual_B | caucasian | A/C | M | 1 | 12345 | G/G | G | 1 | 98765 | G/G | G | 5 | 28465

So let's create a relational database to store this data.

`jan@evopserver ~ $ sqlite3 test.sqlite`

We can get help using .help:

`sqlite> .help`

We first create a table, and insert that data:

```
sqlite> CREATE TABLE genotypes (individual STRING,
                                ethnicity STRING,
                                rs12345 STRING,
                                rs12345_amb STRING,
                                chr_12345 STRING,
                                pos_12345 INTEGER,
                                rs98765 STRING,
                                rs98765_amb STRING,
                                chr_98765 STRING,
                                pos_98765 INTEGER,
                                rs28465 STRING,
                                rs28465_amb STRING,
                                chr_28465 STRING,
                                pos_28465 INTEGER);
sqlite> INSERT INTO genotypes (individual, ethnicity, rs12345, rs12345_amb, chr_12345, pos_12345,
                                                      rs98765, rs98765_amb, chr_98765, pos_98765,
                                                      rs28465, rs28465_amb, chr_28465, pos_28465)
                       VALUES ('individual_A','caucasian','A/A','A','1',12345,
                                                          'A/G','R','1',98765,
                                                          'G/T','K','5',28465);

sqlite> INSERT INTO genotypes (individual, ethnicity, rs12345, rs12345_amb, chr_12345, pos_12345,
                                                      rs98765, rs98765_amb, chr_98765, pos_98765,
                                                      rs28465, rs28465_amb, chr_28465, pos_28465)
                       VALUES ('individual_A','caucasian','A/C','M','1',12345,
                                                          'G/G','G','1',98765,
                                                          'G/G','G','5',28465);
```
(Note that every SQL command is ended with a semi-colon...) This created a new table called genotypes; we can quickly check that everything is loaded (we'll come back to getting data out later):

```
sqlite> .mode column
sqlite> .headers on
sqlite> SELECT * FROM genotypes;
```

Done! For every new SNP we just add a new column, right? Wrong...

### <a id="normal-forms"></a>Normal forms ###

There are some good practices in developing relational database schemes which make it easier to work with the data afterwards. Some of these practices are represented in the "normal forms".

#### <a id="first-normal-form"></a>First normal form ####

To get to the first normal form:

Eliminate duplicative columns from the same table
Create separate tables for each group of related data and identify each row with a unique column (the primary key)
The columns rs123451, rs98765 and rs28465 are duplicates; they describe exactly the same type of thing (albeit different instances). According to the first rule of the first normal form, we need to eliminate these. And we can do that by creating new records (rows) for each SNP. In addition, each row should have a unique key. Best practices tell us to use autoincrementing integers, the primary key should contain no information in itself.

id | individual | ethnicity | snp | genotype | genotype_amb | chromosome | position
:--|:-----------|:----------|:----|:---------|:-------------|:-----------|:--------
1 | individual_A | caucasian | rs12345 | A/A | A | 1 | 12345
2 | individual_A | caucasian | rs98765 | A/G | R | 1 | 98765
3 | individual_A | caucasian | rs28465 | G/T | K | 5 | 28465
4 | individual_B | caucasian | rs12345 | A/C | M | 1 | 12345
5 | individual_B | caucasian | rs98765 | G/G | G | 1 | 98765
6 | individual_B | caucasian | rs28465 | G/G | G | 5 | 28465

To generate this table:

```
sqlite> DROP TABLE genotypes;
sqlite> CREATE TABLE genotypes (id INTEGER PRIMARY KEY, individual STRING, ethnicity STRING, snp STRING,
                                genotype STRING, genotype_amb STRING, chromosome STRING, position INTEGER);
sqlite> INSERT INTO genotypes (individual, ethnicity, snp, genotype, genotype_amb, chromosome, position)
                       VALUES ('individual_A','caucasian','rs12345','A/A','A','1',12345);
sqlite> INSERT INTO genotypes (individual, ethnicity, snp, genotype, genotype_amb, chromosome, position)
                       VALUES ('individual_A','caucasian','rs98765','A/G','R','1',98765);
sqlite> INSERT INTO genotypes (individual, ethnicity, snp, genotype, genotype_amb, chromosome, position)
                       VALUES ('individual_A','caucasian','rs28465','G/T','K','1',28465);
sqlite> INSERT INTO genotypes (individual, ethnicity, snp, genotype, genotype_amb, chromosome, position)
                       VALUES ('individual_B','caucasian','rs12345','A/C','M','1',12345);
sqlite> INSERT INTO genotypes (individual, ethnicity, snp, genotype, genotype_amb, chromosome, position)
                       VALUES ('individual_B','caucasian','rs98765','G/G','G','1',98765);
sqlite> INSERT INTO genotypes (individual, ethnicity, snp, genotype, genotype_amb, chromosome, position)
                       VALUES ('individual_B','caucasian','rs28465','G/G','G','1',28465);
```

The fact that id is defined as INTEGER PRIMARY KEY makes it increment automatically if not defined specifically. So loading data without explicitly specifying the value for id automatically takes care of everything.

#### <a id="second-normal-form"></a>Second normal form ####

There is still a lot of duplication in this data. In record 1 we see that individual_A is of Caucasian ethnicity; a piece of information that is duplicated in records 2 and 3. The same goes for the positions of the SNPs. In records 1 and 4 we can see that the SNP rs12345 is located on chromosome 1 at position 12345. But what if afterwards we find an error in our data, and rs12345 is actually on chromosome 2 instead of 1. In a table as the one above we would have to look up all these records and change the value from 1 to 2. Enter the second normal form:

Remove subsets of data that apply to multiple rows of a table and place them in separate tables.
Create relationships between these new tables and their predecessors through the use of foreign keys.
So how could we do that for the table above? Each row contains 3 different types of things: information about an individual (i.c. name and ethnicity), a SNP (i.c. the accession number, chromosome and position), and a genotype linking those two together (the genotype column, and the column containing the IUPAC ambiguity code for that genotype). To get to the second normal form, we need to put each of these in a separate table:

The name of each table should be plural (not mandatory, but good practice).
Each table should have a primary key, ideally named id. Different tables can contain columns that have the same name; column names should be unique within a table, but can occur across tables.
The individual column is renamed to name, and snp to accession.
In the genotypes table, individuals and SNPs are linked by referring to their primary keys (as used in the individuals and snps tables). Again best practice: if a foreign key refers to the id column in the individuals table, it should be named individual_id (note the singular).
The foreign keys individual_id and snp_id in the genotypes table must be of the same type as the id columns in the individuals and snps tables, respectively.

![Primary and foreign keys](primary_foreign_keys.png)

The individuals table:

id | name | ethnicity
:--|:-----|:---------
1 | individual_A | caucasian
2 | individual_B | caucasian

The snps table:

id | accession | chromosome | position
:--|:----------|:-----------|:--------
1 | rs12345 | 1 | 12345
2 | rs98765 | 1 | 98765
3 | rs28465 | 5 | 28465

The genotypes table:

id | individual_id | snp_id | genotype | genotype_amb
:--|:--------------|:-------|:---------|:------------
1 | 1 | 1 | A/A | A
2 | 1 | 2 | A/G | R
3 | 1 | 3 | G/T | K
4 | 2 | 1 | A/C | M
5 | 2 | 2 | G/G | G
6 | 2 | 3 | G/G | G

To generate these tables:

```
sqlite> DROP TABLE individuals;
sqlite> DROP TABLE snps;
sqlite> DROP TABLE genotypes;
sqlite> CREATE TABLE individuals (id INTEGER PRIMARY KEY, name STRING, ethnicity STRING);
sqlite> CREATE TABLE snps (id INTEGER PRIMARY KEY, accession STRING, chromosome STRING, position INTEGER);
sqlite> CREATE TABLE genotypes (id INTEGER PRIMARY KEY, individual_id INTEGER, snp_id INTEGER, genotype STRING, genotype_amb STRING);
sqlite> INSERT INTO individuals (name, ethnicity) VALUES ('individual_A','caucasian');
sqlite> INSERT INTO individuals (name, ethnicity) VALUES ('individual_B','caucasian');
sqlite> INSERT INTO snps (accession, chromosome, position) VALUES ('rs12345','1',12345);
sqlite> INSERT INTO snps (accession, chromosome, position) VALUES ('rs98765','1',98765);
sqlite> INSERT INTO snps (accession, chromosome, position) VALUES ('rs28465','5',28465);
sqlite> INSERT INTO genotypes (individual_id, snp_id, genotype, genotype_amb) VALUES (1,1,'A/A','A');
sqlite> INSERT INTO genotypes (individual_id, snp_id, genotype, genotype_amb) VALUES (1,2,'A/G','R');
sqlite> INSERT INTO genotypes (individual_id, snp_id, genotype, genotype_amb) VALUES (1,3,'G/T','K');
sqlite> INSERT INTO genotypes (individual_id, snp_id, genotype, genotype_amb) VALUES (2,1,'A/C','M');
sqlite> INSERT INTO genotypes (individual_id, snp_id, genotype, genotype_amb) VALUES (2,2,'G/G','G');
sqlite> INSERT INTO genotypes (individual_id, snp_id, genotype, genotype_amb) VALUES (2,3,'G/G','G');
```

#### <a id="third-normal-form"></a>Third normal form ####

In the third normal form, we try to eliminate unnecessary data from our database; data that could be calculated based on other things that are present. In our example table genotypes, the genotype and genotype_amb columns basically contain the same information, just using a different encoding. We could (should) therefore remove one of these. Our final database would look like this:

id | name | ethnicity
:--|:-----|:---------
1 | individual_A | caucasian
2 | individual_B | caucasian

The snps table:

id | accession | chromosome | position
:--|:----------|:-----------|:--------
1 | rs12345 | 1 | 12345
2 | rs98765 | 1 | 98765
3 | rs28465 | 5 | 28465

The genotypes table:

id | individual_id | snp_id | genotype_amb
:--|:--------------|:-------|:------------
1 | 1 | 1 | A
2 | 1 | 2 | R
3 | 1 | 3 | K
4 | 2 | 1 | M
5 | 2 | 2 | G
6 | 2 | 3 | G

To know what your database schema looks like, you can issue the .schema command. .tables gives you a list of the tables that are defined.

### <a id="best-practices"></a>Other best practices ###

There are some additional guidelines that you can use in creating your database schema, although different people use different guidelines. What I do:

No capitals in table or column names
Every table name is plural (e.g. genes)
The primary key of each table should be id
Any foreign key should be the singular of the table name, plus _id. So for example, a genotypes table can have a sample_id column which refers to the id column of the samples table.
In some cases, I digress from the rule of "every table name is plural", especially if a table is really meant to link to other tables together. A table genotypes which has an id, sample_id, snp_id, and genotype could e.g. also be called sample2snp.

## <a id="sql"></a>Structured Query Language ##

Any interacting with data in RDBMS can happen through the Structured Query Language (SQL): create tables, insert data, search data, ... There are two subparts of SQL:

***DDL - Data Definition Language:***

```
CREATE DATABASE test;
CREATE TABLE snps (id INT PRIMARY KEY AUTOINCREMENT, accession STRING, chromosome STRING, position INTEGER);
ALTER TABLE...
DROP TABLE snps;
```

For examples: see above.

***DML - Data Manipulation Language:***

```
SELECT
UPDATE
INSERT
DELETE
````

Some additional functions are:

```
DISTINCT
COUNT(*)
COUNT(DISTINCT column)
MAX(), MIN(), AVG()
GROUP BY
UNION, INTERSECT
```

We'll look closer at getting data into a database and then querying it, using these four SQL commands.

## <a id="getting-data-in"></a>Getting data in ##

### <a id="insert-into"></a>INSERT INTO ###

There are several ways to load data into a database. The method used above is the most straightforward but inadequate if you have to load a large amount of data.

It's basically:

```
sqlite> INSERT INTO <table_name> (<column_1>, <column_2>, <column_3>)
                          VALUES (<value_1>, <value_2>, <value_3>);
```

### <a id="import"></a>Importing a datafile ###

But this becomes an issue if you have to load 1,000s of records. Luckily, it's possible to load data from a comma-separated file straight into a table. Suppose you want to load 3 more individuals, but don't want to type the insert commands straight into the sql prompt. Create a file (e.g. "data.csv") that looks like this:

```
individual_C,african
individual_D,african
individual_C,asian
```

SQLite contains a `.import` command to load this type of data. Syntax: `.import <file> <table>`. So you could issue:

```
sqlite> .separator ','
sqlite> .import data.csv individuals
```

Aargh... We get an error!

```
Error: data.tsv line 1: expected 3 columns of data but found 2
```

This is because the table contains an ID column that is used as primary key and that increments automatically. Unfortunately, SQLite cannot work around this issue automatically. One option is to add the new IDs to the text file and import that new file. But this is not recommended, because it screws with some internal counters (SQLite keeps a counter whenever it autoincrements a column, but this counter is not adjusted if you hardwire the ID). A possible workaround is to create a temporary table (e.g. individuals_tmp) without the id column, import the data in that table, and then copy the data from that temporary table to the real individuals.

```
sqlite> .schema individuals
sqlite> CREATE TABLE individuals_tmp (name STRING, ethnicity STRING);
sqlite> .separator ','
sqlite> .import data.csv individuals_tmp
sqlite> INSERT INTO individuals (name, ethnicity) SELECT * FROM individuals_tmp;
sqlite> DROP TABLE individuals_tmp;
```

Your individuals table should now look like this (using `SELECT * FROM individuals;`):

id | name | ethnicity
:--|:-----|:---------
1 | individual_A | caucasian
2 | individual_B | caucasian
3 | individual_C | african
4 | individual_D | african
5 | individual_E | asian

### <a id="scripted-import"></a>Using scripting ###

There are different ways you can load data into an SQL database from scripting languages (I like to do this using Ruby). But as this is a Perl-oriented course... See Perl-DBI below where we devote a whole section to interfacing Perl to a database.

## <a id="getting-data-out"></a>Getting data out ##

### <a id="single-tables"></a>Single tables ###

It is very simple to query a single table. The basic syntax is:

```
SELECT <column_name1, column_name2> FROM <table_name> WHERE <conditions>;
```

If you want to see all columns, you can use * instead of a list of column names, and you can leave out the WHERE clause. The simplest query is therefore `SELECT * FROM <table_name>;`.

Data can be filtered using a `WHERE` clause. For example:

```
SELECT * FROM individuals WHERE ethnicity = 'african';
SELECT * FROM individuals WHERE ethnicity = 'african' OR ethnicity = 'caucasian';
SELECT * FROM individuals WHERE ethnicity IN ('african', 'caucasian');
SELECT * FROM individuals WHERE ethnicity != 'asian';
```

You often just want to see a small subset of data just to make sure that you're looking at the right thing. In that case: add a LIMIT clause to the end of your query:

```
SELECT * FROM individuals LIMIT 5;
SELECT * FROM individuals WHERE ethnicity = 'caucasian' LIMIT 1;
```

If you just want know the number of records that would match your query, use `COUNT(*)`:

```
SELECT COUNT(*) FROM individuals WHERE ethnicity = 'african';
```

Using the `GROUP BY` clause you can aggregate data. For example:

```
SELECT ethnicity, COUNT(*) from individuals GROUP BY ethnicity;
```

### <a id="combining-tables"></a>Combining tables ###

In the second normal form we separated several aspects of the data in different tables. Ultimately, we want to combine that information of course. This is where the primary and foreign keys come in. Suppose you want to list all different SNPs, with the alleles that have been found in the population:

```
SELECT snp_id, genotype_amb FROM genotypes;
```

This isn't very informative, because we get the uninformative numbers for SNPs instead of SNP accession numbers. To run a query across tables, we have to call both tables in the FROM clause:

```
SELECT snps.accession, genotypes.genotype_amb FROM snps, genotypes WHERE snps.id = genotypes.snp_id;
```

What happens here?

* Both the snps and genotypes tables are referenced in the FROM clause.
* In the SELECT clause, we tell the query what columns to return. We prepend the column names with the table name, to know what column we actually mean (snps.id is a different column from individuals.id).
* In the WHERE clause, we actually provide the link between the 2 tables: the value for snp_id in the genotypes table should correspond with the id column in the snps table. What do you think would happen if we wouldn't provide this WHERE clause? How many records would be returned?

Having to type the table names in front of the column names can become tiresome. We can however create aliases like this:

```
SELECT s.accession, g.genotype_amb FROM snps s, genotypes g WHERE s.id = g.snp_id;
```

Now how do we get a list of individuals with their genotypes for all SNPs?:

```
SELECT i.name, s.accession, g.genotype_amb
FROM individuals i, snps s, genotypes g
WHERE i.id = g.individual_id
AND s.id = g.snp_id;
```

### <a id="join"></a>JOIN ###

Sometimes, though, we have to join tables in a different way. Suppose that our snps table contains SNPs that are nowhere mentioned in the genotypes table, but we still want to have them mentioned in our output:

```
sqlite> INSERT INTO snps (accession, chromosome, position) VALUES ('rs11223','2',11223);
```

If we run the following query:

```
sqlite> SELECT s.accession, s.chromosome, s.position, g.genotype_amb
   ...> FROM snps s, genotypes g
   ...> WHERE s.id = g.snp_id
   ...> ORDER BY s.accession, g.genotype_amb;
```

We get the following output:

chromosome | position | accession | genotype_amb
:----------|:---------|:----------|:------------
1 | 12345 | rs12345 | A
1 | 12345 | rs12345 | M
1 | 98765 | rs98765 | G
1 | 98765 | rs98765 | R
5 | 28465 | rs28465 | G
5 | 28465 | rs28465 | K

But we actually want to have rs11223 in the list as well. Using this approach, we can't because of the `WHERE s.id = g.snp_id` clause. The solution to this is to use an explicit join. To make things complicated, there are several types: inner and outer joins. In principle, an inner join gives the result of the intersect between two tables, while an outer join gives the results of the union. What we've been doing up to now is look at the intersection, so the approach we used above is equivalent to an inner join:

```
sqlite> SELECT s.accession, g.genotype_amb
   ...> FROM snps s INNER JOIN genotypes g ON s.id = g.snp_id
   ...> ORDER BY s.accession, g.genotype_amb;
```

gives;

accession | genotype_amb
:---------|:------------
rs12345 | A
rs12345 | M
rs28465 | G
rs28465 | K
rs98765 | G
rs98765 | R

A left outer join returns all records from the left table, and will include any matches from the right table:

```
sqlite> SELECT s.accession, g.genotype_amb
   ...> FROM snps s LEFT OUTER JOIN genotypes g ON s.id = g.snp_id
   ...> ORDER BY s.accession, g.genotype_amb;
```

gives:

accession | genotype_amb
:---------|:------------
rs11223 |  
rs12345 | A
rs12345 | M
rs28465 | G
rs28465 | K
rs98765 | G
rs98765 | R

(Notice the extra line for rs11223.)

A full outer join, finally, return all rows from the left table, and all rows from the right table, matching any rows that should be.

## <a id="additional-functions"></a>Additional functions ##

### <a id="and-or-in"></a>AND, OR, IN ###

Your queries might need to combine different conditions:

```
sqlite> SELECT * FROM snps WHERE chromosome = '1' AND position < 40000;
sqlite> SELECT * FROM snps WHERE chromosome = '1' OR chromosome = '5';
sqlite> SELECT * FROM snps WHERE chromosome IN ('1','5');
```

### <a id="distinct"></a>DISTINCT ###

Whenever you want the unique values in a column: use DISTINCT in the SELECT clause:

````
sqlite> SELECT genotype_amb FROM genotypes;
genotype_amb
A
R
K
M
G
G
sqlite> SELECT DISTINCT genotype_amb FROM genotypes;
genotype_amb
A
G
K
M
R
````

DISTINCT automatically sorts the results.

### <a id="order-by"></a>ORDER BY ###

```
sqlite> SELECT * FROM snps ORDER BY chromosome;
sqlite> SELECT * FROM snps ORDER BY accession DESC;
```

### <a id="count"></a>COUNT ###

For when you want to count things:

```
sqlite> SELECT COUNT(*) FROM genotypes WHERE genotype_amb = 'G';
```

### <a id="max-min-avg"></a>MAX(), MIN(), AVG() ###

...act as you would expect (only works with numbers, obviously):

```
sqlite> SELECT MAX(position) FROM snps;
```

### <a id="group-by"></a>GROUP BY ###

GROUP BY can be very useful in that it first aggregates data. It is often used together with COUNT, MAX, MIN or AVG:

```
sqlite> SELECT genotype_amb, COUNT(*) FROM genotypes GROUP BY genotype_amb;
sqlite> SELECT genotype_amb, COUNT(*) AS c FROM genotypes GROUP BY genotype_amb ORDER BY c 
DESC;
sqlite> SELECT chromosome, MAX(position) FROM snps GROUP BY chromosome ORDER BY chromosome;
```

genotype_amb | c
:------------|:-
G | 2
A | 1
K | 1
M | 1
R | 1

chromosome | MAX(position)
:----------|:-------------
1 | 98765
2 | 11223
5 | 28465

### <a id="union-intersect"></a>UNION, INTERSECT ###

It is sometimes hard to get the exact rows back that you need using the WHERE clause. In such cases, it might be possible to construct the output based on taking the union or intersection of two or more different queries:

```
sqlite> SELECT * FROM snps WHERE chromosome = '1';
sqlite> SELECT * FROM snps WHERE position < 40000;
sqlite> SELECT * FROM snps WHERE chromosome = '1' INTERSECT SELECT * FROM snps WHERE position < 40000;
```

id | accession | chromosome | position
:--|:----------|:-----------|:--------
1 | rs12345 | 1 | 12345

### <a id="like"></a>LIKE ###

Sometimes you want to make fuzzy matches. What if you're not sure if the ethnicity has a capital or not?

```
sqlite> SELECT * FROM individuals WHERE ethnicity = 'African';
```

returns no results...

```
sqlite> SELECT * FROM individuals WHERE ethnicity LIKE '%frican';
```

### <a id="limit"></a>LIMIT ###

If you only want to get the first 10 results back (e.g. to find out if your complicated query does what it should do without running the whole actual query), use LIMIT:

```
sqlite>> SELECT * FROM snps LIMIT 2;
```

### <a id="subqueries"></a>Subqueries ###

As we mentioned in the beginning, the general setup of a SELECT is:

```
SELECT <column_names>
FROM <table>
WHERE <condition>;
```

But as you've seen in the examples above, the output from any SQL query is itself basically a table. So we can actually use that output table to run another SELECT on. For example:

```
sqlite> SELECT *
   ...> FROM (
   ...>        SELECT *
   ...>        FROM snps
   ...>        WHERE chromosome IN ('1','5'))
   ...> WHERE position < 40000;
```

Of course, you can use UNION and INTERSECT in the subquery as well...

subqueries: select count(*) from (select distinct genotype_amb)

## <a id="drawbacks"></a>Drawbacks of relational databases ##

scalability
modeling

## <a id="perl-dbi"></a>Perl-DBI (for future reference)##

Interacting with data from the SQL command line is nice, but sometimes you want to integrate those queries into larger scripts, for example in Perl or Ruby. Here, we'll show how to use the perl DBI. There are some object-relation-mapping packages available for Perl (e.g. Class::DBI, DBIx::Class, and Rose::DB::Object). These are heavily based on Object-Oriented Perl. In this lecture, we'll go underneath all this and use the non-OO DBI.

Why would you want to access a database from within Perl? SQL is already a very strong language, so why add the difficulty of another layer on top of that? Actually, SQL can do a lot, but not everything. It has no support for control flow (while, foreach, ...; except in PL/SQL) and conditional branches (if, else). In addition, most programs that make use of a database are written in some other language like Perl. From Perl the programmer does the interaction with the user, with files, and so on. Perl also provides the program logic. And the interaction with the database is typically to execute some database commands, such as fetching data from the database and processing it using Perl's capabilities. The logic of the program may depend on the data found in the database, but it is Perl, not SQL, that provides most of this logic.

### DBI and DBD ###

In Perl, a set of modules have been written that allow interaction with relational databases. DataBase Independent (DBI) is a module that handles most of the interaction from the program code; DataBase Dependent (or DataBase Driver; DBD) is a set of modules, different for each particular DBMS, that handles actually communicating with the DBMS.

To use a MySQL database from Perl you need first to have MySQL installed and properly configured. This is not a Perl job, but a database administration job: you have to get MySQL and install it on your system and set up the appropriate user accounts and permissions.

Then you have to install the Perl DBD driver for MySQL, as well as the Perl DBI module. The combination of MySQL (the DBMS), DBD (the particular driver for your DBMS), and DBI (the Perl interface to the DBI and DBMS), is what gives you the actual connection from Perl to the database, and enables you to send SQL statements to the database and retrieve results.

#### Installing DBI and DBD ###

```
perl -MCPAN -e shell
cpan> install DBI
cpan> install DBD::SQLite
```

### Connecting to a database ###

First thing we need is a database handle that we can use to pipe everything through:

```
#!/usr/bin/perl
use strict;
use warnings;
use DBI;

my $dbh = DBI->connect("dbi:SQLite:dbname=test.sqlite",     #DataSource Name DSN
                       "",                                  #username
                       "",                                  #password
                       {AutoCommit => 1, RaiseError => 1})  #options
          or die $DBI::errstr;
```

### Do something ###

The simplest way to do something in a database from Perl is to use do. It lets you do anything to the database that you could do in plain SQL. It doesn't really interact with you Perl program if you're selecting records, though:

```
$dbh->do(<<EOSQL)
  INSERT INTO snps (accession, chromosome, position)
  VALUES ('rs99887', '7', 99887);
EOSQL
```

### Slurp data from database ###

In getting data from a database, we can run a query and retrieve all data in one large array using select_arrayref:

```
my @snps = @{$dbh->selectall_arrayref(<<'EOSQL')};
  SELECT accession, chromosome, position
  FROM snps
  WHERE chromosome = '1'
EOSQL

for my $snp (@snps) {
  my ($acc, $chr, $pos) = @$snp;
  #do something with this data...
}
```

`@snps` holds all data that matches the query, so will be large. Every element in @snps is an array reference.

### Getting data one at a time ###

But if you except to get a large dataset back, loading everything at once into memory is dangerous. In that case (or anytime, actually) you can use one-at-a-time selects:

```
my $sth = $dbh->prepare(<<'EOSQL');
  SELECT accession, chromosome, position
  FROM snps
  WHERE chromosome = '1';
EOSQL

$sth->execute();
while (my $snp = $sth->fetchrow_arrayref) {
  my ($acc, $chr, $pos) = @$snp;
  #do something with this data...
}
```

This approach works in 3 steps: first you prepare the dataset by specifying the query, then you execute it, and finally you call the fetchrow_array method until it returns undef.

### Using parameters ###

In the example above, we hard-coded that the query should be for chromosome 1. What if you want to make that a variable? What if we don't know yet at that point which chromosome to look for? To solve this problem, we can use placeholders:

```
my $sth = $dbh->prepare(<<'EOSQL');
  SELECT accession, chromosome, position
  FROM snps
  WHERE chromosome = ?;
EOSQL

my @numbers = ('1','5');
foreach my $c (@numbers) {
  print "Now querying for chromosome ", $c, "\n";
  $sth->execute($c);
  while (my $snp = $sth->fetchrow_arrayref) {
    my ($acc, $chr, $pos) = @$snp;
    print $acc, "-", $chr, "-", $pos, "\n";
  }
}
```

In case you want to have two or more variables, just define them in the order that they appear in the SQL query:

```
my $sth = $dbh->prepare(<<'EOSQL');
  SELECT accession, chromosome, position
  FROM snps
  WHERE chromosome = ?
  AND position < ?;
EOSQL

$sth->execute('1', 40000);
while (my $snp = $sth->fetchrow_arrayref) {
  my ($acc, $chr, $pos) = @$snp;
  print $acc, "-", $chr, "-", $pos, "\n";
}
```

### Binding variables ###

Another method for accessing the results from a query, is to bind columns to a variable, and then use fetch:

```
my $sth = $dbh->prepare(<<'EOSQL');
  SELECT accession, chromosome, position
  FROM snps
  WHERE chromosome = '1';
EOSQL

$sth->execute();
my ($acc, $chr, $pos);
$sth->bind_columns(\$acc, \$chr, \$pos);
while ($sth->fetch) {
  #do something with acc, chr and pos
}
```

## <a id="exercises"></a>Exercises ##

### Database schema normalization ###

We'll use two files on the server that were used in previous lectures as well:

* Database-Intro/AffyAnnotation.clean
* Database-Intro/RMAvalues0.05.txt

The RMAvalues0.05.txt file contains expression values for different individuals for a huge number of probesets. The AffyAnnotation.cleaned file has annotations for these probesets. We need to create a (normalized) database schema.

In groups of 2, please draw a database scheme which we can discuss afterwards.

### Loading data ###

Can we use the .import function to get the data in? Why or why not?

### Querying data - SQL ###

Get the data ready:

1. Copy the file Database-Intro/exercise.sqlite to your own workspace.
1. Create a new sqlite database: `sqlite3 database-exercise`
1. Import the database dump: `.restore exercise.sqlite`

Some questions to answer:

* Find out what the different tables are in the database, and what they look like.
* How many genes have no location?
* How many distinct omim genes are mentioned in the gene table?
* What is the gene with the most probesets?
* Recreate (a version of) the AffyAnnotation.clean file (i.e. a table with these columns: probeset_id, gene_symbol, location, ensembl, omim, expression-value).

Output should look like this:

```
name        symbol      location    ensembl          omim        name        value           
----------  ----------  ----------  ---------------  ----------  ----------  ----------------
1007_s_at   DDR1        chr6p21.3   ENSG00000137332  600408      human1      6.75378974247776
1007_s_at   DDR1        chr6p21.3   ENSG00000137332  600408      human2      6.75378974247776
1007_s_at   DDR1        chr6p21.3   ENSG00000137332  600408      human3      6.75378974247776
1007_s_at   DDR1        chr6p21.3   ENSG00000137332  600408      human4      6.75378974247776
1007_s_at   DDR1        chr6p21.3   ENSG00000137332  600408      chimp1      6.75378974247776
1007_s_at   DDR1        chr6p21.3   ENSG00000137332  600408      chimp2      6.75378974247776
1007_s_at   DDR1        chr6p21.3   ENSG00000137332  600408      chimp3      6.75378974247776
1007_s_at   DDR1        chr6p21.3   ENSG00000137332  600408      chimp4      6.75378974247776
1053_at     RFC2        chr7q11.23  ENSG00000049541  600404      human1      8.41163999867383
1053_at     RFC2        chr7q11.23  ENSG00000049541  600404      human2      8.41163999867383
```

### Querying data - Perl/DBI ###

Same questions, but now do this from within perl.
