USE tourism;
START TRANSACTION;

INSERT INTO destinations (country, city) VALUES ('Россия', 'Казань');
SET @destination_id = LAST_INSERT_ID();
INSERT INTO tours (destination_id, title, duration_days, base_price)
VALUES (@destination_id, 'Выходные в Казани', 3, 15000);
SET @tour_id = LAST_INSERT_ID();
INSERT INTO services (title, price) VALUES ('Обзорная экскурсия', 2500);
SET @service_id = LAST_INSERT_ID();
INSERT INTO customers (full_name, email) VALUES ('Тестовый Клиент', 'demo@example.invalid');
SET @customer_id = LAST_INSERT_ID();

INSERT INTO bookings (tour_id, customer_id, service_id, departure_date, travelers, total_price)
SELECT t.tour_id, @customer_id, s.service_id,
       CURRENT_DATE + INTERVAL 30 DAY, 2, 2 * t.base_price + s.price
FROM tours AS t CROSS JOIN services AS s
WHERE t.tour_id = @tour_id AND s.service_id = @service_id;

SELECT b.booking_id, c.full_name, d.city, t.title AS tour,
       s.title AS extra_service, b.travelers, b.status, b.total_price
FROM bookings AS b
JOIN customers AS c ON c.customer_id = b.customer_id
JOIN tours AS t ON t.tour_id = b.tour_id
JOIN destinations AS d ON d.destination_id = t.destination_id
LEFT JOIN services AS s ON s.service_id = b.service_id
WHERE b.customer_id = @customer_id;

ROLLBACK;
