DROP DATABASE IF EXISTS dijkstra;

CREATE DATABASE dijkstra;

USE dijkstra;

CREATE TABLE nodos (
	idNodo INT(4) unsigned NOT NULL AUTO_INCREMENT,
	nombre VARCHAR(1) NOT NULL,
	PRIMARY KEY (idNodo),
	UNIQUE KEY nombre (nombre)
);

CREATE TABLE arcos (
	inicio INT(4) unsigned NOT NULL,
	final INT(4) unsigned NOT NULL,
	peso	INT(4) unsigned NOT NULL,
	KEY inicio (inicio),
	KEY final (inicio)
);
# pa (peso) , na (nodo actual)
CREATE TABLE pasos (
	nodo INT(4) unsigned NOT NULL,
	peso INT(4) unsigned NOT NULL DEFAULT '1000',
	nodo_anterior INT(4) unsigned NULL,
	estaTerminado TINYINT(1) NOT NULL DEFAULT '0'
);
# ruta corta
CREATE TABLE ruta (
	orden INT(2) unsigned NOT NULL,
	nodo VARCHAR(1) NOT NULL
);

ALTER TABLE arcos
ADD CONSTRAINT arcos_ibfk_1 FOREIGN KEY (inicio) REFERENCES nodos (idNodo) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT arcos_ibfk_2 FOREIGN KEY (final) REFERENCES nodos (idNodo) ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE pasos
ADD CONSTRAINT pasos_ibfk_1 FOREIGN KEY (nodo) REFERENCES nodos (idNodo) ON DELETE NO ACTION ON UPDATE NO ACTION,
ADD CONSTRAINT pasos_ibfk_2 FOREIGN KEY (nodo_anterior) REFERENCES nodos (idNodo) ON DELETE NO ACTION ON UPDATE NO ACTION;
