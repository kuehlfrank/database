import json
import uuid
import itertools
import time
import logging

logging.basicConfig(level=logging.WARNING) # set from WARNING to INFO for more output
MAX_VALUES_PER_INSERT = 1000

def insertUnitValues(sql, unit):
    if unit and "label" in unit:
        id_of_new_unit = str(uuid.uuid4())
        label = str(unit["label"])

        # (UNIT_ID, LABEL)
        sql.append(f"('{id_of_new_unit}', '{label}')")
        return id_of_new_unit
    else:
        logging.warning("Not inserting unit %s", json.dumps(unit))
        return None

def insertIngredientValues(sql, ingredient):
    if ingredient and "name" in ingredient and "common" in ingredient:
        id_of_new_ingredient = str(uuid.uuid4())
        name = str(ingredient["name"])
        common = str(ingredient["common"])

        # (INGREDIENT_ID, NAME, COMMON)
        sql.append(f"('{id_of_new_ingredient}','{name}',{common})")
        return id_of_new_ingredient
    else:
        logging.warning("Not inserting ingredient %s", json.dumps(ingredient))
        return None

def getAllIngredients(recipes):
    return itertools.chain.from_iterable(recipe["ingredients"] for recipe in recipes)

def insertUnitIDs(sql, recipes):
    print("processing units")
    # get unique units
    unitlabels = set([ing["unit"] for recipe in recipes for ing in recipe["ingredients"]]).difference(set([None, ""]))
    for unitlabel in unitlabels:
        logging.info("processing unit %s", unitlabel)
        unitid = insertUnitValues(sql, {"label": unitlabel})
        
        # update all ingredients with this unit
        for ing in filter(lambda i: i["unit"] == unitlabel, getAllIngredients(recipes)):
            ing["unitid"] = unitid
    
    print("processing ingredients without unit")
    for ing in filter(lambda i: "unitid" not in i, getAllIngredients(recipes)):
        ing["unitid"] = None

def insertIngredientIDs(sql, recipes):
    print("processing ingredients")
    # get unique ingredients
    ingredientNames = set([ing["name"] for recipe in recipes for ing in recipe["ingredients"]]).difference(set([None, ""]))
    for ingredientName in ingredientNames:
        logging.info("processing ingredient %s", ingredientName)
        ingredientid = insertIngredientValues(sql, {"name": ingredientName, "common": False})
        
        # update all ingredients with this id
        for ing in filter(lambda i: i["name"] == ingredientName, getAllIngredients(recipes)):
            ing["ingredientid"] = ingredientid

    print("processing ingredients without id")
    for ing in filter(lambda i: "ingredientid" not in i, getAllIngredients(recipes)):
        ing["ingredientid"] = None

def insertRecipes(sql, recipes):
    print("processing recipes")
    for recipe in recipes:
        logging.info("processing recipe %s", recipe["title"])
        if recipe and "title" in recipe and "title" in recipe and "external_id" in recipe and "external_source" in recipe and "external_url" in recipe and "external_img_url":
            id_of_new_recipe = str(uuid.uuid4())
            recipe["id"] = id_of_new_recipe
            title = str(recipe["title"])
            external_id = str(recipe["external_id"])
            external_source = str(recipe["external_source"])
            external_url = str(recipe["external_url"])
            external_img_url = str(recipe["external_img_url"])

            # (RECIPE_ID, NAME, EXTERNAL_ID, EXTERNAL_SOURCE, EXTERNAL_URL, EXTERNAL_IMG_SRC_URL)
            sql.append(f"('{id_of_new_recipe}', '{title}', '{external_id}', '{external_source}', '{external_url}', '{external_img_url}')")
        else:
            logging.warning("Not inserting recipe %s", json.dumps(recipe))

def insertRecipeIngredients(sql, recipes):
    print("processing recipe ingredients")
    for recipe in filter(lambda r: "id" in r, recipes): # insert only for those recipes that were inserted
        logging.info("processing ingredients of recipe %s", recipe["title"])
        for ingredient in recipe["ingredients"]:
            id_of_new_recipeingredient = str(uuid.uuid4())
            ingredient["id"] = id_of_new_recipeingredient
            recipeid = recipe["id"]
            ingredientid = ingredient["ingredientid"]
            amount = str(ingredient["amount"]) if ingredient["amount"] != None else "NULL"
            unitid = ("'" + str(ingredient["unitid"]) + "'") if ingredient["unitid"] else "NULL"

            # (RECIPE_INGREDIENT_ID, RECIPE_ID, INGREDIENT_ID, AMOUNT, UNIT_ID)
            values = f"('{id_of_new_recipeingredient}','{recipeid}','{ingredientid}',{amount},{unitid})"
            sql.append(values)

def mergeInserts(base_statement, values):
    text = ""
    # split values into buckets with max size of MAX_VALUES_PER_INSERT
    value_buckets = [values[i * MAX_VALUES_PER_INSERT:(i + 1) * MAX_VALUES_PER_INSERT] for i in range((len(values) + MAX_VALUES_PER_INSERT - 1) // MAX_VALUES_PER_INSERT )]
    for partial_values in value_buckets:
        text += base_statement
        text += ",".join(partial_values)
        text += ";\n"

    return text

def generate_sql_for_recipes(recipes):
    start = time.time()
    # collect all sql statements specific to a table
    sql = {
        "public.unit": [],
        "public.ingredient": [],
        "public.recipe": [],
        "public.recipe_ingredient": []
    }

    # populate dict for each table
    insertUnitIDs(sql["public.unit"], recipes)
    insertIngredientIDs(sql["public.ingredient"], recipes)
    saveToFile('recipies.json', json.dumps(recipes, indent=2))
    saveToFile('recipe_ingredient.json', json.dumps(recipes, indent=2))

    # merge everything together to one text statement
    sql_text = "BEGIN TRANSACTION;\n"
    sql_text += mergeInserts("INSERT INTO Unit (UNIT_ID, LABEL) Values ", sql["public.unit"]) + "\n"
    sql_text += mergeInserts("INSERT INTO INGREDIENT (INGREDIENT_ID, NAME, COMMON) Values ", sql["public.ingredient"]) + "\n"
    sql_text += mergeInserts("INSERT INTO RECIPE (RECIPE_ID, NAME, EXTERNAL_ID, EXTERNAL_SOURCE, EXTERNAL_URL, EXTERNAL_IMG_SRC_URL) Values ", sql["public.recipe"]) + "\n"
    sql_text += mergeInserts("INSERT INTO RECIPE_INGREDIENT (RECIPE_INGREDIENT_ID, RECIPE_ID, INGREDIENT_ID, AMOUNT, UNIT_ID) Values ", sql["public.recipe_ingredient"]) + "\n"
    sql_text += "END TRANSACTION;\n"

    end = time.time()
    print("\n====== SQL Generation Statistics ======")
    for table in sql.keys():
        print("INSERTED into", table, "\t", len(sql[table]), "ROWS")
    print("Time elapsed", end-start, "s")
    return sql_text

def loadRecipesFromFile(file_path):
    with open(file_path, 'r', encoding='utf8') as json_file:
        return json.load(json_file)

def saveToFile(file_path, text):
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(text)

recipes = loadRecipesFromFile('apicrawler/recipes/recipes.json.new')
sql = generate_sql_for_recipes(recipes)
saveToFile('./scripts/2-testdata.sql', sql)