USE master;
GO

CREATE DATABASE [Food Delivery];
GO

USE FoodDelivery;
GO

--CREATE SCHEMA user_schema;
--CREATE SCHEMA restaurant_schema;
--CREATE SCHEMA order_schema;
--CREATE SCHEMA delivery_schema;

CREATE TABLE user_schema.users
(
    user_id INT IDENTITY PRIMARY KEY,
    user_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255),
    
    created_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE restaurant_schema.restaurants
(
    restaurant_id INT IDENTITY PRIMARY KEY,
    restaurant_name VARCHAR(100) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(20),

    created_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE restaurant_schema.menuitems
(
    menuitem_id INT IDENTITY PRIMARY KEY,
    restaurant_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    price DECIMAL(10,2) NOT NULL,
    rating DECIMAL(3,2),

    created_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_menuitems_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES restaurant_schema.restaurants(restaurant_id)
    ON DELETE CASCADE
);

CREATE TABLE order_schema.orders
(
    order_id INT IDENTITY PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    order_date DATETIME2 DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL,

    created_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_orders_user
    FOREIGN KEY (user_id)
    REFERENCES user_schema.users(user_id),

    CONSTRAINT fk_orders_restaurant
    FOREIGN KEY (restaurant_id)
    REFERENCES restaurant_schema.restaurants(restaurant_id),

    CONSTRAINT chk_order_status
    CHECK (status IN ('Pending','Confirmed','Preparing','Delivered','Cancelled'))
);

CREATE TABLE order_schema.order_items
(
    order_item_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    menuitem_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_orderitems_order
    FOREIGN KEY (order_id)
    REFERENCES order_schema.orders(order_id)
    ON DELETE CASCADE,

    CONSTRAINT fk_orderitems_menuitem
    FOREIGN KEY (menuitem_id)
    REFERENCES restaurant_schema.menuitems(menuitem_id)
);

CREATE TABLE delivery_schema.delivery_drivers
(
    driver_id INT IDENTITY PRIMARY KEY,
    driver_name VARCHAR(50) NOT NULL,
    phone VARCHAR(20) UNIQUE,

    created_at DATETIME2 DEFAULT GETDATE()
);

CREATE TABLE delivery_schema.deliveries
(
    delivery_id INT IDENTITY PRIMARY KEY,
    order_id INT NOT NULL,
    driver_id INT,
    delivery_time DATETIME2,
    status VARCHAR(20),

    created_at DATETIME2 DEFAULT GETDATE(),

    CONSTRAINT fk_deliveries_order
    FOREIGN KEY (order_id)
    REFERENCES order_schema.orders(order_id),

    CONSTRAINT fk_deliveries_driver
    FOREIGN KEY (driver_id)
    REFERENCES delivery_schema.delivery_drivers(driver_id),

    CONSTRAINT chk_delivery_status
    CHECK (status IN ('Assigned','Picked','OnTheWay','Delivered'))
);

CREATE INDEX idx_orders_user ON order_schema.orders(user_id);
CREATE INDEX idx_orders_restaurant ON order_schema.orders(restaurant_id);

CREATE INDEX idx_menuitems_restaurant ON restaurant_schema.menuitems(restaurant_id);

CREATE INDEX idx_orderitems_order ON order_schema.order_items(order_id);
CREATE INDEX idx_orderitems_menuitem ON order_schema.order_items(menuitem_id);