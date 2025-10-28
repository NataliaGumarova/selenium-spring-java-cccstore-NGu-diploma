package org.example.seleniumspringjavacccstorengudiploma;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.*;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import java.io.IOException;
import java.time.Duration;

public class Registration {
    public static void main(String[] args) throws IOException {
        WebDriverManager.chromedriver().setup();
        WebDriver driver = new ChromeDriver();
        driver.manage().window().maximize();

        WebDriverWait wait = new WebDriverWait(driver, Duration.ofSeconds(30));

        driver.get("https://cccstore.ru/");
        // На главной странице находим и нажимаем кнопку "Войти"
        WebElement loginButton = driver.findElement(By.className("header-pc_center-links-item-text"));
        loginButton.click();

        // Ждем, что модальное окно с формой станет видимым
        WebElement modal = wait.until(ExpectedConditions.visibilityOfElementLocated(By.id("SystemAuth")));


        // Внутри модального окна есть вкладки/ссылки - т.к. форма регистрации открывается отдельно, кликнем на нужную вкладку
        WebElement regTab = driver.findElement(By.className("register-btn"));
        regTab.click();

        // Заполняем поля регистрации
        WebElement email= wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("REGISTER[LOGIN]")));

        email.sendKeys("testuser123@gmail.com");

        WebElement password = wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("REGISTER[PASSWORD]")));
        password.sendKeys("StrongPass!123");

        WebElement confirmPassword = wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("REGISTER[CONFIRM_PASSWORD]")));
        confirmPassword.sendKeys("StrongPass!123");

        WebElement name = wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("REGISTER[NAME]")));
        name.sendKeys("Anna");

        // находим чек боксы и кликаем по ним
        WebElement newsletterLabel = driver.findElement(By.cssSelector("label[for='UF_SUBSCRIBED_BOQWLQ']"));
        // делаем скролл вниз для отображения чек-боксов
        ((JavascriptExecutor) driver).executeScript("arguments[0].scrollIntoView({block: 'center'});", newsletterLabel);
        newsletterLabel.click();
        WebElement acceptRulesCheckbox = driver.findElement(By.id("ACCEPT_REG_TEXT_CKTZPX"));
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("arguments[0].click();", acceptRulesCheckbox);


        // Нажимаем кнопку "Зарегистрироваться"
        WebElement submitButton = wait.until(ExpectedConditions.visibilityOfElementLocated(By.name("submit")));
        submitButton.click();
        // Ждем появления ошибки капчи
        WebElement errorElement = wait.until(ExpectedConditions.visibilityOfElementLocated(By.xpath("//*[@id=\"SystemReg\"]/div[2]/div/form/div[11]")));
        String errorText = errorElement.getText();
        // вывод текста ошибки
        System.out.println(errorText);
        if (errorElement.getText().contains("Верификация reCaptcha не пройдена") | errorText.contains("Нет данных от reCaptcha")) {
            System.out.println("Капча не пройдена, тест считается успешно остановленным.");
        } else {
            System.out.println("Ошибка капчи не найдена.");
        }
        driver.quit();
    }
}
