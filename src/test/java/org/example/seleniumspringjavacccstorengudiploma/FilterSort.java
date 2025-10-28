package org.example.seleniumspringjavacccstorengudiploma;

import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertTrue;

public class FilterSort {
    public static void main(String[] args) {
        WebDriver driver = new ChromeDriver();
        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(10));
        driver.manage().window().maximize();
        try {
            driver.get("https://cccstore.ru/");
            // Ждем, пока появится кнопка закрытия модального окна
            WebElement closeButton = wait.until(ExpectedConditions.elementToBeClickable(By.cssSelector(".icon.g-geo-close")));
            // Кликаем по кнопке, закрывая модальное окно
            closeButton.click();
            WebElement catalogButton = driver.findElement(By.cssSelector(".header-pc_center-catalog_btn.cccstore-btn.red"));
            catalogButton.click();
            WebElement linkGolovolomki = driver.findElement(By.xpath("//*[@id=\"bx-html\"]/body/header/div/div[3]/div[2]/div[2]/div[1]/div[2]/a"));
            linkGolovolomki.click();
            WebElement allItems = driver.findElement(By.xpath("//*[@id=\"bx-html\"]/body/main/div[1]/div[4]/div/div[2]/div[2]/div[13]/a"));
            allItems.click();
            //
            WebElement sortCurrent = driver.findElement(By.className("catalog-section_sub-sorting-current"));
            sortCurrent.click();
            WebElement sortCheaper = driver.findElement(By.cssSelector("div.catalog-section_sub-sorting-item[data-sort='PRICE_MIN']"));
            sortCheaper.click();
            // Ждем обновления списка товаров после сортировки
            wait.until(ExpectedConditions.stalenessOf(driver.findElement(By.cssSelector(".card_v2-product"))));
            wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("catalog-section_sub-products")));
            // Сбор всех цен, акционных и обычных
            List<WebElement> priceElements1 = driver.findElements(By.cssSelector(
                    ".card_v2-product-price.style-redon, .card_v2-product-price"));
            List<Integer> pricesSorted1 = new ArrayList<>();
            for (WebElement priceEl : priceElements1) {
                String priceText = priceEl.getText();
                String digitsOnly = priceText.replaceAll("[^\\d]", "");
                if (!digitsOnly.isEmpty()) {
                    int price = Integer.parseInt(digitsOnly);
                    pricesSorted1.add(price);
                }
            }
            // проверка сортировки
            boolean isSorted = true;
            for (int i = 1; i < pricesSorted1.size(); i++) {
                if (pricesSorted1.get(i) < pricesSorted1.get(i - 1)) {
                    isSorted = false;
                    break;
                }
            }
            assertTrue(isSorted, "Ошибка сортировки");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        finally {
            driver.quit();
        }
    }
}

