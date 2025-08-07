CREATE SCHEMA raw; 


CREATE TABLE raw.claim_providers (
    claim_id VARCHAR(100) NOT NULL,
    provider_id VARCHAR(100) NOT NULL,
    provider_role VARCHAR(100)
);


CREATE TABLE raw.claims (
    claim_id VARCHAR(100) NOT NULL,
    patient_id VARCHAR(100) NOT NULL,
    service_date DATE NOT NULL,
    claim_submitted_date DATE NOT NULL,
    claim_type VARCHAR(100),
    place_of_service VARCHAR(100),
    diagnosis_codes TEXT,
    diagnosis_descriptions TEXT,
    procedure_codes TEXT,
    procedure_descriptions TEXT,
    billed_amount NUMERIC(12,2),
    allowed_amount NUMERIC(12,2),
    deductible_amount NUMERIC(12,2),
    coinsurance_amount NUMERIC(12,2),
    copay_amount NUMERIC(12,2),
    insurance_paid_amount NUMERIC(12,2),
    patient_responsibility NUMERIC(12,2),
    claim_status VARCHAR(100),
    denial_reason VARCHAR(255),
    is_in_network BOOLEAN,
    network_tier VARCHAR(100),
    prior_auth_number VARCHAR(100),
    processed_date DATE
);

CREATE TABLE raw.patients (
    patient_id VARCHAR(100) PRIMARY KEY,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    maternal_surname VARCHAR(100),
    date_of_birth DATE,
    gender CHAR(1),
    curp VARCHAR(100),
    street_address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(100),
    email VARCHAR(100),
    plan_name VARCHAR(100),
    plan_code VARCHAR(100),
    policy_number VARCHAR(100),
    group_id VARCHAR(100),
    enrollment_date DATE,
    is_active BOOLEAN,
    annual_deductible NUMERIC(12,2),
    annual_out_of_pocket_max NUMERIC(12,2)
);


CREATE TABLE raw.providers (
    provider_id VARCHAR(100) PRIMARY KEY,
    provider_name VARCHAR(200),
    provider_type VARCHAR(100),
    specialty VARCHAR(100),
    cedula_profesional VARCHAR(50),
    tax_id VARCHAR(50),
    street_address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    zip_code VARCHAR(50),
    phone VARCHAR(50),
    email VARCHAR(150),
    network_tier VARCHAR(100),
    contract_start_date DATE,
    contract_end_date DATE,
    is_accepting_patients BOOLEAN,
    quality_rating NUMERIC(3,1)
);
