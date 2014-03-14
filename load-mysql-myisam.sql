CREATE TABLE LINEITEM
                      ( L_ORDERKEY    INTEGER NOT NULL,
                        L_PARTKEY     INTEGER NOT NULL,
                        L_SUPPKEY     INTEGER NOT NULL,
                        L_LINENUMBER  INTEGER NOT NULL,
                        L_QUANTITY    FLOAT NOT NULL,
                        L_EXTENDEDPRICE  FLOAT NOT NULL,
                        L_DISCOUNT    FLOAT NOT NULL,
                        L_TAX         FLOAT NOT NULL,
                        L_RETURNFLAG  CHAR(1) NOT NULL,
                        L_LINESTATUS  CHAR(1) NOT NULL,
                        L_SHIPDATE    DATE NOT NULL,
                        L_COMMITDATE  DATE NOT NULL,
                        L_RECEIPTDATE DATE NOT NULL,
                        L_SHIPINSTRUCT CHAR(25) NOT NULL,
                        L_SHIPMODE     CHAR(10) NOT NULL,
                        L_COMMENT      VARCHAR(44) NOT NULL) ENGINE=MyISAM;

LOAD DATA LOCAL INFILE 'data/lineitem.tbl'
  INTO TABLE LINEITEM FIELDS TERMINATED BY '|';

CREATE INDEX index_shipdate ON LINEITEM (L_SHIPDATE) USING BTREE;
CREATE INDEX index_commitdate ON LINEITEM (L_COMMITDATE) USING BTREE;
CREATE INDEX index_partkey ON LINEITEM (L_PARTKEY) USING BTREE;
CREATE INDEX index_shipmode ON LINEITEM (L_SHIPMODE) USING BTREE;
OPTIMIZE TABLE LINEITEM;
