# Дипломная работа selenium-spring-java-cccstore-NGu-diploma

<p align="center"><a href="https://selenium.dev"><img src="https://selenium.dev/images/selenium_logo_square_green.png" width="100" alt="Selenium"/></a></p>

<p align="center"><b>All-in-one Browser Automation Framework:<br />Web Crawling / Scraping / Testing / Reporting</b></p>

<p align="center"><a href="https://www.selenium.dev/"><img src="https://img.shields.io/badge/docs-selenium.dev-11BBAA.svg" alt="SeleniumBase Docs"/></a></p>

[Selenium Server](https://www.selenium.dev/downloads/) поддерживает два набора команд одновременно - новая версия (`WebDriver`, `Google Chrome`) и старая версия (`Selenium RC`).

## Установка JDK версии 17

JDK (Java Development Kit) — это полноценный набор программного обеспечения для разработки на Java. В него входят JRE (время выполнения Java), компиляторы, такие инструменты, как JavaDoc и отладчик Java. Если вы просто планируете запускать программы Java, то достаточно установки JRE. Но если вы планируете программировать и создавать приложения на Java, вам необходим JDK.

Для установки JDK 17 выполните следующие шаги:

1. Скачайте Java Platform JDK 17 с официального сайта Oracle по ссылке [https://www.oracle.com/java/technologies/downloads/](https://www.oracle.com/java/technologies/downloads/).

2. Установите Java, выбирая параметры по умолчанию.

3. Настройте системную переменную окружения с именем `JAVA_HOME`:
   - Если у вас Windows, нажмите сочетание клавиш `Win+R`, введите `sysdm.cpl` и перейдите во вкладку "Дополнительно" → "Переменные среды".
   - Создайте новую переменную `JAVA_HOME` и присвойте ей значение — путь к папке, где установлена Java, например:  
   `C:\Program Files\Java\jdk-17.0.x_xx`.
   - Также добавьте в системную переменную `PATH` путь  
   `C:\Program Files\Java\jdk-17.0.x_xx\bin`.

4. Перезапустите командную строку (cmd) для применения новых переменных.

5. Проверьте успешную установку, выполнив в командной строке команды:  
   ```
   java –version
   ```
   ```
   javac –version
   ```
   Если версии отображаются без ошибок, значит Java установлена и настроена успешно.

Данная настройка является обязательной для разработки на Java 17, а также для запуска и компиляции приложений, написанных на этом языке.
