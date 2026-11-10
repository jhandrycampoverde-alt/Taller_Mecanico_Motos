USE taller_motos;

-- Consulta 1: Seleccion y proyeccion
-- Motos de 200 cc o mas, fabricadas desde 2022
SELECT placa, marca, modelo, cilindraje
FROM   MOTO
WHERE  cilindraje >= 200 AND anio >= 2022;

-- Consulta 2: Reunion de cuatro tablas
-- Ordenes en proceso con cliente, placa y mecanico
SELECT c.nombres, c.apellidos, m.placa, o.estado,
       me.apellidos AS apellido_mecanico
FROM   CLIENTE c
JOIN   MOTO m           ON m.id_cliente   = c.id_cliente
JOIN   ORDEN_SERVICIO o ON o.id_moto      = m.id_moto
JOIN   MECANICO me      ON me.id_mecanico = o.id_mecanico
WHERE  o.estado = 'En proceso';

-- Consulta 3: Diferencia
-- Clientes que no tienen ninguna orden de servicio
SELECT cedula, nombres, apellidos
FROM   CLIENTE
WHERE  id_cliente NOT IN (
         SELECT m.id_cliente
         FROM   MOTO m
         JOIN   ORDEN_SERVICIO o ON o.id_moto = m.id_moto
       );

-- Consulta 4: Division
-- Mecanicos que han realizado todos los servicios preventivos
SELECT me.id_mecanico, me.nombres, me.apellidos
FROM   MECANICO me
JOIN (
         SELECT o.id_mecanico
         FROM   ORDEN_SERVICIO o
         JOIN   DETALLE_SERVICIO d ON d.id_orden    = o.id_orden
         JOIN   SERVICIO s         ON s.id_servicio = d.id_servicio
         WHERE  s.tipo = 'Preventivo'
         GROUP BY o.id_mecanico
         HAVING COUNT(DISTINCT s.id_servicio) =
                (SELECT COUNT(*) FROM SERVICIO WHERE tipo = 'Preventivo')
     ) t ON t.id_mecanico = me.id_mecanico;

-- Consulta 5: Agrupamiento y agregacion
-- Mano de obra por mecanico en ordenes entregadas (minimo 30 USD)
SELECT   me.apellidos,
         COUNT(DISTINCT o.id_orden) AS ordenes,
         SUM(d.precio_aplicado)     AS total_mano_obra
FROM     MECANICO me
JOIN     ORDEN_SERVICIO o   ON o.id_mecanico = me.id_mecanico
JOIN     DETALLE_SERVICIO d ON d.id_orden    = o.id_orden
WHERE    o.estado = 'Entregada'
GROUP BY me.id_mecanico, me.apellidos
HAVING   SUM(d.precio_aplicado) >= 30;
