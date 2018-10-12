CREATE TABLE author_records%SUFFIX% (
    id serial NOT NULL,
    aggregate_id uuid NOT NULL,
    name character varying,
    email character varying,
    CONSTRAINT author_records_pkey%SUFFIX% PRIMARY KEY (id)
);

CREATE UNIQUE INDEX author_records_keys%SUFFIX% ON author_records%SUFFIX% USING btree (aggregate_id);
