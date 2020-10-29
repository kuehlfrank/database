import os
import requests 
import json
import time
import random
import math

baseUrl = "https://www.edeka.de/rezepte/rezept/suche"
external_baseUrl = "https://www.edeka.de"
resultsPerPage = 50
pageQuery = f"?size={resultsPerPage}&page="

def getJson(url):
    jsonText = requests.get(url).json()
    return jsonText

def getMeta():
    data = getJson(baseUrl)
    return {
        "totalCount": int(data["totalCount"]),
        "pages": math.ceil(int(data["totalCount"]) / resultsPerPage)
    }

def getRecipes(pageNumber):
    url = baseUrl + pageQuery + str(pageNumber)
    data = getJson(url)
    return data["recipes"]

def getAllIngredients(recipe):
    ingredients_map = {}
    for ingredientGroup in recipe["ingredientGroups"]:
        for ingredientGroupIngredient in ingredientGroup["ingredientGroupIngredients"]:
            ingredient = ingredientGroupIngredient["ingredient"]
            quantity = ingredientGroupIngredient["quantity"]
            unit = ingredientGroupIngredient["unit"]
            if ingredient in ingredients_map and ingredients_map[ingredient]["unit"] == unit and quantity:
                if ingredients_map[ingredient]["quantity"] is float:
                    ingredients_map[ingredient]["quantity"] += float(quantity)
                else:
                    ingredients_map[ingredient]["quantity"] = float(quantity)
            else:
                ingredients_map[ingredient] = {
                    "quantity": quantity,
                    "unit": unit
                }
    ingredients = []
    for k,v in ingredients_map.items():
        ingredient = k
        quantity = v["quantity"]
        unit = v["unit"]
        ingredients.append(f"{quantity} {unit} {ingredient}")

    return ingredients

def addRecipe(recipe):
    print("Adding \"" + recipe["title"] + "\"")
    quantity = str(recipe["servings"]) + " Portionen"

    ingredients = getAllIngredients(recipe)
    external_img_url = recipe["media"]["images"]["ratio_1:1"]["url"]["mediumLarge"]

    print(quantity)
    print(ingredients)

    return {
        "title": recipe["title"], 
        "external_id": recipe["recipeReference"], 
        "external_source": "Edeka Rezepte", 
        "external_url": external_baseUrl + recipe["uri"], 
        "external_img_url": external_img_url,
        "quantity": quantity, 
        "ingredients": ingredients
    }

def addPageRecipes(pageRecipes):
    scrapedRecipes = []
    for recipe in pageRecipes:
        scrapedRecipe = addRecipe(recipe)
        if(scrapedRecipe):
            scrapedRecipes.append(scrapedRecipe)
    return scrapedRecipes

def saveResults(pageNumber, recipes, prefix):
    if not os.path.exists('recipes'):
        os.makedirs('recipes')
    with open(f"recipes/{prefix}_recipes_{pageNumber}.json", "w", encoding='utf8') as f: 
        f.write(json.dumps(recipes)) 

    if not os.path.exists('ingredients'):
        os.makedirs('ingredients')
    allingredients = list(set([ingredient for l in list(map(lambda i: i["ingredients"], recipes)) for ingredient in l]))
    with open(f"ingredients/{prefix}_ingredients_{pageNumber}.txt", "w", encoding='utf8') as f: 
        f.write("\n".join(allingredients)) 

    if not os.path.exists('quantities'):
        os.makedirs('quantities')
    allquantities = list(set(map(lambda i: i["quantity"], recipes)))
    with open(f"quantities/{prefix}_quantities_{pageNumber}.txt", "w", encoding='utf8') as f: 
        f.write("\n".join(allquantities))

meta = getMeta()
print("Meta: ", meta)

pageNumbers = list(set(range(1, int(meta["pages"]) + 1)).difference(set([])))
for pageNumber in pageNumbers:
    print("Page", pageNumber)
    pageRecipes = getRecipes(pageNumber)
    scrapedRecipes = addPageRecipes(pageRecipes)
    saveResults(pageNumber, scrapedRecipes, "edeka")


