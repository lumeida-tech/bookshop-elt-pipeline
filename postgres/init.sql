-- ============================================================
-- BOOKSHOP - Base de données source PostgreSQL
-- ============================================================

-- ──────────────────────────────────────────────────────────
-- TABLE : category
-- ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS category (
    id         SERIAL PRIMARY KEY,
    intitule   VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────────────────────
-- TABLE : books
-- ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS books (
    id          SERIAL PRIMARY KEY,
    category_id INTEGER REFERENCES category(id),
    code        VARCHAR(20)  NOT NULL,
    intitule    VARCHAR(200) NOT NULL,
    isbn_10     VARCHAR(10),
    isbn_13     VARCHAR(13),
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────────────────────
-- TABLE : customers
-- ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS customers (
    id         SERIAL PRIMARY KEY,
    code       VARCHAR(20)  NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name  VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────────────────────
-- TABLE : factures
-- NB : date_edit est au format VARCHAR 'YYYYMMDD'
-- ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS factures (
    id           SERIAL PRIMARY KEY,
    code         VARCHAR(20) NOT NULL,
    date_edit    VARCHAR(8)  NOT NULL,
    customers_id INTEGER REFERENCES customers(id),
    qte_totale   INTEGER     NOT NULL,
    total_amount FLOAT       NOT NULL,
    total_paid   FLOAT       NOT NULL,
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ──────────────────────────────────────────────────────────
-- TABLE : ventes
-- NB : date_edit est au format VARCHAR 'YYYYMMDD'
-- ──────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS ventes (
    id          SERIAL PRIMARY KEY,
    code        VARCHAR(20) NOT NULL,
    date_edit   VARCHAR(8)  NOT NULL,
    factures_id INTEGER REFERENCES factures(id),
    books_id    INTEGER REFERENCES books(id),
    pu          FLOAT   NOT NULL,
    qte         INTEGER NOT NULL,
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- DONNÉES : category
-- ============================================================
INSERT INTO category (intitule) VALUES
    ('Fiction'),
    ('Science'),
    ('Histoire'),
    ('Informatique');


-- ============================================================
-- DONNÉES : books
-- ============================================================
INSERT INTO books (category_id, code, intitule, isbn_10, isbn_13) VALUES
    (1, 'BK001', 'Le Petit Prince',               '2070612761', '9782070612765'),
    (1, 'BK002', 'Les Misérables',                '2070409236', '9782070409235'),
    (1, 'BK003', '1984',                          '2070368122', '9782070368129'),
    (2, 'BK004', 'Une Brève Histoire du Temps',   '2081275430', '9782081275430'),
    (2, 'BK005', 'Le Gène Égoïste',               '2081222447', '9782081222441'),
    (3, 'BK006', 'Sapiens',                       '2226257012', '9782226257017'),
    (3, 'BK007', 'Le Monde d Hier',               '2253006416', '9782253006411'),
    (4, 'BK008', 'Clean Code',                    '0132350882', '9780132350884'),
    (4, 'BK009', 'The Pragmatic Programmer',      '020161622X', '9780201616224'),
    (4, 'BK010', 'Design Patterns',               '0201633612', '9780201633610');


-- ============================================================
-- DONNÉES : customers
-- ============================================================
INSERT INTO customers (code, first_name, last_name) VALUES
    ('CLI001', 'Jean',     'Dupont'),
    ('CLI002', 'Marie',    'Martin'),
    ('CLI003', 'Pierre',   'Bernard'),
    ('CLI004', 'Sophie',   'Leroy'),
    ('CLI005', 'Lucas',    'Petit'),
    ('CLI006', 'Emma',     'Durand'),
    ('CLI007', 'Nicolas',  'Moreau'),
    ('CLI008', 'Camille',  'Simon');


-- ============================================================
-- DONNÉES : factures
-- date_edit au format YYYYMMDD (VARCHAR)
-- ============================================================
INSERT INTO factures (code, date_edit, customers_id, qte_totale, total_amount, total_paid) VALUES
    ('FAC001', '20240115', 1, 2,  35.00,  35.00),
    ('FAC002', '20240220', 2, 1,  22.50,  22.50),
    ('FAC003', '20240310', 3, 3,  67.00,  50.00),
    ('FAC004', '20240415', 1, 2,  45.00,  45.00),
    ('FAC005', '20240520', 4, 1,  18.90,  18.90),
    ('FAC006', '20240615', 5, 4,  89.00,  89.00),
    ('FAC007', '20240710', 2, 2,  42.00,  42.00),
    ('FAC008', '20240815', 6, 1,  24.90,  20.00),
    ('FAC009', '20240920', 7, 3,  78.50,  78.50),
    ('FAC010', '20241010', 3, 2,  38.00,  38.00),
    ('FAC011', '20241115', 8, 1,  19.90,  19.90),
    ('FAC012', '20241220', 4, 5, 112.00, 112.00);


-- ============================================================
-- DONNÉES : ventes
-- date_edit au format YYYYMMDD (VARCHAR)
-- ============================================================
INSERT INTO ventes (code, date_edit, factures_id, books_id, pu, qte) VALUES
    ('VNT001', '20240115',  1,  1, 12.50, 1),
    ('VNT002', '20240115',  1,  8, 22.50, 1),
    ('VNT003', '20240220',  2,  4, 22.50, 1),
    ('VNT004', '20240310',  3,  2, 14.00, 2),
    ('VNT005', '20240310',  3,  6, 19.90, 1),
    ('VNT006', '20240415',  4,  8, 22.50, 1),
    ('VNT007', '20240415',  4,  3, 11.50, 1),
    ('VNT008', '20240520',  5,  1, 12.50, 1),
    ('VNT009', '20240615',  6,  9, 24.90, 1),
    ('VNT010', '20240615',  6, 10, 28.00, 1),
    ('VNT011', '20240615',  6,  5, 18.90, 1),
    ('VNT012', '20240615',  6,  7, 15.00, 1),
    ('VNT013', '20240710',  7,  2, 14.00, 1),
    ('VNT014', '20240710',  7,  6, 19.90, 1),
    ('VNT015', '20240815',  8,  4, 22.50, 1),
    ('VNT016', '20240920',  9,  8, 22.50, 1),
    ('VNT017', '20240920',  9,  9, 24.90, 1),
    ('VNT018', '20240920',  9, 10, 28.00, 1),
    ('VNT019', '20241010', 10,  1, 12.50, 1),
    ('VNT020', '20241010', 10,  3, 11.50, 1),
    ('VNT021', '20241115', 11,  6, 19.90, 1),
    ('VNT022', '20241220', 12,  8, 22.50, 2),
    ('VNT023', '20241220', 12,  9, 24.90, 1),
    ('VNT024', '20241220', 12, 10, 28.00, 1),
    ('VNT025', '20241220', 12,  2, 14.00, 1);
