CREATE TABLE genotypes (individual STRING,
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
INSERT INTO genotypes (individual, ethnicity, rs12345, rs12345_amb, chr_12345, pos_12345,
                                                      rs98765, rs98765_amb, chr_98765, pos_98765,
                                                      rs28465, rs28465_amb, chr_28465, pos_28465)
                       VALUES ('individual_A','caucasian','A/A','A','1',12345,
                                                          'A/G','R','1',98765,
                                                          'G/T','K','5',28465);
INSERT INTO genotypes (individual, ethnicity, rs12345, rs12345_amb, chr_12345, pos_12345,
                                                      rs98765, rs98765_amb, chr_98765, pos_98765,
                                                      rs28465, rs28465_amb, chr_28465, pos_28465)
                       VALUES ('individual_A','caucasian','A/C','M','1',12345,
                                                          'G/G','G','1',98765,
                                                          'G/G','G','5',28465);
