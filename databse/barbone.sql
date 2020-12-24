
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Role: appuser
-- DROP ROLE appuser;

CREATE ROLE appuser WITH
  LOGIN
  SUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  ENCRYPTED PASSWORD 'md56ab628970fde1d2fcebb0b049df537ed';

-- Database: board

-- DROP DATABASE board;

CREATE DATABASE boards
    WITH 
    OWNER = appuser
    ENCODING = 'UTF8'
    LC_COLLATE = 'Portuguese_Brazil.1252'
    LC_CTYPE = 'Portuguese_Brazil.1252'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;


-- SCHEMA: boards

-- DROP SCHEMA boards ;

CREATE SCHEMA boards
    AUTHORIZATION appuser;


-- Table: boards.status

-- DROP TABLE boards.status;

CREATE TABLE boards.status
(
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    comment character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT status_pkey PRIMARY KEY (name)
)

TABLESPACE pg_default;

ALTER TABLE boards.status
    OWNER to appuser;

-- Table: boards.phase

-- DROP TABLE boards.phase;

CREATE TABLE boards.phase
(
    name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    comment character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT phase_pkey PRIMARY KEY (name)
)

TABLESPACE pg_default;

ALTER TABLE boards.phase
    OWNER to appuser;


-- Table: boards.board

-- DROP TABLE boards.board;

CREATE TABLE boards.board
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name character varying COLLATE pg_catalog."default" NOT NULL,
    status character varying(100) COLLATE pg_catalog."default" NOT NULL,
    comment character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT board_pkey PRIMARY KEY (id),
    CONSTRAINT "FK_board_status" FOREIGN KEY (status)
        REFERENCES boards.status (name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
)

TABLESPACE pg_default;

ALTER TABLE boards.board
    OWNER to appuser;


-- Table: boards.board_phases

-- DROP TABLE boards.board_phases;

CREATE TABLE boards.board_phases
(
    phase_name character varying(100) COLLATE pg_catalog."default" NOT NULL,
    board_id bigint NOT NULL,
    comment character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT board_phases_pkey PRIMARY KEY (phase_name, board_id),
    CONSTRAINT "FK_board_phases_board" FOREIGN KEY (board_id)
        REFERENCES boards.board (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT "FK_board_phases_phase" FOREIGN KEY (phase_name)
        REFERENCES boards.phase (name) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE boards.board_phases
    OWNER to appuser;


-- Table: boards.board_user_groups

-- DROP TABLE boards.board_user_groups;

CREATE TABLE boards.board_user_groups
(
    board_id bigint NOT NULL,
    user_group_uuid uuid NOT NULL,
    role_uuid uuid NOT NULL,
    comment character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT board_user_groups_pkey PRIMARY KEY (board_id, user_group_uuid, role_uuid),
    CONSTRAINT "FK_board_user_groups" FOREIGN KEY (board_id)
        REFERENCES boards.board (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE boards.board_user_groups
    OWNER to appuser;


-- Table: boards.board_users

-- DROP TABLE boards.board_users;

CREATE TABLE boards.board_users
(
    board_id bigint NOT NULL,
    user_uuid uuid NOT NULL,
    role_uuid uuid NOT NULL,
    comment character varying(255) COLLATE pg_catalog."default",
    CONSTRAINT board_users_pkey PRIMARY KEY (board_id, user_uuid, role_uuid),
    CONSTRAINT "FK_board_users" FOREIGN KEY (board_id)
        REFERENCES boards.board (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
)

TABLESPACE pg_default;

ALTER TABLE boards.board_users
    OWNER to appuser;
            