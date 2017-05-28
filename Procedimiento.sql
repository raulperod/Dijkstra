USE dijkstra;

DROP PROCEDURE IF EXISTS ruta_mas_corta;

DELIMITER $$

CREATE PROCEDURE ruta_mas_corta( IN _inicio VARCHAR(1), IN _final VARCHAR(1) )

	BEGIN

		# Obtienes los id de los nodos
		# Obtengo el id del nodo inicial
		SELECT idNodo INTO @nodo_inicial FROM nodos WHERE nombre = _inicio;
		# Obtengo el id del nodo final
		SELECT idNodo INTO @nodo_final FROM nodos WHERE nombre = _final;
		# Preparo la tabla pasos
		# Borro lo que haya en pasos
		TRUNCATE pasos;
		# Inicializo la tabla pasos
		INSERT INTO pasos ( nodo, nodo_anterior) SELECT idNodo, NULL FROM nodos;
		# Pongo en cero la distancia del nodo inicial y pongo el nodo de donde venia
		UPDATE pasos SET peso = 0, nodo_anterior = @nodo_inicial WHERE nodo = @nodo_inicial;
		# Se declara el nodo actual
		SET @nodo_actual = @nodo_inicial;
		# Declaro una variable para terminar el ciclo
		SET @fin = 0;
		# inicio el ciclo while
		WHILE @fin = 0 DO
			# Obtengo el peso del @nodo_actual
			SELECT p.peso INTO @peso_nodo_actual FROM pasos p WHERE p.nodo = @nodo_actual;
			# Actualizo los pesos de los nodos adyacentes al @nodo_actual
			UPDATE pasos p
				JOIN arcos a
					ON ((a.inicio = @nodo_actual AND a.final  = p.nodo)
					OR (a.final  = @nodo_actual AND a.inicio = p.nodo)) AND p.estaTerminado = 0
			SET p.peso = IF( (@peso_nodo_actual+a.peso) < p.peso, (@peso_nodo_actual+a.peso), p.peso ),
					nodo_anterior = IF( (@peso_nodo_actual+a.peso) < p.peso, @nodo_actual , nodo_anterior);
			# Marcamos el @nodo_actual como terminado
			UPDATE pasos SET estaTerminado = 1 WHERE nodo = @nodo_actual;
			# Si marcamos el nodo final
			IF @nodo_actual = @nodo_final THEN
				# terminamos
				SET @fin = 1;
			ELSE
				# Cambio el nodo actual, al nodo de menor peso
				SELECT nodo INTO @nodo_actual FROM pasos WHERE estaTerminado = 0 ORDER BY peso LIMIT 1;
			END IF;

		END WHILE;
		# Selecciono la ruta mas corta
		# reinicio la tabla ruta
		TRUNCATE ruta;
		# Declaro variables auxiliares
		SET @p = 1;
		SET @na = @nodo_final;
		# Almaceno el nodo final
		INSERT INTO ruta (orden, nodo)
		SELECT @p, n.nombre FROM nodos n WHERE n.idNodo = @na;
		# Empiezo el ciclo para obtener la ruta corta
		WHILE @p != 0 DO
			# Incremento @p
			SET @p = @p + 1;
			# Obtengo los nodos anteriores
			SELECT nodo_anterior INTO @na FROM pasos WHERE nodo = @na;
			# Inserto el nodo siguiente
			INSERT INTO ruta (orden, nodo)
			SELECT @p, n.nombre FROM nodos n WHERE n.idNodo = @na;
			# Condicion para terminar
			IF @na = @nodo_inicial THEN
				SET @p = 0;
			END IF;

		END WHILE;
		# Imprimo el resultado
		SELECT nodo 'Ruta mas corta' FROM ruta ORDER BY orden DESC;
		SELECT peso 'Peso ruta mas corta' FROM pasos WHERE nodo = @nodo_final;
	END;$$

DELIMITER ;
