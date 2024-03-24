-- Crear una base de datos llamada Alke Wallet --
CREATE DATABASE `Alke_Wallet`;

-- Usar la base de datos Alke Wallet --
USE `Alke_Wallet`;

-- Crear Entidades:

-- 1. Tabla Usuario: Representa a cada usuario individual del sistema de monedero virtual --
CREATE TABLE Usuario (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    correo_electronico VARCHAR(255) NOT NULL UNIQUE,
    contraseña VARCHAR(255) NOT NULL
    -- saldo DECIMAL(10, 2) NOT NULL | Se elimina el atributo saldo, ya que se manejará en la tabla UsuarioMoneda --
);

-- 2. Tabla Moneda: Representa las diferentes monedas que se pueden utilizar en el monedero virtual --
CREATE TABLE Moneda (
    currency_id INT AUTO_INCREMENT PRIMARY KEY,
    currency_name VARCHAR(255) NOT NULL,
    currency_symbol VARCHAR(10) NOT NULL
);

-- 3. Tabla Transacción: Representa cada transacción financiera realizada por los usuarios --
CREATE TABLE Transaccion (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    sender_user_id INT,
    receiver_user_id INT,
    currency_id INT, -- Se añade el atributo que indica el tipo de moneda de la transacción --
    importe DECIMAL(10, 2) NOT NULL,
    transaction_date DATETIME NOT NULL,
    FOREIGN KEY (sender_user_id) REFERENCES Usuario(user_id),
    FOREIGN KEY (receiver_user_id) REFERENCES Usuario(user_id),
    FOREIGN KEY (currency_id) REFERENCES Moneda(currency_id) 
);

-- 4. Tabla UsuarioMoneda: Se crea esta entidad adicional para almacenar información sobre la relación entre los usuarios con monedas y sus balances -- 
CREATE TABLE UsuarioMoneda (
    user_id INT,
    currency_id INT,
    balance DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (user_id, currency_id),
    FOREIGN KEY (user_id) REFERENCES Usuario(user_id),
    FOREIGN KEY (currency_id) REFERENCES Moneda(currency_id)
);

-- Insertar datos:

-- 1. Insertar datos en la tabla Usuario --
INSERT INTO Usuario (nombre, correo_electronico, contraseña) VALUES
('Ronoroa Zoro', 'ronoroa.zoro@mugiwara.com', 'password123'),
('Nico Robin', 'nico.robin@mugiwara.com', 'pass456'),
('Satoru Gojo', 'satoru.gojo@jujutsukaizen.com', 'password456'),
('Megumi Fushiguro', 'megumi.fushiguro@jujutsukaizen.com', 'pass123'),
('Nobara Kugisaki', 'nobara.kugisaki@jujutsukaizen.com', 'password789'),
('Inosuke Hashibira', 'inosuke.hashibira@demonslayer.com', 'pass789');

-- 2. Insertar datos en tabla Moneda --
INSERT INTO Moneda (currency_name, currency_symbol) VALUES
('Dólar', '$'),
('Euro', '€'),
('Yen', '¥'),
('Berry', '฿'),
('Peso Chileno', 'CLP');

-- 3. Insertar datos en tabla UsuarioMoneda --
INSERT INTO UsuarioMoneda (user_id, currency_id, balance) VALUES
(1, 4, 3000.00), -- Zoro tiene 3000 berries
(2, 4, 5000.00), -- Robin tiene 5000 berries
(3, 3, 190000.00), -- Gojo tiene 190000 yenes
(4, 1, 4000.00), -- Fushiguro tiene 4000 dólares
(5, 2, 6000.00), -- Nobara tiene 6000 euros
(6, 5, 9000000.00); -- Inosuke tiene 9000000 Pesos Chilenos

-- 4. Insertar datos en tabla Transacción
INSERT INTO Transaccion (sender_user_id, receiver_user_id, currency_id, importe, transaction_date) VALUES
(1, 2, 4,    1000.00, '2024-03-23 10:30:00'), -- Zoro envía 1000 berries a Robin
(2, 5, 4,    2000.00, '2024-03-24 13:00:00'), -- Robin envía 2000 berries a Nobara
(3, 1, 3,    3000.00, '2024-03-23 12:30:00'), -- Gojo envía 3000 yenes a Zoro
(4, 6, 1,    1500.00, '2024-03-23 12:40:00'), -- Fushiguro envía 1500 dólares a Inosuke
(5, 4, 2,     500.00, '2024-03-24 14:30:00'), -- Nobara envía 500 euros a Gojo
(6, 1, 5, 1000000.00, '2024-03-24 17:00:00'), -- Inosuke envía 10000000 CLP a Zoro
(3, 6, 3,    2500.00, '2024-03-24 12:40:00'), -- Gojo envía 3000 yenes a Inosuke
(2, 4, 4,    2000.00, '2024-03-24 11:00:00'); -- Robin envía 2000 berries a Fushiguro


-- Crear consultas SQL para:

-- 1. Consulta para obtener el nombre de la moneda elegida por un usuario específico --

-- 1.1  Zoro --
SELECT m.currency_name
FROM Moneda m
JOIN UsuarioMoneda um ON m.currency_id = um.currency_id
WHERE um.user_id = 1;

-- 1.2  Robin --
SELECT m.currency_name
FROM Moneda m
JOIN UsuarioMoneda um ON m.currency_id = um.currency_id
WHERE um.user_id = 2;

-- 1.3  Gojo --
SELECT m.currency_name
FROM Moneda m
JOIN UsuarioMoneda um ON m.currency_id = um.currency_id
WHERE um.user_id = 3;

-- 1.4  Fushiguro --
SELECT m.currency_name
FROM Moneda m
JOIN UsuarioMoneda um ON m.currency_id = um.currency_id
WHERE um.user_id = 4;

-- 1.5  Nobara --
SELECT m.currency_name
FROM Moneda m
JOIN UsuarioMoneda um ON m.currency_id = um.currency_id
WHERE um.user_id = 5;

-- 1.6  Inosuke --
SELECT m.currency_name
FROM Moneda m
JOIN UsuarioMoneda um ON m.currency_id = um.currency_id
WHERE um.user_id = 6;


-- 2. Consulta para obtener todas las transacciones registradas --

SELECT * FROM Transaccion;

-- 3. Consulta para obtener todas las transacciones realizadas por un usuario específico --

-- 3.1  Zoro --
SELECT t.transaction_id, t.receiver_user_id, m.currency_name, t.importe, t.transaction_date
FROM Transaccion t
JOIN Moneda m ON t.currency_id = m.currency_id
WHERE t.sender_user_id = 1;

-- 3.2  Robin--
SELECT t.transaction_id, t.receiver_user_id, m.currency_name, t.importe, t.transaction_date
FROM Transaccion t
JOIN Moneda m ON t.currency_id = m.currency_id
WHERE t.sender_user_id = 2;

-- 3.3  Gojo --
SELECT t.transaction_id, t.receiver_user_id, m.currency_name, t.importe, t.transaction_date
FROM Transaccion t
JOIN Moneda m ON t.currency_id = m.currency_id
WHERE t.sender_user_id = 3;

-- 3.4  Fushiguro --
SELECT t.transaction_id, t.receiver_user_id, m.currency_name, t.importe, t.transaction_date
FROM Transaccion t
JOIN Moneda m ON t.currency_id = m.currency_id
WHERE t.sender_user_id = 4;

-- 3.5  Nobara --
SELECT t.transaction_id, t.receiver_user_id, m.currency_name, t.importe, t.transaction_date
FROM Transaccion t
JOIN Moneda m ON t.currency_id = m.currency_id
WHERE t.sender_user_id = 5;

-- 3.6  Inosuke --
SELECT t.transaction_id, t.receiver_user_id, m.currency_name, t.importe, t.transaction_date
FROM Transaccion t
JOIN Moneda m ON t.currency_id = m.currency_id
WHERE t.sender_user_id = 6;


-- 4. Sentencia DML para modificar el campo correo electrónico de un usuario específico --

SELECT * FROM Usuario;

-- 4.1  Zoro --
UPDATE Usuario
SET correo_electronico = 'ronoroa.zoro@nakama.com'
WHERE user_id = 1;

-- 4.2  Robin--
UPDATE Usuario
SET correo_electronico = 'nico.robin@nakama.com'
WHERE user_id = 2;

-- 4.3  Gojo --
UPDATE Usuario
SET correo_electronico = 'satoru.gojo@jujutsu.com'
WHERE user_id = 3;

-- 4.4  Fushiguro --
UPDATE Usuario
SET correo_electronico = 'megumi.fushiguro@jujutsu.com'
WHERE user_id = 4;

-- 4.5  Nobara --
UPDATE Usuario
SET correo_electronico = 'nobara.kugisaki@jujutsu.com'
WHERE user_id = 5;

-- 4.6  Inosuke --
UPDATE Usuario
SET correo_electronico = 'inosuke.hashibira@kimetsunoyaiba.com'
WHERE user_id = 6;


-- 5. Sentencia para eliminar los datos de una transacción (eliminando la fila completa) --
SELECT * FROM Transaccion;
DELETE FROM Transaccion WHERE transaction_id = 8;

