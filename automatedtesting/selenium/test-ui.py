# #!/usr/bin/env python
from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.common.by import By
import datetime

# Method to get the current timestamp - to track activity of the program
def get_ts():
    return datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S") + "\t"

def setup_chrome_driver():
    print(get_ts() + "Starting the browser...\nOpenning Chrome...")
    options = ChromeOptions()
    options.add_argument("--no-sandbox")
    options.add_argument("--headless")
    driver = webdriver.Chrome(options=options)
    #driver = webdriver.Chrome()
    return driver

# Method to test login page with given credential
def login (user, password, driver):
    print (get_ts() + 'Browser started successfully. Navigating to the demo page to login.')
    driver.get('https://www.saucedemo.com/')

    # login
    driver.find_element(By.CSS_SELECTOR, "input[id='user-name']").send_keys(user)
    driver.find_element(By.CSS_SELECTOR, "input[id='password']").send_keys(password)
    driver.find_element(By.ID, "login-button").click()

    assert "https://www.saucedemo.com/inventory.html" in driver.current_url

    product_label = driver.find_element(By.CSS_SELECTOR, "div.header_secondary_container > span.title").text
    assert "Products" in product_label
    print(get_ts() + 'Login successfully as {user}.')

# Method to add all items to cart and verify the result
def addItem(driver, itemsAdded):
    print(get_ts() + "Start test adding item to cart")
    itemList = driver.find_elements(By.CSS_SELECTOR, '.inventory_item')

    for i in range(0, len(itemList)):
        item = itemList[i]

        itemName = item.find_element(By.CLASS_NAME, 'inventory_item_name').text
        print(get_ts() + "Add item: {}".format(itemName))
        button = item.find_element(By.CSS_SELECTOR, '.pricebar > button')
        button.click()

    totalCartItems = driver.find_element(By.CLASS_NAME, 'shopping_cart_badge').text

    print(get_ts() + "Total tested item added to cart: {}".format(itemsAdded))
    print(get_ts() + "Total item added to cart: {}".format(totalCartItems))
    assert itemsAdded == totalCartItems, "Total added item on cart not matched"

    print(get_ts() + "Add items to cart completed!")

# Method to remove all items to cart and verify the result
def removeItem(driver, modifiedItems):
    print(get_ts() + "Start testing remove item from the cart")

    itemList = driver.find_elements(By.CSS_SELECTOR, '.cart_item')

    for i in range(0, len(itemList)):
        item = itemList[i]

        itemName = item.find_element(By.CLASS_NAME, 'inventory_item_name').text
        print(get_ts() + "Remove item: {} from cart".format(itemName))
        button = item.find_element(By.CSS_SELECTOR, '.item_pricebar > button')
        button.click()

    totalItemOnCartLabel = driver.find_element( By.CLASS_NAME, 'shopping_cart_link').text

    print(get_ts() +"Total items removed from cart: {}".format(modifiedItems))
    assert "" == totalItemOnCartLabel, "Yeah, we should have a empty cart"

    print(get_ts() + "All items have removed from cart")

if __name__ == "__main__":
    driver = setup_chrome_driver()
    login('standard_user', 'secret_sauce', driver)
    modifiedItems = "6"
    addItem(driver, modifiedItems)
    removeItem(driver, modifiedItems)



