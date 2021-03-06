DROP TABLE IF EXISTS RECIPE CASCADE;
DROP TABLE IF EXISTS INGREDIENT_ALTERNATIVE_NAME CASCADE;
DROP TABLE IF EXISTS INGREDIENT CASCADE;
DROP TABLE IF EXISTS RECIPE_INGREDIENT CASCADE;
DROP TABLE IF EXISTS INVENTORY_ENTRY CASCADE;
DROP TABLE IF EXISTS INVENTORY CASCADE;
DROP TABLE IF EXISTS UNIT CASCADE;
DROP TABLE IF EXISTS KF_USER CASCADE;

DROP TRIGGER IF EXISTS update_timestamp_ingredient ON INGREDIENT;
DROP TRIGGER IF EXISTS update_timestamp_ingredient_alternative_name ON INGREDIENT_ALTERNATIVE_NAME;
DROP TRIGGER IF EXISTS update_timestamp_inventory ON INVENTORY;
DROP TRIGGER IF EXISTS update_timestamp_inventory_entry ON INVENTORY_ENTRY;
DROP TRIGGER IF EXISTS update_timestamp_kf_user ON KF_USER;
DROP TRIGGER IF EXISTS update_timestamp_recipe ON RECIPE;
DROP TRIGGER IF EXISTS update_timestamp_recipe_ingredient ON RECIPE_INGREDIENT;
DROP TRIGGER IF EXISTS update_timestamp_unit ON UNIT;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

CREATE OR REPLACE FUNCTION trigger_set_timestamp()
RETURNS TRIGGER AS $$
BEGIN
  NEW.UPDATED_AT = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE UNIT
(
    UNIT_ID UUID NOT NULL DEFAULT uuid_generate_v4(),
    LABEL VARCHAR(23) UNIQUE NOT NULL,
    CREATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    UPDATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (UNIT_ID)
);

CREATE TABLE RECIPE
(
    RECIPE_ID UUID NOT NULL DEFAULT uuid_generate_v4(),
    EXTERNAL_ID VARCHAR(50) NULL,
    EXTERNAL_SOURCE VARCHAR(32) NULL,
    EXTERNAL_URL TEXT NULL,
    EXTERNAL_IMG_SRC_URL TEXT NULL,
    NAME VARCHAR(64) NOT NULL,
    CREATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    UPDATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (RECIPE_ID)
);

CREATE TABLE INGREDIENT
(
    INGREDIENT_ID UUID NOT NULL DEFAULT uuid_generate_v4(),
    NAME VARCHAR(128) UNIQUE NOT NULL,
    COMMON BOOLEAN NOT NULL,
    CREATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    UPDATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (INGREDIENT_ID)
);

CREATE TABLE INGREDIENT_ALTERNATIVE_NAME
(
    INGREDIENT_ALTERNATIVE_NAME_ID UUID NOT NULL DEFAULT uuid_generate_v4(),
    NAME VARCHAR(64) NOT NULL,
    INGREDIENT_ID UUID NOT NULL,
    CREATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    UPDATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (INGREDIENT_ID) REFERENCES INGREDIENT ON DELETE CASCADE,
    PRIMARY KEY (INGREDIENT_ALTERNATIVE_NAME_ID)
);

CREATE TABLE RECIPE_INGREDIENT
(
    RECIPE_INGREDIENT_ID UUID NOT NULL DEFAULT uuid_generate_v4(),
    RECIPE_ID UUID NOT NULL,
    INGREDIENT_ID UUID NOT NULL,
    AMOUNT NUMERIC(9, 3),
    UNIT_ID UUID,
    CREATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    UPDATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (INGREDIENT_ID) REFERENCES INGREDIENT ON DELETE RESTRICT,
    FOREIGN KEY (RECIPE_ID) REFERENCES RECIPE ON DELETE CASCADE,
    FOREIGN KEY (UNIT_ID) REFERENCES UNIT ON DELETE RESTRICT,
    PRIMARY KEY (RECIPE_INGREDIENT_ID),
    unique(RECIPE_ID,INGREDIENT_ID,UNIT_ID)
);

CREATE TABLE INVENTORY
(
    INVENTORY_ID UUID NOT NULL DEFAULT uuid_generate_v4(),
    CREATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    UPDATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (INVENTORY_ID)
);

CREATE TABLE INVENTORY_ENTRY
(
    INVENTORY_ENTRY_ID UUID NOT NULL DEFAULT uuid_generate_v4(),
    INVENTORY_ID UUID NOT NULL,
    INGREDIENT_ID UUID NOT NULL,
    AMOUNT NUMERIC(9, 3) NOT NULL,
    IMAGE_SRC_URL TEXT NULL,
    UNIT_ID UUID NOT NULL,
    CREATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    UPDATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (INVENTORY_ID) REFERENCES INVENTORY ON DELETE CASCADE,
    FOREIGN KEY (INGREDIENT_ID) REFERENCES INGREDIENT ON DELETE CASCADE,
    FOREIGN KEY (UNIT_ID) REFERENCES UNIT ON DELETE RESTRICT,
    PRIMARY KEY (INVENTORY_ENTRY_ID),
    unique (INVENTORY_ID, INGREDIENT_ID,UNIT_ID)
);
CREATE INDEX inventory_entry_idx_ingredient_id ON inventory_entry (ingredient_id); -- improves performance for suggested recipes

CREATE TABLE KF_USER
(
    USER_ID VARCHAR(50) NOT NULL,
    NAME VARCHAR(128) NOT NULL,
    INVENTORY_ID UUID NOT NULL,
    CREATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    UPDATED_AT TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (INVENTORY_ID) REFERENCES INVENTORY ON DELETE RESTRICT,
    PRIMARY KEY (USER_ID)
);
CREATE INDEX kf_user_idx_user_id_inventory_id ON kf_user (user_id,inventory_id); -- improves performance for suggested recipes

CREATE TRIGGER update_timestamp_ingredient
BEFORE UPDATE ON INGREDIENT
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER update_timestamp_ingredient_alternative_name
BEFORE UPDATE ON INGREDIENT_ALTERNATIVE_NAME
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER update_timestamp_inventory
BEFORE UPDATE ON INVENTORY
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER update_timestamp_inventory_entry
BEFORE UPDATE ON INVENTORY_ENTRY
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER update_timestamp_kf_user
BEFORE UPDATE ON KF_USER
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER update_timestamp_recipe
BEFORE UPDATE ON RECIPE
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER update_timestamp_recipe_ingredient
BEFORE UPDATE ON RECIPE_INGREDIENT
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();

CREATE TRIGGER update_timestamp_unit
BEFORE UPDATE ON UNIT
FOR EACH ROW
EXECUTE PROCEDURE trigger_set_timestamp();
