
CREATE DATABASE [CCCStore_NGu]
ON PRIMARY
(name='CCCStore_NGu', filename='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\CCCStore_NGu.mdf',size=10mb, maxsize=400mb, filegrowth=10%)log on
(name='CCCStoreLog_NGu', filename='C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\DATA\CCCStoreLog_NGu.ldf',size =1mb, maxsize=100mb, filegrowth=10%);
GO

USE [CCCStore_NGu]
GO
--1 список зарегистрированных клиентов
CREATE TABLE Users
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(100) NOT NULL CHECK(Name != ''),
 Surname NVARCHAR(100) NOT NULL CHECK(Surname != ''),
 Email NVARCHAR(255) UNIQUE NOT NULL CHECK(Email != ''),
 Phone NVARCHAR(50) UNIQUE NOT NULL CHECK(Phone != ''),
 PasswordHash NVARCHAR(MAX) NOT NULL CHECK(PasswordHash != ''),
 RegistrationDate DATE NOT NULL DEFAULT GETDATE(),
 NewsletterConsent BIT NOT NULL DEFAULT 0,
 NewsletterConsentDate DATE NOT NULL DEFAULT GETDATE(),
 NewsletterRevokeDate DATE
);
--2 список ролей клиентов(опт, розница и т.д.)
CREATE TABLE OrderRoles
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(50) NOT NULL CHECK(Name != ''),
 MinSumm MONEY NOT NULL CHECK(MinSumm >= 0)
);
--3 список статусов заказа
CREATE TABLE OrderStatus
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(50) NOT NULL CHECK(Name != '')
);
--4 список статусов отзыва
CREATE TABLE ReviewStatus
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(50) NOT NULL CHECK(Name != '')
);
--5 список компаний-партнёров
CREATE TABLE Partners
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(255) NOT NULL CHECK(Name != ''),
 Type NVARCHAR(255) NOT NULL CHECK(Type != ''),
 Phone NVARCHAR(50) NOT NULL CHECK(Phone != ''),
 Email NVARCHAR(255) NOT NULL CHECK(Email != '')
);
--6 список брендов
CREATE TABLE Brands
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(255) NOT NULL CHECK(Name != ''),
 PartnerId INT NOT NULL CONSTRAINT FK_01 FOREIGN KEY(PartnerId) REFERENCES Partners(Id)
);
--7 список вариантов доставки
CREATE TABLE DeliveryType
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(50) NOT NULL CHECK(Name != '')
);
--8 список ПВЗ
CREATE TABLE PickupPoints
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(255) NOT NULL CHECK(Name != ''),
 Address NVARCHAR(MAX) NOT NULL CHECK(Address != ''),
 WorkingHours NVARCHAR(255) NOT NULL CHECK(WorkingHours != ''),
 PartnerId INT NOT NULL CONSTRAINT FK_02 FOREIGN KEY(PartnerId) REFERENCES Partners(Id)
);
--9 список методов оплаты
CREATE TABLE PaymentMethods
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(255) NOT NULL CHECK(Name != '')
);
--10 список категорий товара
CREATE TABLE Categories
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(255) NOT NULL CHECK(Name != ''),
 ParentCategoryId INT CONSTRAINT FK_03 FOREIGN KEY(ParentCategoryId) REFERENCES Categories(Id)
);
--11 список товаров
CREATE TABLE Products
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(255) NOT NULL CHECK(Name != ''),
 ShortDescription NVARCHAR(500),
 CategoryId INT NOT NULL CONSTRAINT FK_04 FOREIGN KEY(CategoryId) REFERENCES Categories(Id),
 BrandId INT NOT NULL CONSTRAINT FK_05 FOREIGN KEY(BrandId) REFERENCES Brands(Id),
 RetailPrice MONEY NOT NULL CHECK(RetailPrice > 0),
 PromoPrice MONEY DEFAULT NULL,
 SmallWholesalePrice MONEY NOT NULL CHECK(SmallWholesalePrice > 0),
 MediumWholesalePrice MONEY NOT NULL CHECK(MediumWholesalePrice > 0),
 LargeWholesalePrice MONEY NOT NULL CHECK(LargeWholesalePrice > 0),
 StockWarehouse INT NOT NULL DEFAULT 0,
 StockStore INT NOT NULL DEFAULT 0,
 CreatedAt DATE NOT NULL DEFAULT GETDATE(),
 UpdatedAt DATE
);
--12 список изображений/видео товара
CREATE TABLE ProductImages
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 ProductId INT NOT NULL CONSTRAINT FK_06 FOREIGN KEY(ProductId) REFERENCES Products(Id),
 Url NVARCHAR(MAX) NOT NULL CHECK(Url != '')
);
--13 список полных описаний товаров
CREATE TABLE ProductDescriptions
(
 Id INT IDENTITY(1,1) PRIMARY KEY,
 ProductId INT NOT NULL CONSTRAINT FK_07 FOREIGN KEY(ProductId) REFERENCES Products(Id),
 FullDescription NVARCHAR(MAX) NOT NULL,
 CreatedAt DATE NOT NULL DEFAULT GETDATE(),
 UpdatedAt DATE
);
--14 список отзывов
CREATE TABLE Reviews
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 ProductId INT NOT NULL CONSTRAINT FK_08 FOREIGN KEY(ProductId) REFERENCES Products(Id),
 UserId INT NOT NULL CONSTRAINT FK_09 FOREIGN KEY(UserId) REFERENCES Users(Id),
 ReviewDate DATE NOT NULL DEFAULT GETDATE(),
 Rating INT NOT NULL CHECK(Rating BETWEEN 1 AND 5),
 Text NVARCHAR(MAX),
 StatusId INT NOT NULL CONSTRAINT FK_10 FOREIGN KEY(StatusId) REFERENCES ReviewStatus(Id)
);
--15 список промоакций
CREATE TABLE Promotions
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 Name NVARCHAR(255) NOT NULL CHECK(Name != ''),
 Description NVARCHAR(MAX),
 DiscountPercent INT NOT NULL DEFAULT 0 CHECK(DiscountPercent >= 0),
 StartDate DATE NOT NULL DEFAULT GETDATE(),
 EndDate DATE NOT NULL
);
--16 связь товаров и акций - список акционных товаров/категорий
CREATE TABLE ProductPromotions
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 ProductId INT CONSTRAINT FK_21 FOREIGN KEY(ProductId) REFERENCES Products(Id),
 CategoryId INT CONSTRAINT FK_22 FOREIGN KEY(CategoryId) REFERENCES Categories(Id),
 PromotionId INT NOT NULL CONSTRAINT FK_23 FOREIGN KEY(PromotionId) REFERENCES Promotions(Id)
);
--17 список заказов
CREATE TABLE Orders
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 UserId INT CONSTRAINT FK_11 FOREIGN KEY REFERENCES Users(Id),
 CustomerName NVARCHAR(255),
 CustomerSurname NVARCHAR(255),
 CustomerPhone NVARCHAR(50),
 CustomerEmail NVARCHAR(255),
 OrderDate DATE NOT NULL DEFAULT GETDATE(),
 StatusId INT NOT NULL CONSTRAINT FK_12 FOREIGN KEY(StatusId) REFERENCES OrderStatus(Id),
 TotalAmount MONEY,
 OrderRoleId INT CONSTRAINT FK_13 FOREIGN KEY REFERENCES OrderRoles(Id),
 PaymentMethodId INT NOT NULL CONSTRAINT FK_14 FOREIGN KEY(PaymentMethodId) REFERENCES PaymentMethods(Id),
 PaymentStatus BIT NOT NULL DEFAULT 0,
 DeliveryTypeId INT NOT NULL CONSTRAINT FK_15 FOREIGN KEY(DeliveryTypeId) REFERENCES DeliveryType(Id),
 PickupPointId INT CONSTRAINT FK_16 FOREIGN KEY(PickupPointId) REFERENCES PickupPoints(Id),
 DeliveryAddress NVARCHAR(MAX)
);
--18 список позиций в заказе
CREATE TABLE OrderItems
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 OrderId INT NOT NULL CONSTRAINT FK_17 FOREIGN KEY(OrderId) REFERENCES Orders(Id),
 ProductId INT NOT NULL CONSTRAINT FK_18 FOREIGN KEY(ProductId) REFERENCES Products(Id),
 Quantity INT NOT NULL CHECK(Quantity >= 0),
 Price MONEY
);
--19 список изменённых статусов заказа
CREATE TABLE OrderStatusHistory
(
 Id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
 OrderId INT NOT NULL CONSTRAINT FK_19 FOREIGN KEY(OrderId) REFERENCES Orders(Id),
 StatusId INT NOT NULL CONSTRAINT FK_20 FOREIGN KEY(StatusId) REFERENCES OrderStatus(Id),
 ChangedAt DATE DEFAULT GETDATE()
);
GO
-- процедура - проверка наличия действующих акций, расчёт акционной цены и заполнение столбца PromoPrices
CREATE OR ALTER PROCEDURE UpdatePromoPricesWithMaxDiscount
    @CategoryId INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    EXEC sp_set_session_context @key = N'AllowPromoPriceUpdate', @value = 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @CategoryList TABLE (Id INT PRIMARY KEY);

        IF @CategoryId IS NOT NULL
        BEGIN
            WITH RecursiveCategories AS (
                SELECT Id FROM Categories WHERE Id = @CategoryId
                UNION ALL
                SELECT c.Id FROM Categories c JOIN RecursiveCategories rc ON c.ParentCategoryId = rc.Id
            )
            INSERT INTO @CategoryList SELECT Id FROM RecursiveCategories;
        END
        ELSE
            INSERT INTO @CategoryList SELECT Id FROM Categories;

        -- Сброс promoцен для неакционных товаров
        UPDATE Products
        SET PromoPrice = NULL,
            UpdatedAt = GETDATE()
        WHERE CategoryId IN (SELECT Id FROM @CategoryList)
          AND NOT EXISTS (
              SELECT 1
              FROM ProductPromotions pp
              JOIN Promotions pr ON pr.Id = pp.PromotionId
              WHERE GETDATE() BETWEEN pr.StartDate AND pr.EndDate
                AND (
                    (pp.ProductId = Products.Id)
                    OR (pp.CategoryId IS NOT NULL AND pp.CategoryId IN (SELECT Id FROM @CategoryList))
                )
          );

        ;WITH DiscountCandidates AS (
            SELECT pp.ProductId, pr.DiscountPercent
            FROM ProductPromotions pp
            JOIN Promotions pr ON pr.Id = pp.PromotionId
            WHERE pr.DiscountPercent > 0 AND GETDATE() BETWEEN pr.StartDate AND pr.EndDate

            UNION ALL

            SELECT p.Id AS ProductId, pr.DiscountPercent
            FROM Products p
            JOIN ProductPromotions pp ON pp.CategoryId = p.CategoryId
            JOIN Promotions pr ON pr.Id = pp.PromotionId
            WHERE pr.DiscountPercent > 0 AND GETDATE() BETWEEN pr.StartDate AND pr.EndDate
              AND p.CategoryId IN (SELECT Id FROM @CategoryList)
        ),
        MaxDiscountPerProduct AS (
            SELECT ProductId, MAX(DiscountPercent) AS MaxDiscount
            FROM DiscountCandidates
            GROUP BY ProductId
        )
        UPDATE p
        SET PromoPrice = ROUND(p.RetailPrice * (1 - md.MaxDiscount / 100.0), 0),
            UpdatedAt = GETDATE()
        FROM Products p
        INNER JOIN MaxDiscountPerProduct md ON p.Id = md.ProductId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Ошибка в UpdatePromoPricesWithMaxDiscount: %s', 16, 1, @ErrorMessage);
    END CATCH

    EXEC sp_set_session_context @key = N'AllowPromoPriceUpdate', @value = NULL;
END;

GO

 -- Процедура - определение роли клиента и расчёт суммы заказа с учётом роли

CREATE OR ALTER PROCEDURE CalculateOrderSummaryAndRoles
    @OrderId INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    EXEC sp_set_session_context @key = N'AllowOrderUpdate', @value = 1;

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @TotalOrderSum MONEY = 0;
        DECLARE @OrderRoleId INT;

        -- Переменные для ролей
        DECLARE @RetailPriceId INT;
        DECLARE @SmallWholesalePriceId INT;
        DECLARE @MediumWholesalePriceId INT;
        DECLARE @LargeWholesalePriceId INT;

        -- Получаем Id ролей один раз
        SELECT TOP 1 @RetailPriceId = Id FROM OrderRoles WHERE Name = 'RetailPrice';
        SELECT TOP 1 @SmallWholesalePriceId = Id FROM OrderRoles WHERE Name = 'SmallWholesalePrice';
        SELECT TOP 1 @MediumWholesalePriceId = Id FROM OrderRoles WHERE Name = 'MediumWholesalePrice';
        SELECT TOP 1 @LargeWholesalePriceId = Id FROM OrderRoles WHERE Name = 'LargeWholesalePrice';


        -- Рассчёт суммы заказа с учётом промоцен
        SELECT @TotalOrderSum = SUM(oi.Quantity *
            CASE
                WHEN p.PromoPrice IS NOT NULL AND p.PromoPrice > 0 AND p.PromoPrice < p.RetailPrice
                    THEN p.PromoPrice
                ELSE
                    p.RetailPrice
            END)
        FROM OrderItems oi
        JOIN Products p ON oi.ProductId = p.Id
        WHERE oi.OrderId = @OrderId;

        -- Определяем роль заказа
        SELECT TOP 1 @OrderRoleId = Id
        FROM OrderRoles
        WHERE MinSumm <= ISNULL(@TotalOrderSum, 0)
        ORDER BY MinSumm DESC;

        IF @OrderRoleId IS NULL
            SELECT TOP 1 @OrderRoleId = Id FROM OrderRoles ORDER BY MinSumm ASC;

        -- Обновление цен позиций заказа
        UPDATE oi
        SET Price =
            CASE 
                WHEN @OrderRoleId = @RetailPriceId THEN ISNULL(NULLIF(p.PromoPrice, 0), p.RetailPrice)
                WHEN @OrderRoleId = @SmallWholesalePriceId THEN
                    CASE WHEN p.PromoPrice IS NOT NULL AND p.PromoPrice > 0 AND p.PromoPrice < p.SmallWholesalePrice
                         THEN p.PromoPrice ELSE p.SmallWholesalePrice END
                WHEN @OrderRoleId = @MediumWholesalePriceId THEN
                    CASE WHEN p.PromoPrice IS NOT NULL AND p.PromoPrice > 0 AND p.PromoPrice < p.MediumWholesalePrice
                         THEN p.PromoPrice ELSE p.MediumWholesalePrice END
                WHEN @OrderRoleId = @LargeWholesalePriceId THEN
                    CASE WHEN p.PromoPrice IS NOT NULL AND p.PromoPrice > 0 AND p.PromoPrice < p.LargeWholesalePrice
                         THEN p.PromoPrice ELSE p.LargeWholesalePrice END
                ELSE ISNULL(NULLIF(p.PromoPrice, 0), p.RetailPrice)
            END
        FROM OrderItems oi
        JOIN Products p ON oi.ProductId = p.Id
        WHERE oi.OrderId = @OrderId;

        -- Пересчёт итоговой суммы с новыми ценами
        SELECT @TotalOrderSum = SUM(Quantity * Price)
        FROM OrderItems
        WHERE OrderId = @OrderId;

        -- Обновление заказа
        UPDATE Orders
        SET TotalAmount = ISNULL(@TotalOrderSum, 0),
            OrderRoleId = @OrderRoleId
        WHERE Id = @OrderId;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Ошибка в CalculateOrderSummaryAndRoles: %s', 16, 1, @ErrorMessage);
    END CATCH;

    EXEC sp_set_session_context @key = N'AllowOrderUpdate', @value = NULL;
END;
GO

-- триггер - контроль изменения PromoPrice
CREATE OR ALTER TRIGGER TrgPreventManualPromoPriceUpdate
ON Products
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AllowPromoPriceUpdate BIT = CAST(SESSION_CONTEXT(N'AllowPromoPriceUpdate') AS BIT);

    IF @AllowPromoPriceUpdate IS NULL OR @AllowPromoPriceUpdate = 0
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN deleted d ON i.Id = d.Id
            WHERE ISNULL(i.PromoPrice, -1) <> ISNULL(d.PromoPrice, -1)
        )
        BEGIN
            RAISERROR('Ручное изменение поля PromoPrice запрещено.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
    END;
END;

GO
-- триггер - контроль изменения OrderItems
CREATE OR ALTER TRIGGER TrgOrderItemsAfterChange
ON OrderItems
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    -- Защита от рекурсии вызова процедуры из триггера
    DECLARE @AllowProcedureRun BIT = CAST(SESSION_CONTEXT(N'AllowOrderUpdateProcedureRun') AS BIT);

    IF @AllowProcedureRun = 1
    BEGIN
        -- Если флаг установлен, значит процедура уже вызвана этим триггером, выходим
        RETURN;
    END

    BEGIN TRY
        BEGIN TRANSACTION;

        DECLARE @AllowUpdate BIT = CAST(SESSION_CONTEXT(N'AllowOrderUpdate') AS BIT);

        IF @AllowUpdate IS NULL OR @AllowUpdate = 0
        BEGIN
            -- Запрет ручного изменения цены
            IF EXISTS (
                SELECT 1
                FROM inserted i
                JOIN deleted d ON i.Id = d.Id
                WHERE ISNULL(i.Price, -1) <> ISNULL(d.Price, -1)
            )
            BEGIN
                RAISERROR('Ручное изменение цены запрещено.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END;

            -- Запрет ручного изменения количества без вызова процедуры
            IF EXISTS (
                SELECT 1
                FROM inserted i
                JOIN deleted d ON i.Id = d.Id
                WHERE ISNULL(i.Quantity, -1) <> ISNULL(d.Quantity, -1)
            )
            BEGIN
                RAISERROR('Ручное изменение количества запрещено без вызова процедуры.', 16, 1);
                ROLLBACK TRANSACTION;
                RETURN;
            END;
        END;

        -- Устанавливаем флаг, что сейчас запускаем процедуру, чтобы избежать рекурсии
        EXEC sp_set_session_context @key = N'AllowOrderUpdateProcedureRun', @value = 1;

        -- Для каждого уникального OrderId из изменённых строк вызываем процедуру расчёта
        DECLARE @OrderId INT;

        DECLARE OrderCursor CURSOR LOCAL FAST_FORWARD FOR
            SELECT DISTINCT OrderId FROM inserted;

        OPEN OrderCursor;
        FETCH NEXT FROM OrderCursor INTO @OrderId;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            EXEC CalculateOrderSummaryAndRoles @OrderId = @OrderId;
            FETCH NEXT FROM OrderCursor INTO @OrderId;
        END;

        CLOSE OrderCursor;
        DEALLOCATE OrderCursor;

        -- Сброс флага
        EXEC sp_set_session_context @key = N'AllowOrderUpdateProcedureRun', @value = NULL;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrMsg NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Ошибка в триггере TrgOrderItemsAfterChange: %s', 16, 1, @ErrMsg);
    END CATCH;
END;

GO
-- триггер - контроль изменения Orders
CREATE OR ALTER TRIGGER TrgPreventManualOrderChanges
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @AllowUpdate BIT = CAST(SESSION_CONTEXT(N'AllowOrderUpdate') AS BIT);

    IF @AllowUpdate IS NULL OR @AllowUpdate = 0
    BEGIN
        IF EXISTS (
            SELECT 1
            FROM inserted i
            JOIN deleted d ON i.Id = d.Id
            WHERE ISNULL(i.TotalAmount, -1) <> ISNULL(d.TotalAmount, -1)
               OR ISNULL(i.OrderRoleId, -1) <> ISNULL(d.OrderRoleId, -1)
        )
        BEGIN
            RAISERROR('Ручное изменение полей TotalAmount или OrderRoleId запрещено.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
    END;
END;
GO

-- триггер - контроль изменения OrderStatus и заполнение таблицы OrderStatusHistory

CREATE OR ALTER TRIGGER trg_AfterOrderStatusChange
ON Orders
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    -- Проверяем, изменился ли статус заказа
    IF UPDATE(StatusId)
    BEGIN
        INSERT INTO OrderStatusHistory (OrderId, StatusId, ChangedAt)
        SELECT i.Id, i.StatusId, GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.Id = d.Id
        WHERE i.StatusId <> d.StatusId;
    END
END;
Go
-- заполнение таблиц 
USE CCCStore_NGu
GO
INSERT INTO Users
VALUES
('Petr', 'Ivanov', 'ivanov@ya.ru', 'b1b3773a05c0ed0176787a4f1574ff0075f7521e', '92713587476', '2025-08-01' ,0, '2025-08-01', '2025-08-01'),
('Ivan', 'Petrov', 'petrov@ya.ru', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', '793715843288', '2025-08-02', 1, '2025-08-02', null),
('Joe', 'Kim', 'kim@gmail.com', 'c7ffa3bc306622e2b2a40241b4ff9152392b8016', '89612678763', default, 1, default, null ),
('Lao', 'Tzu', 'tzu@rambler.ru', '3e8aa3e23ce47c4c3792815c207ec93b3b5febc3', '+78452687345', '2025-08-03', 0, '2025-08-03', '2025-08-04')

INSERT INTO OrderRoles
VALUES
('RetailPrice', 0),
('SmallWholesalePrice', 20000),
('MediumWholesalePrice', 60000),
('LargeWholesalePrice', 100000)

INSERT INTO OrderStatus
VALUES
('создан'),
('в обработке'),
('собирается'),
('передан в службу доставки'),
('доставлен'),
('отказ'),
('отменён пользователем'),
('получен'),
('отменён из-за недостаточности товаров на складе')

INSERT INTO ReviewStatus
VALUES
('ожидает модерации'),
('опубликован'),
('забанен')

INSERT INTO Partners
VALUES
('СДЭК', 'Доставка', 'cdek@rambler.ru', '+79375428700'),
('Boxberry', 'Доставка', 'boxberry@ya.ru', '+79612234545'),
('Почта России', 'Доставка', 'pochta@ya.ru', '+79231653478'),
('5Post (Пятерочка, Перекресток)', 'Доставка', 'fivegroup@gmail.com', '+79036528554'),
('Gan', 'Поставщик', 'gan@gmail.com', '+861077557717'),
('QiYi MoFangGe', 'Поставщик', 'mofangge@gmail.com', '+861017711771'),
('MoYu', 'Поставщик', 'moyu@gmail.com', '+861079797979'),
('Funs Puzzles', 'Поставщик', 'funs@gmail.com', '+861025632786')

INSERT INTO Brands
VALUES
('Calvin`s Puzzle', 8),
('Cut Corner Cubes', 5),
('Cyclone Boys', 6),
('DaYan', 7),
('DianSheng', 8),
('Funs Puzzles', 8),
('Gan', 5),
('Heshu', 6),
('MoYu', 7),
('Xiaomi', 7),
('QiYi MoFangGe', 6),
('NO NAME', 8),
('Zhigao', 5)

INSERT INTO DeliveryType
VALUES
('Курьер'),
('ПВЗ'),
('Постамат'),
('Почтовое отделение'),
('Самовывоз из шоу-рума'),
('Менеджер')

INSERT INTO PickupPoints
VALUES
('СДЭК', '410005, г. Саратов, ул. Зарубина, 180/184 корп. 2', 'Пн-Пт: 10:00-20:00 Сб-Вс: 10:00-18:00', 1),
('Boxberry', '410005, г. Саратов, им Посадского И.Н. ул, д.272', 'Пн-Вс: 09:00-21:00', 2),
('Почта России', '410501, г. Саратов, ул. ДОС, 17', 'Вт-Сб: 09:00 - 17:00', 3),
('Почта России', '410050,г. Саратов, ул. Молодежная, 4', 'Вт-Сб: 09:00 - 17:00', 3),
('Boxberry', '410060, г. Саратов ,ул. Огородная, д.225Б', 'Пн-Вс: 09:00-21:00', 2),
('5Post (Пятерочка, Перекресток)', '410009, г. Саратов , ул. Алексеевская, 3А', 'Пн-Вс: 08:00-22:30', 4),
('5Post (Пятерочка, Перекресток)', '410056, г. Саратов , им Вавилова Н.И. ул, 8/26а', 'Пн-Вс: 08:00-22:00', 4),
('СДЭК', '620014, г. Екатеринбург, проспект Ленина, 24/8 ', 'Пн-Пт: 10:00-20:00 Сб-Вс: 10:00-18:00', 1),
('Boxberry', '630007, г. Новосибирск, Серебренниковская улица, 14,', 'Пн-Вс: 09:00-21:00', 2),
('Boxberry', '191181, г. Санкт-Петербург, Невский проспект, 32-34', 'Пн-Вс: 09:00-21:00', 2),
('Почта России', '119019, г. Москва, ул. Новый Арбат, 2,', 'Вт-Сб: 09:00 - 17:00', 3)

INSERT INTO PaymentMethods
VALUES
('СБП'),
('Онлайн-оплата'),
('Яндекс.Деньги'),
('Наличными при получении')

INSERT INTO Categories
VALUES
('Кубики Рубика', null),
('Головоломки', null),
('Аксессуары', null),
('Скиллтои', null),
('Настольные игры', null),
('Конструкторы', null),
('Краски и грунтовки', null),
('Порадовать себя', null),
('Растения', null),
('Игрушечное оружие', null),
('2x2', 1),
('3х3', 1),
('4x4', 1),
('5x5', 1),
('6x6', 1),
('7x7', 1),
('8x8 - 21x21', 1),
('Пирамидки', 2),
('Мегаминксы', 2),
('Скьюбы', 2),
('Скваеры', 2),
('Часы Рубика', 2),
('Изменяющие форму', 2),
('Для мозговитых', 2),
('Самые простые головоломки', 2),
('Лабиринты', 2),
('Пазлы', 2),
('Таймеры', 3),
('Чехлы и боксы', 3),
('Запчасти', 3),
('Смазка', 3),
('Атрибуты', 3),
('Маты', 3),
('Йо-Йо', 4),
('Пенспиннинг', 4),
('Неокубы', 4),
('Капстекинг', 4),
('Спиннеры', 4),
('Фингерборды', 4),
('Кендамы', 4),
('Антистрессы', 4),
('Игральные карты', 5),
('Шахматы', 5),
('Покерные наборы', 5),
('Логические', 5),
('Магнитные', 6),
('Для детей', 6),
('Деревянные сборные', 6),
('Металлические сборные', 6),
('Краска и эмаль', 7),
('Краска с эффектом', 7),
('Специальные покрытия', 7),
('Грунтовка', 7),
('Сертификаты', 8),
('Мистери головоломки', 8),
('Растения + конструктор', 9),
('Консервированные наборы для выращивания', 9),
('Поролоновые пули', 10),
('Водный пистолет', 10),
('Мыльные пузыри', 10)

INSERT INTO Products 
(
  Name,
  ShortDescription,
  CategoryId,
  BrandId,
  RetailPrice,
  SmallWholesalePrice,
  MediumWholesalePrice,
  LargeWholesalePrice,
  StockWarehouse,
  StockStore,
  CreatedAt
)
VALUES
('QiYi MoFangGe 3x3x3 Gan', 'Популярный скоростной кубик с магнитами, оптимально подходит для спидкубинга.', 11, 11, 1200, 1100, 1050, 1000, 50, 30, GETDATE()),
('MoYu Pyraminx', 'Пирамидальный кубик с плавным ходом, отлично развивает логику.', 12, 9, 900, 850, 800, 780, 45, 20, GETDATE()),
('YJ Yulu 2x2', 'Компактный магнитный кубик 2x2 для новичков и опытных.', 10, 7, 600, 550, 530, 500, 60, 40, GETDATE()),
('ShengShou Megaminx', 'Мегаминкс с плавным и стабильным ходом, подходит для новичков.', 15, 2, 1500, 1400, 1300, 1200, 15, 10, GETDATE()),
('DaYan ZhanChi 4x4', 'Четырёхслойный кубик с отличной стабилизацией и скоростью.', 13, 4, 2000, 1900, 1800, 1700, 40, 25, GETDATE()),
('QiYi Valk 3', 'Профессиональный скоростной кубик для спидкубинга и турниров.', 11, 11, 1700, 1650, 1600, 1500, 55, 35, GETDATE()),
('YJ MGC', 'Новинка с улучшенной магнитной системой и быстрым ходом.', 11, 7, 2500, 2400, 2300, 2200, 30, 20, GETDATE()),
('X-Man Wingy 5x5', 'Пятислойный кубик с отличной механикой и плавными движениями.', 14, 6, 3200, 3100, 3000, 2900, 20, 15, GETDATE()),
('Rubik''s Cube 3x3', 'Классический кубик Рубика с лицензией, отличный подарок.', 11, 1, 700, 650, 630, 600, 80, 60, GETDATE()),
('Zhigao Pen Spinning Pen V20', 'Ручка для пенспиннинга с отличным балансом и дизайном.', 4, 13, 800, 750, 700, 680, 90, 45, GETDATE()),
('MoYu WeiLong WR', 'Стабильный и быстрый кубик 3x3 от MoYu.', 11, 9, 1300, 1200, 1150, 1100, 40, 30, GETDATE()),
('Maru 3x3x3 3см', 'Миниатюрный классический кубик с яркими цветами.', 11, 8, 750, 700, 680, 650, 50, 40, GETDATE()),
('Набор для тренера Про', 'Специализированный комплект для тренировки спидкубинга.', 11, 9, 2200, 2100, 2000, 1900, 15, 10, GETDATE()),
('Кубик Рубика Набор для тренера', 'Комплект кубиков для отработки техники.', 11, 8, 2000, 1900, 1800, 1700, 20, 15, GETDATE()),
('Rubik''s Cube Подставка для ручек', 'Оригинальная подставка в виде кубика Рубика.', 3, 1, 400, 370, 350, 330, 70, 50, GETDATE())

INSERT INTO ProductImages
VALUES
-- 1. QiYi MoFangGe 3x3x3 Gan
(1, 'https://cccstore.ru/images/products/qiyi-gans-356-front.jpg'),
(1, 'https://cccstore.ru/images/products/qiyi-gans-356-side.jpg'),
(1, 'https://cccstore.ru/images/products/qiyi-gans-356-back.jpg'),

-- 2. MoYu Pyraminx
(2, 'https://cccstore.ru/images/products/moyu-pyraminx-front.jpg'),
(2, 'https://cccstore.ru/images/products/moyu-pyraminx-side.jpg'),

-- 3. YJ Yulu 2x2
(3, 'https://cccstore.ru/images/products/yj-yulu-front.jpg'),
(3, 'https://cccstore.ru/images/products/yj-yulu-package.jpg'),

-- 4. ShengShou Megaminx
(4, 'https://cccstore.ru/images/products/shengshou-megaminx-front.jpg'),
(4, 'https://cccstore.ru/images/products/shengshou-megaminx-box.jpg'),

-- 5. DaYan ZhanChi 4x4
(5, 'https://cccstore.ru/images/products/dayan-zhanchi-4x4-front.jpg'),
(5, 'https://cccstore.ru/images/products/dayan-zhanchi-4x4-side.jpg'),

-- 6. QiYi Valk 3 (ProductId = 6)
(6, 'https://cccstore.ru/images/products/qiyi-valk3-front.jpg'),
(6, 'https://cccstore.ru/images/products/qiyi-valk3-back.jpg'),

-- 7. YJ MGC
(7, 'https://cccstore.ru/images/products/yj-mgc-front.jpg'),
(7, 'https://cccstore.ru/images/products/yj-mgc-package.jpg'),

-- 8. X-Man Wingy 5x5 
(8, 'https://cccstore.ru/images/products/x-man-wingy-5x5-front.jpg'),
(8, 'https://cccstore.ru/images/products/x-man-wingy-5x5-box.jpg'),

-- 9. Rubik's Cube 3x3
(9, 'https://cccstore.ru/images/products/rubiks-cube-front.jpg'),
(9, 'https://cccstore.ru/images/products/rubiks-cube-packaging.jpg'),

-- 10. Zhigao Pen Spinning Pen V20
(10, 'https://cccstore.ru/images/products/zhigao-pen-v20-front.jpg'),
(10, 'https://cccstore.ru/images/products/zhigao-pen-v20-package.jpg'),

-- 11. MoYu WeiLong WR
(11, 'https://cccstore.ru/images/products/moyu-weilong-wr-front.jpg'),
(11, 'https://cccstore.ru/images/products/moyu-weilong-wr-side.jpg'),
(11, 'https://cccstore.ru/images/products/moyu-weilong-wr-packaging.jpg'),

-- 12. Maru 3x3x3 3см
(12, 'https://cccstore.ru/images/products/maru-3x3-front.jpg'),
(12, 'https://cccstore.ru/images/products/maru-3x3-side.jpg'),

-- 13. Набор для тренера Про
(13, 'https://cccstore.ru/images/products/trainer-pro-set-1.jpg'),
(13, 'https://cccstore.ru/images/products/trainer-pro-set-2.jpg'),

-- 14. Кубик Рубика Набор для тренера
(14, 'https://cccstore.ru/images/products/trainer-set-1.jpg'),
(14, 'https://cccstore.ru/images/products/trainer-set-2.jpg'),

-- 15. Rubik's Cube Подставка для ручек
(15, 'https://cccstore.ru/images/products/rubiks-pen-stand-front.jpg'),
(15, 'https://cccstore.ru/images/products/rubiks-pen-stand-side.jpg')

INSERT INTO ProductDescriptions (ProductId, FullDescription, CreatedAt)
VALUES
(1, 'QiYi MoFangGe 3x3x3 Gan — популярный скоростной кубик с магнитами, который обеспечивает стабильность и точность при сборке. Он идеально подходит для спидкубинга благодаря плавности хода и высокой скорости вращения.', GETDATE()),
(2, 'MoYu Pyraminx — пирамидальный кубик, известный своим плавным ходом, который отлично развивает логику и пространственное мышление. Это идеальная головоломка для любителей необычных форм.', GETDATE()),
(3, 'YJ Yulu 2x2 — компактный магнитный кубик 2x2 с улучшенной механикой. Подходит как новичкам, так и опытным куберам для тренировки скорости и точности.', GETDATE()),
(4, 'ShengShou Megaminx — мегаминкс с плавным и стабильным ходом, что делает его подходящим вариантом для новичков и любителей головоломок с большим количеством граней.', GETDATE()),
(5, 'DaYan ZhanChi 4x4 — четырехслойный кубик, известный своей отличной стабилизацией и скоростью. Удобен в сборке и популярный среди спидкуберов.', GETDATE()),
(6, 'QiYi Valk 3 — профессиональный скоростной кубик, предназначенный для турниров и интенсивных тренировок. Обеспечивает точный контроль и высокую скорость вращения.', GETDATE()),
(7, 'YJ MGC — новинка с улучшенной магнитной системой, предлагающая быстрый и плавный ход для спидкубинга. Высокое качество изготовления гарантирует долгий срок службы.', GETDATE()),
(8, 'X-Man Wingy 5x5 — пятислойный кубик с превосходной механикой и плавными движениями, обеспечивающий комфорт при сборке и высокую производительность.', GETDATE()),
(9, 'Rubik''s Cube 3x3 — классический кубик Рубика с официальной лицензией. Отличный выбор для начинающих и тех, кто хочет приобщиться к миру куберов.', GETDATE()),
(10, 'Zhigao Pen Spinning Pen V20 — ручка для пенспиннинга с отличным балансом и эргономичным дизайном. Позволяет выполнять сложные трюки и развивает моторику.', GETDATE()),
(11, 'MoYu WeiLong WR - стабильный и быстрый профессиональный кубик 3x3 с магнитами, обеспечивающий точность и плавность хода. Идеален для как новичков, так и продвинутых спидкуберов.', GETDATE()),
(12, 'Maru 3x3x3 3см - миниатюрный классический кубик с яркими контрастными цветами, популярный как сувенир или для коллекции.', GETDATE()),
(13, 'Набор для тренера Про - специализированный комплект инструментов и кубиков для тренировок и развития техники спидкубинга.', GETDATE()),
(14, 'Кубик Рубика Набор для тренера - комплект кубиков, предназначенных для отработки техник и повышения навыков в спидкубинге.', GETDATE()),
(15, 'Rubik''s Cube Подставка для ручек - оригинальная настольная подставка в виде кубика Рубика, подходит для организации рабочего пространства.', GETDATE());

INSERT INTO Reviews
values
(1, 1,'2025-08-04', 5,'Прикольный кубик, крутится мягко, углы срезает. Из коробки сильно затягут и не смазан, но это легко исправляется.',2),
(2, 3,'2025-08-05', 5, 'Крутится хорошо, с характерным звуком, приятно) светится, если предварительно зарядить, прикольная игрушка', 1),
(3, 4, '2025-08-04', 1, 'правгплмыпврооб иочпоп', 3)

INSERT INTO Promotions
values
('Распродажа в честь дня рождения Эрно Рубика!', 'Распродажа в честь дня рождения Эрно Рубика! Человеку, подарившему нам любимое хобби, исполняется 81 год.

Празднуем это событие скидками -10% на все головоломки на сайте CCCSTORE.RU! Скидка действует только 13 июля. Отличный повод порадовать себя головоломкой, которую давно хотели!', 10, '2025-07-13', '2025-07-13'),
('С 1 сентября! Распродажа началась!', 'Доброе утро! Не важно, ведёте ли вы сегодня ребёнка школу, идёте самостоятельно, или не идёте вовсе – поздравляем с Днём Знаний!

Чтобы скрасить первые дни осени в предвкушении прохладной погоды и листопада, заходите на наш сайт CCCSTORE.RU и выбирайте головоломку себе или в подарок близкому.

Скидки -10% на всё будут действовать до 3-го сентября включительно!

Надеемся, вы найдёте головоломку по душе. Желаем всем удачного учебного года и новых рекордов. Благодарим за доверие!

Ваш CCCSTORE.RU', 10, '2025-09-01', '2025-10-03'),
('тест', 'тестовая скидка', 7, '2025-08-05', '2025-11-09')

INSERT INTO ProductPromotions (ProductId, PromotionId)
values
(2, 1),
(1, 3)

INSERT INTO ProductPromotions (CategoryId, PromotionId)
values
(4, 3),
(23, 3)

EXEC UpdatePromoPricesWithMaxDiscount

INSERT INTO Orders 
(UserId, StatusId, PaymentMethodId, DeliveryTypeId, PickupPointId, DeliveryAddress, OrderDate)
VALUES
(2, 1, 2, 1, NULL, 'г. Саратов, пр. Невский, д. 15, кв. 10, 190000', '2025-08-05'),
(1, 1, 2, 5, NULL, NULL, '2025-08-10'),
(3, 1, 2, 1, NULL, 'г. Екатеринбург, ул. Мира, д. 25, кв. 5, 620000', '2025-08-12'),
(4, 1, 2, 1, NULL, 'г. Новосибирск, ул. Ленина, д. 5, кв. 3, 630000', '2025-08-18'),
(2, 1, 2, 2, 2, NULL, '2025-08-20'),
(1, 2, 1, 1, NULL, 'г. Москва, ул. Ленина, д. 10, кв. 15, 101000', '2025-08-25'),
(4, 1, 1, 2, 1, NULL, '2025-08-28'),
(3, 1, 1, 2, 9, NULL, '2025-08-30'),
(2, 1, 2, 1, NULL, 'г. Санкт-Петербург, пр. Невский, д. 15, кв. 10, 190000', '2025-09-01'),
(4, 1, 2, 1, NULL, 'г. Новосибирск, ул. Ленина, д. 5, кв. 3, 630000', '2025-09-02')

INSERT INTO Orders
(CustomerName, CustomerSurname, CustomerPhone, CustomerEmail, OrderDate, StatusId, PaymentMethodId, PaymentStatus, DeliveryTypeId, PickupPointId, DeliveryAddress)
VALUES 
('Пётр', 'Кузнецов', '+79997654321', 'petr@rambler.ru', '2025-03-18', 4, 3, 0, 2, 1, NULL),
('Анна', 'Иванов', '+79876543210', 'ann@jmail.com', '2025-01-27', 5, 3, 0, 2, 1, NULL),
('Иван', 'Иванов', '+79781234567', 'ivanov@rambler.ru', '2025-08-15', 4, 1, 0, 2, 9, NULL),
('Иван', 'Сидоров', '+79876543210', 'sidorov@rambler.ru', '2025-01-10', 4, 3, 0, 4, 6, NULL),
('Пётр', 'Смирнов', '+79541234567', 'smirnov@ya.ru', '2025-05-29', 4, 2, 0, 2, 4, NULL),
('Анна', 'Кузнецов', '+79611234567', 'anna@jmail.com', '2025-07-09', 3, 1, 0, 4, 6, NULL),
('Мария', 'Петров', '+79876543210', 'mari@ya.ru', '2025-09-02', 3, 2, 0, 4, 5, NULL),
('Алексей', 'Петров', '+79611234567', 'alex@rambler.ru', '2025-04-21', 5, 4, 0, 4, 6, NULL),
('Пётр', 'Смирнов', '+79997654321', 'pertsmirnov@jmail.com', '2025-03-15', 5, 2, 0, 4, 5, NULL),
('Иван', 'Сидоров', '+79541234567', 'ivan@rambler.ru', '2025-02-25', 5, 4, 0, 4, 1, '191181, г. Санкт-Петербург, Невский проспект, д. 36, кв. 15')


INSERT INTO OrderItems (OrderId, ProductId, Quantity)
VALUES 
(1, 1, 10),
(1, 3, 10),
(1, 5, 10),
(2, 2, 1),
(2, 4, 1),
(3, 6, 1),
(3, 7, 1),
(3, 8, 1),
(3, 9, 1),
(4, 10, 1),
(5, 11, 50),
(5, 12, 50),
(6, 13, 1),
(6, 14, 1),
(7, 3, 1),
(7, 5, 1),
(7, 9, 1),
(8, 2, 1),
(9, 7, 15),
(9, 8, 15),
(10, 1, 1),
(10, 4, 1),
(10, 6, 1),
(11, 1, 1),
(11, 5, 1),
(12, 2, 1),
(13, 3, 1),
(13, 7, 1),
(14, 4, 1),
(15, 6, 1),
(15, 8, 1),
(16, 9, 1),
(17, 10, 1),
(17, 11, 1),
(18, 12, 1),
(19, 13, 1),
(19, 14, 1),
(20, 15, 1)

-- обновление статусов заказа при передаче в службу доставки:
UPDATE Orders
SET StatusId = CASE Id
    WHEN 3 THEN 4
    WHEN 5 THEN 4
    WHEN 9 THEN 4
    WHEN 10 THEN 4
    ELSE StatusId
END
WHERE Id IN (3, 5, 9, 10);


-- список пользователей, давших согласие на получение рассылки
SELECT Id, Name, Surname, Email
FROM Users
WHERE NewsletterConsent = 1;

--отчёт по продажам за последние 3 месяца с суммами по ролям заказчиков

SELECT orr.Name AS OrderRole, COUNT(*) AS OrdersCount, SUM(o.TotalAmount) AS TotalSales
FROM Orders o
JOIN OrderRoles orr ON o.OrderRoleId = orr.Id
WHERE o.OrderDate >= DATEADD(MONTH, -3, GETDATE())
GROUP BY orr.Name
ORDER BY TotalSales DESC;

-- количество заказов по выбранной категории товара

SELECT COUNT(DISTINCT o.Id) AS OrdersCount
FROM Orders o
JOIN OrderItems oi ON o.Id = oi.OrderId
JOIN Products p ON oi.ProductId = p.Id
WHERE p.CategoryId = 11;

-- история всех заказов клиента с детализацией и итоговой суммой

SELECT
    o.Id AS OrderId,
    o.OrderDate,
    os.Name AS Status,
    p.Name AS ProductName,
    oi.Quantity,
    oi.Price,
    (oi.Quantity * oi.Price) AS LineTotal,
    o.TotalAmount
FROM Orders o
JOIN OrderStatus os ON o.StatusId = os.Id
JOIN OrderItems oi ON oi.OrderId = o.Id
JOIN Products p ON oi.ProductId = p.Id
WHERE o.UserId = 2
ORDER BY o.OrderDate DESC, o.Id, p.Name;

-- аналитика по продажам - статистика по брендам с учётом роли клиента
SELECT
    b.Name AS BrandName,
    c.Name AS CategoryName,
    orr.Name AS OrderRole,
    SUM(oi.Quantity) AS QuantitySold,
    SUM(oi.Quantity * oi.Price) AS Revenue
FROM OrderItems oi
JOIN Products p ON oi.ProductId = p.Id
JOIN Brands b ON p.BrandId = b.Id
JOIN Categories c ON p.CategoryId = c.Id
JOIN Orders o ON oi.OrderId = o.Id
JOIN OrderRoles orr ON o.OrderRoleId = orr.Id
WHERE orr.Name = 'RetailPrice'  -- фильтр по роли розничного клиента
GROUP BY b.Name, c.Name, orr.Name
ORDER BY Revenue DESC;


