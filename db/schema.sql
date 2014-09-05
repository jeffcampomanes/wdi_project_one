CREATE DATABASE blog;

CREATE TABLE posts(
id serial primary key,
author_id integer,
tag_id integer,
title varchar(255),
post_date date,
post text
);

CREATE TABLE authors(
id serial primary key,
username varchar (255),
email varchar(255)
);

CREATE TABLE snippets(
id serial primary key,
post_id integer,
snippet_url varchar(255)
);

CREATE TABLE tags(
id serial primary key,
post_id integer,
tag varchar(255)
);

