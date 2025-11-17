SET search_path TO homework_3nf;

-- order_statuses
INSERT INTO order_statuses (status_name)
SELECT DISTINCT order_status
FROM stg_transactions
WHERE order_status IS NOT NULL;

-- brands
INSERT INTO brands (brand_name)
SELECT DISTINCT brand
FROM stg_products
WHERE brand IS NOT NULL;

-- product_lines
INSERT INTO product_lines (line_name)
SELECT DISTINCT product_line
FROM stg_products
WHERE product_line IS NOT NULL;

-- product_classes
INSERT INTO product_classes (class_name)
SELECT DISTINCT product_class
FROM stg_products
WHERE product_class IS NOT NULL;

-- product_sizes
INSERT INTO product_sizes (size_name)
SELECT DISTINCT product_size
FROM stg_products
WHERE product_size IS NOT NULL;

-- job_industry_categories
INSERT INTO job_industry_categories (category_name)
SELECT DISTINCT job_industry_category
FROM stg_customers
WHERE job_industry_category IS NOT NULL;

-- wealth_segments
INSERT INTO wealth_segments (segment_name)
SELECT DISTINCT wealth_segment
FROM stg_customers
WHERE wealth_segment IS NOT NULL;


SET search_path TO homework_3nf;

-- customers 
CREATE TABLE IF NOT EXISTS customers (
    customer_id             INT PRIMARY KEY,
    first_name              TEXT NOT NULL,
    last_name               TEXT,
    gender                  TEXT,
    dob                     DATE,
    job_title               TEXT,
    job_industry_category_id INT REFERENCES job_industry_categories(category_id),
    wealth_segment_id       INT REFERENCES wealth_segments(wealth_segment_id),
    deceased_indicator      VARCHAR(1),
    owns_car                VARCHAR(5)
);

-- products 
CREATE TABLE IF NOT EXISTS products (
    product_id   INT PRIMARY KEY,
    brand_id     INT REFERENCES brands(brand_id),
    line_id      INT REFERENCES product_lines(line_id),
    class_id     INT REFERENCES product_classes(class_id),
    size_id      INT REFERENCES product_sizes(size_id),
    list_price   NUMERIC(10,2) NOT NULL,
    standard_cost NUMERIC(10,2)
);

-- transactions 
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id  INT PRIMARY KEY,
    product_id      INT NOT NULL REFERENCES products(product_id),
    customer_id     INT NOT NULL REFERENCES customers(customer_id),
    transaction_date DATE NOT NULL,
    online_order    BOOLEAN,
    order_status_id INT REFERENCES order_statuses(order_status_id)
);

-- привязываем customer_address к customers 
ALTER TABLE customer_address
    ADD CONSTRAINT fk_customer_address_customer
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id);



SET search_path TO homework_3nf;

INSERT INTO customers (
    customer_id,
    first_name,
    last_name,
    gender,
    dob,
    job_title,
    job_industry_category_id,
    wealth_segment_id,
    deceased_indicator,
    owns_car
)
SELECT
    s.customer_id,
    s.first_name,
    NULLIF(s.last_name, '') AS last_name,
    s.gender,
    s.dob,
    s.job_title,
    j.category_id,
    w.wealth_segment_id,
    s.deceased_indicator,
    s.owns_car
FROM stg_customers s
LEFT JOIN job_industry_categories j
       ON s.job_industry_category = j.category_name
LEFT JOIN wealth_segments w
       ON s.wealth_segment = w.segment_name;


INSERT INTO customer_address (
    customer_id,
    address,
    postcode,
    state,
    country,
    property_valuation,
    is_current,
    valid_from
)
SELECT
    customer_id,
    address,
    postcode,
    state,
    country,
    property_valuation,
    TRUE,
    CURRENT_DATE
FROM stg_customers;

INSERT INTO products (
    product_id,
    brand_id,
    line_id,
    class_id,
    size_id,
    list_price,
    standard_cost
)
SELECT
    p.product_id,
    b.brand_id,
    l.line_id,
    c.class_id,
    s.size_id,
    p.list_price,
    p.standard_cost
FROM stg_products p
LEFT JOIN brands         b ON p.brand         = b.brand_name
LEFT JOIN product_lines  l ON p.product_line  = l.line_name
LEFT JOIN product_classes c ON p.product_class = c.class_name
LEFT JOIN product_sizes  s ON p.product_size  = s.size_name;


INSERT INTO transactions (
    transaction_id,
    product_id,
    customer_id,
    transaction_date,
    online_order,
    order_status_id
)
SELECT
    t.transaction_id,
    t.product_id,
    t.customer_id,
    t.transaction_date,
    CASE
        WHEN t.online_order ILIKE 'true'  THEN TRUE
        WHEN t.online_order ILIKE 'false' THEN FALSE
        ELSE NULL
    END AS online_order,
    os.order_status_id
FROM stg_transactions t
LEFT JOIN order_statuses os
       ON t.order_status = os.status_name;


