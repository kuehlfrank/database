import psycopg2
import json

def getDbConnection():
    # Establish a connection to the database.
    conn = psycopg2.connect(database="kuehlfrank", 
                            user="kuehlfrank",
                            host="localhost",
                            password="VOUfsdHHdsZhGSS14PxurdT1u",
                            port="5432")
    return conn

def insertUnit(cur, unit):
    if unit and "label" in unit:
        cur.execute("INSERT INTO Unit (LABEL) Values (%(label)s) RETURNING UNIT_ID", unit)
        id_of_new_unit = cur.fetchone()[0]
        return id_of_new_unit
    else:
        print("Not inserting unit", unit)
        return None

def insertIngredient(cur, ingredient):
    if ingredient and "name" in ingredient and "common" in ingredient:
        cur.execute("INSERT INTO INGREDIENT (NAME, COMMON) Values (%(name)s, %(common)s) RETURNING INGREDIENT_ID", ingredient)
        id_of_new_ingredient = cur.fetchone()[0]
        return id_of_new_ingredient
    else:
        print("Not inserting ingredient", ingredient)
        return None

def insertRecipe(cur, recipe):
    if recipe and "title" in recipe and "ingredients" in recipe:
        cur.execute("INSERT INTO RECIPE (NAME, EXTERNAL_ID, EXTERNAL_SOURCE, EXTERNAL_URL, EXTERNAL_IMG_SRC_URL) Values (%(title)s, %(external_id)s, %(external_source)s, %(external_url)s, %(external_img_url)s) RETURNING RECIPE_ID", recipe)
        id_of_new_recipe = cur.fetchone()[0]
        for ingredient in recipe["ingredients"]:
            parameter = {
                "recipeid": id_of_new_recipe, 
                "ingredientid": ingredient["ingredientid"], 
                "amount": ingredient["amount"], 
                "unitid": ingredient["unitid"]
            }

            amountquery = (", AMOUNT", ", %(amount)s") if parameter["amount"] else ("", "")
            unitquery = (", UNIT_ID", ", %(unitid)s") if parameter["unitid"] else ("", "")
            cur.execute(f"INSERT INTO RECIPE_INGREDIENT (RECIPE_ID, INGREDIENT_ID{amountquery[0]}{unitquery[0]}) Values (%(recipeid)s, %(ingredientid)s{amountquery[1]}{unitquery[1]})", parameter)        
    else:
        print("Not inserting recipe", recipe)

def ensureUnitIDs(cur, recipe):
    unitlabels = set([ing["unit"] for ing in recipe["ingredients"]]).difference(set([None, ""]))
    for unitlabel in unitlabels:
        cur.execute("SELECT UNIT_ID FROM Unit WHERE LABEL=%(label)s", {"label": unitlabel})
        rows = cur.fetchall()
        unitid = rows[0][0] if rows else insertUnit(cur, {"label": unitlabel})
        
        # update all ingredients with this unit
        for ing in filter(lambda i: i["unit"] == unitlabel, recipe["ingredients"]):
            ing["unitid"] = unitid
    
    # set all other unitids to None
    for ing in filter(lambda i: "unitid" not in i, recipe["ingredients"]):
        ing["unitid"] = None

def ensureIngredientIDs(cur, recipe):
    ingredientNames = set([ing["name"] for ing in recipe["ingredients"]]).difference(set([None, ""]))
    for ingredientName in ingredientNames:
        cur.execute("SELECT INGREDIENT_ID FROM INGREDIENT WHERE NAME=%(name)s", {"name": ingredientName})
        rows = cur.fetchall()
        ingredientid = rows[0][0] if rows else insertIngredient(cur, {"name": ingredientName, "common": False})
        
        # update all ingredients with this unit
        for ing in filter(lambda i: i["name"] == ingredientName, recipe["ingredients"]):
            ing["ingredientid"] = ingredientid

    # set all other ingredientids to None
    for ing in filter(lambda i: "ingredientid" not in i, recipe["ingredients"]):
        ing["ingredientid"] = None

def addRecipe(dbconnection, recipe):
    try:
        print("Adding", recipe["title"])
        cur = dbconnection.cursor()
        ensureUnitIDs(cur, recipe)
        ensureIngredientIDs(cur, recipe)
        insertRecipe(cur, recipe)
        dbconnection.commit()
    except (Exception, psycopg2.DatabaseError) as error:
        print ("Error in transction Reverting all other operations of a transction ", error)
        dbconnection.rollback()

def addRecipes(dbconnection, recipes):
    for recipe in recipes:
        addRecipe(dbconnection, recipe)

def loadRecipesFromFile(file_path):
    with open(file_path, 'r', encoding='utf8') as json_file:
        return json.load(json_file)

recipes = loadRecipesFromFile('recipes/recipes.json.new')

conn = getDbConnection()

addRecipes(conn, recipes)

conn.close()