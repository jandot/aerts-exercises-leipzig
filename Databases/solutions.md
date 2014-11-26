## Schema exercise

![Solution schema](solution_schema.png)

## SQL exercises

* Find out what the different tables are in the database, and what they look like.

```
.tables
.schema

.header on
.mode column
SELECT * FROM probesets LIMIT 2;
```

* How many genes have no location?

```
SELECT COUNT(*) FROM genes WHERE location IS NULL;
```

* How many distinct omim genes are mentioned in the gene table?

```
SELECT COUNT(*) FROM (SELECT DISTINCT omim FROM genes);
```

* What is the gene with the most probesets?

```
SELECT gene_id, COUNT(*) AS c FROM probesets GROUP BY gene_id ORDER BY c DESC LIMIT 10;
```
=> gene with gene_id 2447 has 34 probesets
```
SELECT * FROM genes WHERE id = 2447;
```

* Create a view on the data (called `v_expressions`) that looks like the one below. Columns are: probeset name, gene symbol, location, ensembl, omim, sample name, and expression value.

name | symbol | location | ensembl | omim | name | value           
:----|:-------|:---------|:--------|:-----|:-----|:-----
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human1 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human2 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human3 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | human4 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp1 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp2 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp3 | 6.75378974247776
1007_s_at | DDR1 | chr6p21.3 | ENSG00000137332 | 600408 | chimp4 | 6.75378974247776
1053_at | RFC2 | chr7q11.23 | ENSG00000049541 | 600404 | human1 | 8.41163999867383
1053_at | RFC2 | chr7q11.23 | ENSG00000049541 | 600404 | human2 | 8.41163999867383

```
SELECT p.name, g.symbol, g.location, g.ensembl, g.omim, s.name, e.value
FROM probesets p, genes g, samples s, expressions e
WHERE p.gene_id = g.id
AND e.probeset_id = p.id
AND e.sample_id = s.id
LIMIT 10;
```