DROP TABLE genes;
DROP TABLE probesets;
DROP TABLE gene_ontologies;
DROP TABLE gene2go;
DROP TABLE expression;
DROP TABLE samples;

CREATE TABLE genes (
  id INTEGER PRIMARY KEY,
  symbol STRING,
  location STRING,
  ensembl STRING,
  omim STRING);

CREATE TABLE probesets (
  id INTEGER PRIMARY KEY,
  name STRING,
  gene_id INTEGER);

CREATE TABLE gene_ontologies (
  id INTEGER PRIMARY KEY,
  value INTEGER);

CREATE TABLE gene2go (
  id INTEGER PRIMARY KEY,
  gene_id INTEGER,
  gene_ontology_id INTEGER);

CREATE TABLE samples (
  id INTEGER PRIMARY KEY,
  name STRING);

CREATE TABLE expressions (
  id INTEGER PRIMARY KEY,
  probeset_id INTEGER,
  sample_id INTEGER,
  value FLOAT);
