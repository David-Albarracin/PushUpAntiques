-- -----------------------------------------------------
-- Schema antiques_db
-- -----------------------------------------------------
drop database antiques_db;
CREATE SCHEMA IF NOT EXISTS `antiques_db` DEFAULT CHARACTER SET utf8;
USE `antiques_db`;

-- -----------------------------------------------------
-- Table `roles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` INT NOT NULL AUTO_INCREMENT,
  `role_name` VARCHAR(45) NULL,
  PRIMARY KEY (`role_id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(255) NULL,
  `role_id` INT NOT NULL,
  PRIMARY KEY (`user_id`),
  INDEX `fk_users_roles1_idx` (`role_id` ASC),
  CONSTRAINT `fk_users_roles1`
    FOREIGN KEY (`role_id`)
    REFERENCES `roles` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `products` (
  `product_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NULL,
  `description` VARCHAR(255) null,
  `category` VARCHAR(45) NULL,
  `price` DECIMAL(10, 2) NULL,
  `photo_url` VARCHAR(450) NULL,
  `era` VARCHAR(45) NULL,
  PRIMARY KEY (`product_id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `transactions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `transactions` (
  `transaction_id` INT NOT NULL AUTO_INCREMENT,
  `buyer_id` INT NOT NULL,
  `seller_id` INT NOT NULL,
  `transaction_date` DATETIME NULL,
  `total` DECIMAL(10, 2) NULL,
  `transaction_type` ENUM('sold', 'purchased') NULL,
  PRIMARY KEY (`transaction_id`),
  INDEX `fk_transactions_users1_idx` (`buyer_id` ASC),
  INDEX `fk_transactions_users2_idx` (`seller_id` ASC),
  CONSTRAINT `fk_transactions_users1`
    FOREIGN KEY (`buyer_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transactions_users2`
    FOREIGN KEY (`seller_id`)
    REFERENCES `users` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `permissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `permissions` (
  `permission_id` INT NOT NULL AUTO_INCREMENT,
  `permission_name` VARCHAR(45) NULL,
  PRIMARY KEY (`permission_id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `transaction_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `transaction_products` (
  `transaction_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `amount` INT NULL,
  `sub_total` DECIMAL(10, 2) NULL,
  INDEX `fk_transaction_products_transactions1_idx` (`transaction_id` ASC),
  INDEX `fk_transaction_products_products1_idx` (`product_id` ASC),
  CONSTRAINT `fk_transaction_products_transactions1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `transactions` (`transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_products_products1`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `role_permissions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `role_permissions` (
  `role_id` INT NOT NULL,
  `permission_id` INT NOT NULL,
  INDEX `fk_role_permissions_roles1_idx` (`role_id` ASC),
  INDEX `fk_role_permissions_permissions1_idx` (`permission_id` ASC),
  CONSTRAINT `fk_role_permissions_roles1`
    FOREIGN KEY (`role_id`)
    REFERENCES `roles` (`role_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_role_permissions_permissions1`
    FOREIGN KEY (`permission_id`)
    REFERENCES `permissions` (`permission_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `payments` (
  `payment_id` INT NOT NULL AUTO_INCREMENT,
  `transaction_id` INT NOT NULL,
  `payment_method` ENUM('credit_card', 'paypal', 'bank_transfer') NULL,
  `payment_date` DATETIME NULL,
  `payment_amount` DECIMAL(10, 2) NULL, 
  PRIMARY KEY (`payment_id`),
  INDEX `fk_payments_transactions1_idx` (`transaction_id` ASC),
  CONSTRAINT `fk_payments_transactions1`
    FOREIGN KEY (`transaction_id`)
    REFERENCES `transactions` (`transaction_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `warehouse`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse` (
  `warehouse_id` INT NOT NULL AUTO_INCREMENT,
  `warehouse_name` VARCHAR(100) NULL,
  `warehouse_address` VARCHAR(255) NULL,
  PRIMARY KEY (`warehouse_id`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `warehouse_products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `warehouse_products` (
  `warehouse_id` INT NOT NULL,
  `product_id` INT NOT NULL,
  `amount` INT NULL,
  `status` ENUM('for_sale', 'sold', 'withdrawn') NULL,
  INDEX `fk_warehouse_products_warehouse1_idx` (`warehouse_id` ASC),
  INDEX `fk_warehouse_products_products1_idx` (`product_id` ASC),
  CONSTRAINT `fk_warehouse_products_warehouse1`
    FOREIGN KEY (`warehouse_id`)
    REFERENCES `warehouse` (`warehouse_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_warehouse_products_products1`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `conservation_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `conservation_status` (
  `conservation_status_id` INT NOT NULL AUTO_INCREMENT,
  `message` VARCHAR(255) NULL, -- Ajuste para un mensaje más largo
  `product_id` INT NOT NULL,
  PRIMARY KEY (`conservation_status_id`),
  INDEX `fk_conservation_status_products1_idx` (`product_id` ASC),
  CONSTRAINT `fk_conservation_status_products1`
    FOREIGN KEY (`product_id`)
    REFERENCES `products` (`product_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Inserts en la tabla `roles`
-- -----------------------------------------------------
INSERT INTO `roles` (`role_name`) VALUES 
('Admin'),
('User'),
('Seller'),
('Buyer');

-- -----------------------------------------------------
-- Inserts en la tabla `users`
-- -----------------------------------------------------
INSERT INTO `users` (`user_name`, `email`, `password`, `role_id`) VALUES 
('Admin1', 'admin1@example.com', 'hashed_password1', 1),
('User1', 'user1@example.com', 'hashed_password2', 2),
('Seller1', 'seller1@example.com', 'hashed_password3', 3),
('Buyer1', 'buyer1@example.com', 'hashed_password4', 4);

-- -----------------------------------------------------
-- Inserts en la tabla `products`
-- -----------------------------------------------------
INSERT INTO `products` (`name`, `description`, `category`, `price`, `photo_url`, `era`) VALUES 
('Antique Vase', 'A beautiful vase from the 18th century', 'Decor', 350.00, 'vase.jpg', '18th Century'),
('Old Clock', 'An antique clock with gold finish', 'Timepieces', 1200.00, 'clock.jpg', '19th Century');

-- -----------------------------------------------------
-- Inserts en la tabla `transactions`
-- -----------------------------------------------------
INSERT INTO `transactions` (`buyer_id`, `seller_id`, `transaction_date`, `total`, `transaction_type`) VALUES 
(4, 3, '2024-09-15 12:30:00', 1550.00, 'purchased'),
(4, 3, '2024-09-16 13:45:00', 350.00, 'purchased');

-- -----------------------------------------------------
-- Inserts en la tabla `permissions`
-- -----------------------------------------------------
INSERT INTO `permissions` (`permission_name`) VALUES 
('View Products'),
('Edit Products'),
('Delete Products'),
('Manage Users');

-- -----------------------------------------------------
-- Inserts en la tabla `transaction_products`
-- -----------------------------------------------------
INSERT INTO `transaction_products` (`transaction_id`, `product_id`, `amount`, `sub_total`) VALUES 
(1, 1, 1, 350.00),
(1, 2, 1, 1200.00),
(2, 1, 1, 350.00);

-- -----------------------------------------------------
-- Inserts en la tabla `role_permissions`
-- -----------------------------------------------------
INSERT INTO `role_permissions` (`role_id`, `permission_id`) VALUES 
(1, 1), -- Admin tiene permiso de ver productos
(1, 2), -- Admin tiene permiso de editar productos
(1, 3), -- Admin tiene permiso de eliminar productos
(1, 4), -- Admin puede gestionar usuarios
(2, 1), -- Usuario tiene permiso de ver productos
(3, 1), -- Vendedor puede ver productos
(4, 1); -- Comprador puede ver productos

-- -----------------------------------------------------
-- Inserts en la tabla `payments`
-- -----------------------------------------------------
INSERT INTO `payments` (`transaction_id`, `payment_method`, `payment_date`, `payment_amount`) VALUES 
(1, 'credit_card', '2024-09-15 12:45:00', 1550.00),
(2, 'paypal', '2024-09-16 14:00:00', 350.00);

-- -----------------------------------------------------
-- Inserts en la tabla `warehouse`
-- -----------------------------------------------------
INSERT INTO `warehouse` (`warehouse_name`, `warehouse_address`) VALUES 
('Main Warehouse', '123 Antique St.'),
('Secondary Warehouse', '456 Vintage Blvd.');

-- -----------------------------------------------------
-- Inserts en la tabla `warehouse_products`
-- -----------------------------------------------------
INSERT INTO `warehouse_products` (`warehouse_id`, `product_id`, `amount`, `status`) VALUES 
(1, 1, 10, 'for_sale'),
(1, 2, 5, 'for_sale');

-- -----------------------------------------------------
-- Inserts en la tabla `conservation_status`
-- -----------------------------------------------------
INSERT INTO `conservation_status` (`message`, `product_id`) VALUES 
('Good condition', 1),
('Needs restoration', 2);
