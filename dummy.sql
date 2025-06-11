-- ===== ACTS =====
CREATE TABLE acts (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    year INT NOT NULL,
    effective_from DATE,
    last_amended DATE,
    version INT DEFAULT 1
);

INSERT INTO acts (name, year, effective_from, last_amended)
VALUES ('Income Tax Act', 1961, '1962-04-01', '2023-07-01');

-- ===== CHAPTERS =====
CREATE TABLE chapters (
    id SERIAL PRIMARY KEY,
    act_id INT REFERENCES acts(id),
    number TEXT NOT NULL,
    title TEXT
);

INSERT INTO chapters (act_id, number, title)
VALUES (1, 'VI-A', 'Deductions from Total Income');

-- ===== SECTIONS =====
CREATE TABLE sections (
    id SERIAL PRIMARY KEY,
    chapter_id INT REFERENCES chapters(id),
    number TEXT NOT NULL,
    title TEXT,
    text TEXT,
    search_index TSVECTOR
);

INSERT INTO sections (chapter_id, number, title, text)
VALUES (1, '80C', 'Deduction for life insurance premium', 'Full section text about 80C');

-- ===== SUBSECTIONS =====
CREATE TABLE subsections (
    id SERIAL PRIMARY KEY,
    section_id INT REFERENCES sections(id),
    number TEXT,
    text TEXT
);

INSERT INTO subsections (section_id, number, text)
VALUES (1, '1', 'Subsection 1 text of 80C');

-- ===== CLAUSES =====
CREATE TABLE clauses (
    id SERIAL PRIMARY KEY,
    subsection_id INT REFERENCES subsections(id),
    identifier TEXT,
    text TEXT
);

INSERT INTO clauses (subsection_id, identifier, text)
VALUES (1, 'a', 'Clause a text');

-- ===== RULES =====
CREATE TABLE rules (
    id SERIAL PRIMARY KEY,
    rule_number TEXT NOT NULL,
    related_section_id INT REFERENCES sections(id),
    text TEXT,
    effective_from DATE,
    last_amended DATE
);

INSERT INTO rules (rule_number, related_section_id, text)
VALUES ('2A', 1, 'Explanation of Rule 2A');

-- ===== CIRCULARS =====
CREATE TABLE circulars (
    id SERIAL PRIMARY KEY,
    circular_number TEXT NOT NULL,
    date DATE,
    summary TEXT,
    related_section_id INT REFERENCES sections(id),
    full_text TEXT
);

INSERT INTO circulars (circular_number, date, summary, related_section_id, full_text)
VALUES ('Circular No. 14/2021', '2021-07-01', 'Clarification on Section 80C', 1, 'Full text of circular.');

-- ===== CASE LAW =====
CREATE TABLE case_law (
    id SERIAL PRIMARY KEY,
    title TEXT,
    court TEXT,
    citation TEXT,
    summary TEXT,
    related_section_id INT REFERENCES sections(id),
    judgment_text TEXT
);

INSERT INTO case_law (title, court, citation, summary, related_section_id, judgment_text)
VALUES ('ABC v. IT Dept.', 'Supreme Court', '2023 AIR SC 123', 'Important judgment on 80C', 1, 'Full judgment text.');

-- ===== CROSS REFERENCES =====
CREATE TABLE section_cross_references (
    id SERIAL PRIMARY KEY,
    from_section_id INT REFERENCES sections(id),
    to_section_id INT REFERENCES sections(id)
);

-- ===== MANY-TO-MANY LINK TABLES =====
CREATE TABLE rule_section_link (
    rule_id INT REFERENCES rules(id),
    section_id INT REFERENCES sections(id),
    PRIMARY KEY (rule_id, section_id)
);

CREATE TABLE circular_section_link (
    circular_id INT REFERENCES circulars(id),
    section_id INT REFERENCES sections(id),
    PRIMARY KEY (circular_id, section_id)
);

CREATE TABLE case_law_section_link (
    case_law_id INT REFERENCES case_law(id),
    section_id INT REFERENCES sections(id),
    PRIMARY KEY (case_law_id, section_id)
);

-- ===== AMENDMENTS =====
CREATE TABLE amendments (
    id SERIAL PRIMARY KEY,
    section_id INT REFERENCES sections(id),
    amended_on DATE NOT NULL,
    amendment_text TEXT NOT NULL,
    source TEXT
);

-- ===== FORMS =====
CREATE TABLE forms (
    id SERIAL PRIMARY KEY,
    form_name TEXT NOT NULL,
    form_number TEXT,
    description TEXT,
    related_section_id INT REFERENCES sections(id),
    related_rule_id INT REFERENCES rules(id),
    filing_deadline DATE
);

-- ===== CONDITIONS =====
CREATE TABLE section_conditions (
    id SERIAL PRIMARY KEY,
    section_id INT REFERENCES sections(id),
    condition TEXT NOT NULL,
    user_type TEXT
);

-- ===== LOGIC EXPRESSIONS =====
CREATE TABLE logical_expressions (
    id SERIAL PRIMARY KEY,
    section_id INT REFERENCES sections(id),
    expression TEXT NOT NULL,
    type TEXT,
    source_clause_id INT REFERENCES clauses(id)
);

-- ===== KEYWORDS =====
CREATE TABLE keywords (
    id SERIAL PRIMARY KEY,
    section_id INT REFERENCES sections(id),
    keyword TEXT NOT NULL,
    confidence_score FLOAT DEFAULT 1.0,
    source TEXT DEFAULT 'manual'
);
