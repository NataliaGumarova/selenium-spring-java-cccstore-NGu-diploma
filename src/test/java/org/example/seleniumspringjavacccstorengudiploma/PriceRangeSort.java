package org.example.seleniumspringjavacccstorengudiploma;

import static org.junit.jupiter.api.Assertions.assertTrue;
import org.openqa.selenium.By;
import org.openqa.selenium.JavascriptExecutor;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.time.Duration;
import java.util.ArrayList;
import java.util.List;

public class PriceRangeSort {
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

            // Применим фильтр по цене (например,от 800 до 1000 руб)
            WebElement minPriceInput = driver.findElement(By.id("arrFilter_P1_MIN"));
            minPriceInput.clear();
            minPriceInput.sendKeys("800");
            WebElement maxPriceInput = driver.findElement(By.id("arrFilter_P1_MAX"));
            maxPriceInput.clear();
            maxPriceInput.sendKeys("1000");
            JavascriptExecutor js = (JavascriptExecutor) driver;
            js.executeScript("window.scrollTo(0, 0);");

            wait.until(ExpectedConditions.stalenessOf(driver.findElement(By.cssSelector(".card_v2-product"))));
            wait.until(ExpectedConditions.visibilityOfElementLocated(By.className("catalog-section_sub-products")));
            // Получаем список всех цен (акционные и обычные)
            List<WebElement> pricesElements = driver.findElements(By.cssSelector(".card_v2-product-price.style-redon, .card_v2-product-price"));
            List<Integer> priceProducts = new ArrayList<>();
            for (WebElement priceEl : pricesElements) {
                String priceText = priceEl.getText(); // пример: "408 ₽"
                String digitsOnly = priceText.replaceAll("[^\\d]", "");
                if (!digitsOnly.isEmpty()) {
                    int price = Integer.parseInt(digitsOnly);
                    priceProducts.add(price);
                }
            }
            boolean allInRange = priceProducts.stream().allMatch(p -> p >= 800 && p <= 1000);
            assertTrue(allInRange, "Есть товары с ценами вне диапазона 800-1000 рублей");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }  finally {
            if (driver != null) {
                driver.quit();
            }
        }
    }
}