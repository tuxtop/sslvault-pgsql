--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: seq_certificates_catalog; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_certificates_catalog
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_certificates_catalog OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: certificates_catalog; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE certificates_catalog (
    cid bigint DEFAULT nextval('seq_certificates_catalog'::regclass) NOT NULL,
    name character varying(64) NOT NULL,
    cn character varying(64),
    o character varying(64),
    ou character varying(64),
    l character varying(64),
    s character varying(64),
    c character(2),
    author_uid integer NOT NULL,
    creation timestamp without time zone DEFAULT now() NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    tags text
);


ALTER TABLE certificates_catalog OWNER TO postgres;

--
-- Name: seq_certificates_csr; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_certificates_csr
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_certificates_csr OWNER TO postgres;

--
-- Name: certificates_csr; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE certificates_csr (
    csid bigint DEFAULT nextval('seq_certificates_csr'::regclass) NOT NULL,
    csr text NOT NULL,
    cid bigint NOT NULL,
    author_uid integer NOT NULL,
    creation timestamp without time zone DEFAULT now() NOT NULL,
    private_key text NOT NULL,
    public_key text NOT NULL,
    key_length integer DEFAULT 2048 NOT NULL,
    key_type character(3) DEFAULT 'rsa'::bpchar NOT NULL,
    email character varying(128)
);


ALTER TABLE certificates_csr OWNER TO postgres;

--
-- Name: certificates_history; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE certificates_history (
    oid bigint NOT NULL,
    author_uid integer NOT NULL,
    previous_status character varying(32),
    new_status character varying(32),
    comment text,
    action text,
    creation timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE certificates_history OWNER TO postgres;

--
-- Name: seq_certificates_orders; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_certificates_orders
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_certificates_orders OWNER TO postgres;

--
-- Name: certificates_orders; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE certificates_orders (
    oid bigint DEFAULT nextval('seq_certificates_orders'::regclass) NOT NULL,
    author_uid integer NOT NULL,
    status character varying(32) DEFAULT 'csr_creation'::character varying NOT NULL,
    creation timestamp without time zone DEFAULT now() NOT NULL,
    duration integer DEFAULT 360 NOT NULL,
    cid bigint NOT NULL,
    provider_name character varying(64),
    provider_oid character varying(64),
    email character varying(128),
    certificate text,
    csid bigint NOT NULL,
    intermediate text,
    expiration timestamp without time zone
);


ALTER TABLE certificates_orders OWNER TO postgres;

--
-- Name: seq_keypairs_catalog; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_keypairs_catalog
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_keypairs_catalog OWNER TO postgres;

--
-- Name: keypairs_catalog; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE keypairs_catalog (
    kid integer DEFAULT nextval('seq_keypairs_catalog'::regclass) NOT NULL,
    name character varying(64) NOT NULL,
    private_key text NOT NULL,
    public_key text NOT NULL,
    creation timestamp without time zone DEFAULT now() NOT NULL,
    key_type character(3) DEFAULT 'rsa'::bpchar NOT NULL,
    key_size integer DEFAULT 2048 NOT NULL,
    author_uid integer NOT NULL
);


ALTER TABLE keypairs_catalog OWNER TO postgres;

--
-- Name: seq_users; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE seq_users
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE seq_users OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    uid integer DEFAULT nextval('seq_users'::regclass) NOT NULL,
    username character varying(32) NOT NULL,
    password character varying(32) NOT NULL,
    creation timestamp without time zone DEFAULT now() NOT NULL,
    enable boolean DEFAULT true NOT NULL,
    admin boolean DEFAULT false NOT NULL,
    email character varying(128)
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: certificates_catalog_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY certificates_catalog
    ADD CONSTRAINT certificates_catalog_name_key UNIQUE (name);


--
-- Name: certificates_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY certificates_catalog
    ADD CONSTRAINT certificates_catalog_pkey PRIMARY KEY (cid);


--
-- Name: certificates_csr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY certificates_csr
    ADD CONSTRAINT certificates_csr_pkey PRIMARY KEY (csid);


--
-- Name: certificates_orders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY certificates_orders
    ADD CONSTRAINT certificates_orders_pkey PRIMARY KEY (oid);


--
-- Name: keypairs_catalog_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY keypairs_catalog
    ADD CONSTRAINT keypairs_catalog_name_key UNIQUE (name);


--
-- Name: keypairs_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY keypairs_catalog
    ADD CONSTRAINT keypairs_catalog_pkey PRIMARY KEY (kid);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: postgres; Tablespace: 
--

CREATE UNIQUE INDEX idx_user_email ON users USING btree (email) WHERE (email IS NOT NULL);


--
-- Name: certificates_catalog_author_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY certificates_catalog
    ADD CONSTRAINT certificates_catalog_author_uid_fkey FOREIGN KEY (author_uid) REFERENCES users(uid);


--
-- Name: certificates_csr_author_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY certificates_csr
    ADD CONSTRAINT certificates_csr_author_uid_fkey FOREIGN KEY (author_uid) REFERENCES users(uid);


--
-- Name: certificates_csr_cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY certificates_csr
    ADD CONSTRAINT certificates_csr_cid_fkey FOREIGN KEY (cid) REFERENCES certificates_catalog(cid);


--
-- Name: certificates_history_author_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY certificates_history
    ADD CONSTRAINT certificates_history_author_uid_fkey FOREIGN KEY (author_uid) REFERENCES users(uid);


--
-- Name: certificates_history_oid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY certificates_history
    ADD CONSTRAINT certificates_history_oid_fkey FOREIGN KEY (oid) REFERENCES certificates_orders(oid);


--
-- Name: certificates_orders_author_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY certificates_orders
    ADD CONSTRAINT certificates_orders_author_uid_fkey FOREIGN KEY (author_uid) REFERENCES users(uid);


--
-- Name: certificates_orders_csid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY certificates_orders
    ADD CONSTRAINT certificates_orders_csid_fkey FOREIGN KEY (csid) REFERENCES certificates_csr(csid);


--
-- Name: cid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY certificates_orders
    ADD CONSTRAINT cid_fkey FOREIGN KEY (cid) REFERENCES certificates_catalog(cid) MATCH FULL;


--
-- Name: keypairs_catalog_author_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY keypairs_catalog
    ADD CONSTRAINT keypairs_catalog_author_uid_fkey FOREIGN KEY (author_uid) REFERENCES users(uid);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;
GRANT ALL ON SCHEMA public TO sslvault_www;


--
-- Name: seq_certificates_catalog; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE seq_certificates_catalog FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_certificates_catalog FROM postgres;
GRANT ALL ON SEQUENCE seq_certificates_catalog TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE seq_certificates_catalog TO sslvault_www;


--
-- Name: certificates_catalog; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE certificates_catalog FROM PUBLIC;
REVOKE ALL ON TABLE certificates_catalog FROM postgres;
GRANT ALL ON TABLE certificates_catalog TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE certificates_catalog TO sslvault_www;


--
-- Name: seq_certificates_csr; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE seq_certificates_csr FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_certificates_csr FROM postgres;
GRANT ALL ON SEQUENCE seq_certificates_csr TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE seq_certificates_csr TO sslvault_www;


--
-- Name: certificates_csr; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE certificates_csr FROM PUBLIC;
REVOKE ALL ON TABLE certificates_csr FROM postgres;
GRANT ALL ON TABLE certificates_csr TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE certificates_csr TO sslvault_www;


--
-- Name: certificates_history; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE certificates_history FROM PUBLIC;
REVOKE ALL ON TABLE certificates_history FROM postgres;
GRANT ALL ON TABLE certificates_history TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE certificates_history TO sslvault_www;


--
-- Name: seq_certificates_orders; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE seq_certificates_orders FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_certificates_orders FROM postgres;
GRANT ALL ON SEQUENCE seq_certificates_orders TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE seq_certificates_orders TO sslvault_www;


--
-- Name: certificates_orders; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE certificates_orders FROM PUBLIC;
REVOKE ALL ON TABLE certificates_orders FROM postgres;
GRANT ALL ON TABLE certificates_orders TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE certificates_orders TO sslvault_www;


--
-- Name: keypairs_catalog; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE keypairs_catalog FROM PUBLIC;
REVOKE ALL ON TABLE keypairs_catalog FROM postgres;
GRANT ALL ON TABLE keypairs_catalog TO postgres;
GRANT ALL ON TABLE keypairs_catalog TO sslvault_www;


--
-- Name: seq_users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE seq_users FROM PUBLIC;
REVOKE ALL ON SEQUENCE seq_users FROM postgres;
GRANT ALL ON SEQUENCE seq_users TO postgres;
GRANT SELECT,UPDATE ON SEQUENCE seq_users TO sslvault_www;


--
-- Name: users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM postgres;
GRANT ALL ON TABLE users TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE users TO sslvault_www;

