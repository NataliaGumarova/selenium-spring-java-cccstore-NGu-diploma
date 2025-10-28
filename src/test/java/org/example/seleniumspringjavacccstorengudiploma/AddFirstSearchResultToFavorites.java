package org.example.seleniumspringjavacccstorengudiploma;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;

import static org.junit.jupiter.api.Assertions.assertTrue;
import static org.openqa.selenium.By.id;
import static org.springframework.test.util.AssertionErrors.assertFalse;

public class AddFirstSearchResultToFavorites {
    public static void main(String[] args) {
        WebDriver driver = new ChromeDriver();
        driver.manage().window().maximize();
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(30));

        try {
            // Открываем главную страницу
            driver.get("https://cccstore.ru/");

            // Вводим в поиск "Скьюб"
            WebElement searchInput = wait.until(ExpectedConditions.elementToBeClickable(id("header-pc_center-search_input")));
            searchInput.sendKeys("скьюб");
            WebElement searchButton = driver.findElement(By.className("header-pc_center-search_submit"));
            searchButton.click();

            // Ждем и находим контейнер с результатами поиска
            WebElement resultsContainer = wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("catalog-section_sub-products")));

            // Находим первый товар
            WebElement firstProduct = resultsContainer.findElement(By.cssSelector("div.card_v2-product"));

            // Сохраняем название товара для проверки
            String productName = firstProduct.findElement(By.cssSelector("div.card_v2-product-name > a")).getText();
            System.out.println("Первый товар: " + productName);
            assertFalse("Название первого товара пустое", productName.isEmpty());

            // Находим кнопку "В избранное" у первого товара
            WebElement addToFavoritesButton = firstProduct.findElement(By.cssSelector(".icon.g-favorite-c_silver"));
            // Нажимаем кнопку "В избранное"
            addToFavoritesButton.click();

            // Ждём, пока обновляется счётчик товаров в шапке
            wait.until(ExpectedConditions.textToBePresentInElementLocated(By.className("header-pc_center-links-favorite_count"), "1"));

            // Открываем страницу избранного
            WebElement favoritesIcon = wait.until(ExpectedConditions.elementToBeClickable(By.xpath("//*[@id=\"bx-html\"]/body/header/div/div[2]/div[1]/div/div[4]/div[2]/a/div[2]")));
            favoritesIcon.click();

            // Ждем, пока откроется страница или окно избранного, и в блоке с товарами появится наш товар
            wait.until(ExpectedConditions.urlContains("favorite"));
            String currentUrl = driver.getCurrentUrl();
            assertTrue(currentUrl.contains("favorite"), "URL не содержит 'favorites', переход не выполнен");
            boolean productInFavorites = driver.findElements(By.cssSelector(".card_v2-product-name > a"))
                    .stream()
                    .anyMatch(el -> el.getText().contains(productName));

            assertTrue(productInFavorites, "Товар не найден в избранном");
            System.out.println("Товар успешно добавлен в избранное.");

        } catch (Exception e) {
            throw new RuntimeException(e);
        } finally {
            driver.quit();
        }
    }
}

