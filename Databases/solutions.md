## Schema exercise

![Solution schema](solution_schema.png)

## SQL exercises

### Simple queries

* Find out what the different tables are in the database, and what they look like.

```
.tables
.schema

.header on
.mode column
SELECT * FROM probesets LIMIT 2;
```

* Get 5 rows from the genes table.

```
SELECT * FROM genes LIMIT 5;
```

* Get the row in the genes table with symbol HOXD4.

```
SELECT * FROM genes WHERE symbol = 'HOXD4';
```

* What is the location of gene CCDC65?

```
SELECT location FROM genes WHERE symbol = 'CCDC65';
```

### Counts, subqueries, etc

* How many genes are there in the genes table?

```
SELECT COUNT(*) FROM genes;
```

* How many genes are there on the p-arm of chromosome 16?

```
SELECT COUNT(*) FROM genes WHERE location LIKE 'chr16p%';
```

* How many genes have no location?

```
SELECT COUNT(*) FROM genes WHERE location IS NULL;
```

* Select the first 5 distinct omim numbers from the genes table.

```
SELECT DISTINCT omim
FROM genes
LIMIT 5;
```

* How many distinct omim genes are mentioned in the genes table?

```
SELECT COUNT(*) FROM (SELECT DISTINCT omim FROM genes);
```

* What is the gene with the most probesets? You are allowed 2 queries to find out.

```
SELECT gene_id, COUNT(*) AS c FROM probesets GROUP BY gene_id ORDER BY c DESC LIMIT 10;
```
=> gene with gene_id 2447 has 34 probesets
```
SELECT * FROM genes WHERE id = 2447;
```

* What is the maximal expression value in the expressions table?

```
SELECT MAX(value) FROM expressions;
```

* Select the line in the expressions table with the maximum expression value.

```
SELECT * FROM expressions e
WHERE e.value = (
	SELECT MAX(value) FROM expressions
);
```

### Joins

* Return the names of the first 5 probesets, including the symbols of the genes they are located in. Your output should be similar to this:

name | symbol
:----|:----
1007_s_at | DDR1      
1053_at | RFC2      
117_at | HSPA6     
121_at | PAX8      
1255_g_at | GUCA1A    

```
SELECT p.name, g.symbol
FROM probesets p, genes g
WHERE p.gene_id = g.id
LIMIT 5;
```

* Similar to the previous question... Return the names of the first 5 probesets, including the symbols of the genes they are located in. But now give the columns the following titles: "probeset_name" and "gene_symbol". Your output should be similar to this:

probeset_name | gene_symbol
:----|:----
1007_s_at | DDR1      
1053_at | RFC2      
117_at | HSPA6     
121_at | PAX8      
1255_g_at | GUCA1A    

```
SELECT p.name AS probeset_name, g.symbol AS gene_symbol
FROM probesets p, genes g
WHERE p.gene_id = g.id
LIMIT 5;
```

* Get output that looks like the one below. Columns are: probeset name, gene symbol, location, ensembl, omim, sample name, and expression value.

name | symbol | location | ensembl | omim | name | value           
:----|:-------|:---------|:--------|:-----|:-----|:-----
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human1 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human2 | 6.93265237339259
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human3 | 7.32799071182831
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human4 | 6.95752478371924
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp1 | 5.31967484886285
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp2 | 7.35806566868421
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp3 | 6.82392726516533
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp4 | 6.2648525562143
1053_at | RFC2 | chr7q11.23 | ENSG00000049541 | 600404 | human1 | 8.41163999867383
1053_at | RFC2 | chr7q11.23 | ENSG00000049541 | 600404 | human2 | 8.34711445318181

```
SELECT p.name, g.symbol, g.location, g.ensembl, g.omim, s.name, e.value
FROM probesets p, genes g, samples s, expressions e
WHERE p.gene_id = g.id
AND e.probeset_id = p.id
AND e.sample_id = s.id
LIMIT 10;
```

* Same as the previous question, but create a view (named "v_expressions") based on this query. A `SELECT * FROM v_expressions LIMIT 10;` should give the same output as before.

name | symbol | location | ensembl | omim | name | value           
:----|:-------|:---------|:--------|:-----|:-----|:-----
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human1 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human2 | 6.93265237339259
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human3 | 7.32799071182831
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human4 | 6.95752478371924
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp1 | 5.31967484886285
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp2 | 7.35806566868421
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp3 | 6.82392726516533
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp4 | 6.2648525562143
1053_at | RFC2 | chr7q11.23 | ENSG00000049541 | 600404 | human1 | 8.41163999867383
1053_at | RFC2 | chr7q11.23 | ENSG00000049541 | 600404 | human2 | 8.34711445318181

```
CREATE VIEW v_expressions AS
SELECT p.name, g.symbol, g.location, g.ensembl, g.omim, s.name, e.value
FROM probesets p, genes g, samples s, expressions e
WHERE p.gene_id = g.id
AND e.probeset_id = p.id
AND e.sample_id = s.id
LIMIT 10;
```