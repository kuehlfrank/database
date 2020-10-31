DELETE FROM RECIPE r
USING UNIT u
LEFT JOIN recipe_ingredient ri ON ri.unit_id = u.unit_id
WHERE r.recipe_id IN (SELECT recipe_id FROM recipe_ingredient ri GROUP BY ri.recipe_id HAVING count(ri.recipe_id) < 3);

DELETE FROM RECIPE r
USING UNIT u
LEFT JOIN recipe_ingredient ri ON ri.unit_id = u.unit_id
WHERE r.recipe_id = ri.recipe_id
AND u.label IN ('Beet', 'Drittel', 'Innenpäckchen', 'Viertel', 'TestUnit', 'dünne', 'einige', 'etwas', 'ganze', 'geh', 'geha', 'gestr.', 'grosse', 'großer', 'großes', 'halbe', 'haselnussgroßes', 'kirschgroßes', 'kleine', 'kleines', 'mittelgroßes', 'mundgerechtes', 'walnussgroßes', 'mittelgroße');


DELETE FROM inventory_entry ie
USING UNIT u
WHERE ie.unit_id = u.unit_id
AND u.label IN ('Beet', 'Drittel', 'Innenpäckchen', 'Viertel', 'TestUnit', 'dünne', 'einige', 'etwas', 'ganze', 'geh', 'geha', 'gestr.', 'grosse', 'großer', 'großes', 'halbe', 'haselnussgroßes', 'kirschgroßes', 'kleine', 'kleines', 'mittelgroßes', 'mundgerechtes', 'walnussgroßes', 'mittelgroße');

/* UPDATE Blatt to Blätter */
UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Blätter')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Blatt';

/* UPDATE Dose to Dosen */
UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Dosen')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Dose';

/* UPDATE sg. to pl. */
UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Händevoll')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Handvoll';

/* UPDATE sg. to pl. */
UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Flaschen')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Flasche';

/* UPDATE sg. to pl. */
UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Gläser')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Glas';

UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Messerspitze')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Msp.';

UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Scheiben')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Scheibe';

UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Stiele')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Stiel';

UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Stück')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Stk.';

UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Köpfe')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Kopf';

UPDATE recipe_ingredient ri
SET unit_id = (SELECT u.unit_id FROM unit u
WHERE u.label = 'Zweige')
FROM unit u
WHERE u.unit_id = ri.unit_id
AND u.label = 'Zweig';

DELETE
FROM unit r
WHERE r.label IN ('Beet', 'Blatt', 'Dose', 'Handvoll', 'Flasche', 'Glas', 'Stiel', 'Scheibe', 'Stk.', 'TestUnit', 'Kopf', 'Viertel', 'Zweig', 'dünne', 'einige', 'etwas', 'ganze', 'geh', 'geha', 'gestr.', 'grosse', 'großer', 'großes', 'halbe', 'haselnussgroßes', 'kirschgroßes', 'kleine', 'kleines', 'mittelgroßes', 'mundgerechtes', 'walnussgroßes', 'mittelgroße');
