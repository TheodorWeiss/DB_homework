-- 1. genders
CREATE TABLE genders (
    gender_id SERIAL PRIMARY KEY,
    gender_name VARCHAR(50) NOT NULL
);

-- 2. job industry categories
CREATE TABLE job_industry_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

-- 3. wealth segments
CREATE TABLE wealth_segments (
    segment_id SERIAL PRIMARY KEY,
    segment_name VARCHAR(100) NOT NULL
);

-- 4. brands
CREATE TABLE brands (
    brand_id SERIAL PRIMARY KEY,
    brand_name VARCHAR(100) NOT NULL
);

-- 5. product lines
CREATE TABLE product_lines (
    line_id SERIAL PRIMARY KEY,
    line_name VARCHAR(100) NOT NULL
);

-- 6. product classes
CREATE TABLE product_classes (
    class_id SERIAL PRIMARY KEY,
    class_name VARCHAR(100) NOT NULL
);

-- 7. product sizes
CREATE TABLE product_sizes (
    size_id SERIAL PRIMARY KEY,
    size_name VARCHAR(50) NOT NULL
);

-- 8. order statuses
CREATE TABLE order_statuses (
    order_status_id SERIAL PRIMARY KEY,
    status_name VARCHAR(100) NOT NULL
);
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    gender_id INT REFERENCES genders(gender_id),
    dob DATE NOT NULL,
    job_title VARCHAR(100),
    job_industry_category_id INT REFERENCES job_industry_categories(category_id),
    wealth_segment_id INT REFERENCES wealth_segments(segment_id),
    deceased_indicator CHAR(1) NOT NULL,
    owns_car VARCHAR(10) NOT NULL
);
CREATE TABLE customer_address (
    address_id SERIAL PRIMARY KEY,
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    address TEXT NOT NULL,
    postcode INT NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    property_valuation INT NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    brand_id INT REFERENCES brands(brand_id),
    line_id INT REFERENCES product_lines(line_id),
    class_id INT REFERENCES product_classes(class_id),
    size_id INT REFERENCES product_sizes(size_id),
    created_date DATE NOT NULL DEFAULT CURRENT_DATE
);
CREATE TABLE product_price (
    price_id SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    list_price NUMERIC(10,2) NOT NULL,
    standard_cost NUMERIC(10,2) NOT NULL,
    valid_from DATE NOT NULL,
    valid_to DATE,
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE transactions (
    transaction_id INT PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(product_id),
    customer_id INT NOT NULL REFERENCES customers(customer_id),
    transaction_date DATE NOT NULL,
    online_order BOOLEAN NOT NULL,
    order_status_id INT REFERENCES order_statuses(order_status_id)
);

-- staging customers
CREATE TABLE IF NOT EXISTS homework_3nf.stg_customers (
    customer_id           INT,
    first_name            TEXT,
    last_name             TEXT,
    gender                TEXT,
    dob                   DATE,
    job_title             TEXT,
    job_industry_category TEXT,
    wealth_segment        TEXT,
    deceased_indicator    TEXT,
    owns_car              TEXT,
    address               TEXT,
    postcode              INT,
    state                 TEXT,
    country               TEXT,
    property_valuation    INT
);

-- staging products
CREATE TABLE IF NOT EXISTS homework_3nf.stg_products (
    product_id    INT,
    brand         TEXT,
    product_line  TEXT,
    product_class TEXT,
    product_size  TEXT,
    standard_cost NUMERIC(10,2),
    list_price    NUMERIC(10,2)
);

-- staging transactions
CREATE TABLE IF NOT EXISTS homework_3nf.stg_transactions (
    transaction_id   INT,
    product_id       INT,
    customer_id      INT,
    transaction_date DATE,
    online_order     TEXT,
    order_status     TEXT
);
