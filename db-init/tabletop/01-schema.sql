-- Schema pentru tabletop_db (Catalog + Order)
-- Se incarca automat la primul start al containerului Postgres

CREATE TABLE IF NOT EXISTS users (
    userID INT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    role VARCHAR(20) DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS games (
    gameID SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    min_players INT,
    max_player INT,
    difficulty VARCHAR(20),
    category VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS orders (
    orderID SERIAL PRIMARY KEY,
    userID INT REFERENCES users(userID) ON DELETE CASCADE,
    total_price DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS order_items (
    itemID SERIAL PRIMARY KEY,
    orderID INT REFERENCES orders(orderID) ON DELETE CASCADE,
    gameID INT REFERENCES games(gameID),
    quantity INT NOT NULL,
    price_per_unit DECIMAL(10, 2) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_orders_userid ON orders(userID);
CREATE INDEX IF NOT EXISTS idx_order_items_orderid ON order_items(orderID);
CREATE INDEX IF NOT EXISTS idx_games_category ON games(category);
