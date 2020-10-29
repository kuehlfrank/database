import os
import requests 
import json
import time
import random
from selenium import webdriver
from selenium.webdriver.common.by import By

baseUrl = "https://www.rewe.de/restservices/recipe/search"
external_baseUrl = "https://www.rewe.de/rezepte"
pageQuery = "?pageNumber="

def getDriver():
    fp = webdriver.FirefoxProfile()
    fp.set_preference("devtools.jsonview.enabled", False)
    driver = webdriver.Firefox(firefox_profile=fp)
    return driver

def getJson(driver, url):
    driver.get(baseUrl)
    jsonText = driver.find_element_by_xpath("//pre").get_attribute("innerHTML")
    return json.loads(jsonText)

def getMeta(driver):
    data = getJson(driver, baseUrl)
    return data["meta"]

def getRecipes(driver, pageNumber):
    url = baseUrl + pageQuery + str(pageNumber)
    data = getJson(driver, url)
    return data["recipeTiles"]

def addRecipe(recipe):
    print("Adding \"" + recipe["title"] + "\"")
    driver.get("https://www.rewe.de/rezepte" + recipe["jcrPath"])
    if (not recipe["title"] in driver.title):
        print("failed to get",  recipe["title"])
        return
    quantity = driver.find_element_by_xpath("//span[contains(@class,'quantity-display')]").get_attribute("innerHTML")
    ingredients = list(map(lambda e: e.get_attribute("innerHTML"), driver.find_elements_by_xpath("//span[contains(@class,'ingredient-label-text')]")))
    external_img_url = recipe["image"]["smallest"]["url"]["url"]

    print(quantity)
    print(ingredients)

    return {
        "title": recipe["title"], 
        "external_id": recipe["jcrIdentifier"], 
        "external_source": "Rewe Rezepte", 
        "external_url": external_baseUrl + recipe["jcrPath"], 
        "external_img_url": external_img_url,
        "quantity": quantity, 
        "ingredients": ingredients
    }

def addPageRecipes(driver, pageRecipes):
    scrapedRecipes = []
    for recipe in pageRecipes:
        scrapedRecipe = addRecipe(recipe)
        if(scrapedRecipe):
            scrapedRecipes.append(scrapedRecipe)

        driver.delete_all_cookies()
        sleep_time = random.uniform(0.5,1)
        print("Sleeping for", sleep_time)
        time.sleep(sleep_time)
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

driver = getDriver()
meta = getMeta(driver)
print("Meta: ", meta)


pageNumbers = list(set(range(1, int(meta["pages"]) + 1)).difference(set([6,10,30,41,50,67,69,73,76,121,152,165])))
random.shuffle(pageNumbers)
for pageNumber in pageNumbers:
    print("Page", pageNumber)
    pageRecipes = getRecipes(driver, pageNumber)
    random.shuffle(pageRecipes)
    scrapedRecipes = addPageRecipes(driver, pageRecipes)
    saveResults(pageNumber, scrapedRecipes, "rewe")

driver.close()
driver.quit()


