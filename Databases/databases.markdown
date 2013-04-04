CREATED USING markable.in/editor/

# Databases #

Jan Aerts; March 4, 2013

_(Part of the content of this lecture is taken from the database lectures from the yearly Programming for Biology course at CSHL, and the EasySoft tutorial at http://bit.ly/x2yNDb)_

Data management is critical in any science, including biology. In this session, we will look at different database concepts, from file-based solutions and relational (SQL) databases (RDBMS) to the more recent NoSQL databases (column-based or document-based) such as MongoDB. I will give some indications on when you'd choose one technology over the other.

For relational databases, I will discuss the basic concepts (tables, tuples, columns, queries) and explain the different normalizations for data. There will also be an introduction on writing SQL queries as well as accessing a relational database from perl using DBI. For document-oriented databases (MongoDB), I will discuss the basic concepts (collections, documents) and introduce the students to the mongo interactive shell. I'll also talk about how to access a MongoDB database from perl.

## Types of databases ##

There is a wide variety of database systems to store data, but the most-used in the relational database management system (RDBMS). These basically consist of tables that contain rows (which represent instance data) and columns (representing properties of that data). Any table can be thought of as an Excel-sheet.

# Relational databases #
Relational databases are the most wide-spread paradigm used to store data. They use the concept of tables with each row containing an instance of the data, and each column representing different properties of that instance of data. Different implementations exist, include ones by Oracle and MySQL. For many of these (including Oracle and MySQL), you need to run a database server in the background. People (or you) can then connect to that server via a client. In this session, however, we'll use SQLite3. This RDBMS is much more lightweight; instead of relying on a database server, it holds all its data in a single file (and is in that respect more like MS Access). `sqlite3 my_db.sqlite` is the only thing you have to do to create a new database-file (named my_db.sqlite). SQLite is used by Firefox, Chrome, Android, Skype, ...
