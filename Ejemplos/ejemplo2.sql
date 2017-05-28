USE dijkstra;

INSERT INTO nodos (nombre)
VALUES 	('a'),
		('b'),
		('c'),
		('d'),
		('e'),
		('z');

INSERT INTO arcos (inicio, final, peso)
VALUES 	(1,2,2),
		(1,3,3),
		(2,4,5),
		(2,5,2),
		(3,5,5),
		(4,6,2),
		(4,5,1),
		(5,6,4);
