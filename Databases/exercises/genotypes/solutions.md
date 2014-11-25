* Find out what the different tables are in the database, and what they look like.

```
.tables
.schema

.header on
.mode column
SELECT * FROM genes LIMIT 2;
```

* How many samples does each individual have?

```
SELECT individual_id, count(*)
FROM samples
GROUP BY individual_id;
```

Or more advanced:

```
SELECT i.name, count(*)
FROM individuals i, samples s
WHERE i.id = s.individual_id
GROUP BY i.name;
```

* How many genotypes do we have for each sample?

```
SELECT sample_id, count(*)
FROM genotypes
GROUP BY sample_id;
```

* What is the variation for which we have the least genotypes?

```
SELECT variation_id, count(*)
FROM genotypes
GROUP BY variation_id
ORDER BY count(*)
LIMIT 1;
```

* Create a view in the database that returns the results as shown below. Columns should be:
    * individual name
		* sample name
    * variation chromosome
		* variation position
		* genotype

```
name          name        chromosome  position    genotype  
------------  ----------  ----------  ----------  ----------
individual_1  sample_1    21          33031822    GG        
individual_1  sample_2    21          33031822    GG        
individual_1  sample_3    21          33031822    GT        
individual_2  sample_4    21          33031822    GG        
individual_2  sample_5    21          33031822    GT        
individual_1  sample_1    21          33031927    CG        
individual_1  sample_2    21          33031927    CG        
```

```
CREATE VIEW v_genotypes_1 AS
SELECT i.name, s.name, v.chromosome, v.position, g.genotype
FROM individuals i, samples s, variations v, genotypes g
WHERE i.id = s.individual_id
AND s.id = g.sample_id
AND v.id = g.variation_id;
```

* More advanced: Create a view in the database that returns the results as shown below. This is the same as the previous exercise, but w now include the gene name. Important: also variations that are *not* in genes should be included. Columns should be:
    * individual name
		* sample name
		* gene name
    * variation chromosome
		* variation position
		* genotype

```
i.name        s.name      g.name      v.chromosome  v.position  e.genotype
------------  ----------  ----------  ------------  ----------  ----------
...    
individual_2  sample_4                21            33032895    GG        
individual_2  sample_5                21            33032895    GG        
individual_1  sample_1                21            33032896    GT        
individual_1  sample_2                21            33032896    TT        
individual_1  sample_3                21            33032896    GT        
individual_2  sample_4                21            33032896    GG        
individual_2  sample_5                21            33032896    GG        
individual_1  sample_1    gene_1      21            33032988    AC        
individual_1  sample_2    gene_1      21            33032988    AC        
individual_1  sample_3    gene_1      21            33032988    CC        
individual_2  sample_4    gene_1      21            33032988    AA        
individual_2  sample_5    gene_1      21            33032988    AC        
individual_1  sample_1    gene_1      21            33033001    CG        
individual_1  sample_2    gene_1      21            33033001    CG        
individual_1  sample_3    gene_1      21            33033001    CG        
individual_2  sample_4    gene_1      21            33033001    CC        
individual_2  sample_5    gene_1      21            33033001    CC        
individual_1  sample_1    gene_1      21            33033026    AG
...     

```

```
CREATE VIEW v_genotypes_2 AS
SELECT i.name, s.name, g.name, v.chromosome, v.position, e.genotype
FROM individuals i, samples s, genes g, variations v, genotypes e
WHERE i.id = s.individual_id
AND v.gene_id IS NOT NULL
AND g.id = v.gene_id
AND s.id = e.sample_id
AND v.id = e.variation_id
UNION
SELECT i.name, s.name, '', v.chromosome, v.position, e.genotype
FROM individuals i, samples s, genes g, variations v, genotypes e
WHERE i.id = s.individual_id
AND v.gene_id IS NULL
AND s.id = e.sample_id
AND v.id = e.variation_id;
```