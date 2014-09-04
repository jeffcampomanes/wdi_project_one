CREATE DATABASE blog;

CREATE TABLE posts(
id serial primary key,
author_id integer,
tag_id integer,
post_date date,
post text
);

CREATE TABLE author(
id serial primary key,
username varchar (255),
email varchar(255)
);

CREATE TABLE snippet(
id serial primary key,
post_id integer,
snippet_url varchar(255)
);

CREATE TABLE tag(
id serial primary key,
post_id integer,
tag varchar(255)
);

