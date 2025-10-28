package org.example.seleniumspringjavacccstorengudiploma;

import io.github.bonigarcia.wdm.WebDriverManager;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.openqa.selenium.By.id;

public class AddToCartAndCheckout {
    public static void main(String[] args) {
        WebDriverManager.chromedriver().setup();
        WebDriver driver = new ChromeDriver();
        driver.manage().window().maximize();

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(130));

        try {
            // Открываем главную страницу
            driver.get("https://cccstore.ru/catalog/kubiki-rubika/7x7/");
           WebElement container = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("catalog-section_sub-products")));
            // Находим первый товар
            WebElement firstProduct = container.findElement(By.cssSelector("div.card_v2-product"));

            // Сохраняем название товара для проверки
            String productName = firstProduct.findElement(By.cssSelector("div.card_v2-product-name > a")).getText();
            assertFalse(productName.isEmpty(),"Название первого товара пустое");
            WebElement cartButton = firstProduct.findElement(By.id("bx_3966226736_1005_7e1b8e3524755c391129a9d7e6f2d206_buy_link"));
            cartButton.click();
            // Ждем, пока обновится счетчик товаров в шапке
            wait.until(ExpectedConditions.textToBePresentInElementLocated(By.className("header-center-basket-count"), "1"));

            // Находим и кликаем иконку корзины
            WebElement cartBtn = wait.until(ExpectedConditions.elementToBeClickable(id("basket-mini")));
            cartBtn.click();

            // Ждем открытия корзины (по CSS классам с точкой - т.к. в коде указано несколько классов одновременно)
            WebElement cartBody = wait.until(ExpectedConditions.visibilityOfElementLocated(By.cssSelector(".ccc-basket_mini.active")));
            WebElement cartList = cartBody.findElement(By.id("basket-items"));
            WebElement item = cartList.findElement(By.className("basket-item--name"));

            // Проверяем, что в корзине есть товар с ожидаемым названием
            boolean productInCart = item.getText().contains(productName);

            // Проверяем, что товар успешно добавлен в корзину
            assertTrue(productInCart,"Товар не найден в корзине");

            // Проверяем, что количество товара равно 1
            WebElement quantityField = cartBody.findElement(By.cssSelector(".basket-item--amount-control input"));
            String quantityValue = quantityField.getAttribute("value");
            assertEquals("1", quantityValue, "Некорректное количество товара в корзине");

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            driver.quit();
        }
    }
}
