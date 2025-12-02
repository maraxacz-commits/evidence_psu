-- Vytvoření databáze
CREATE DATABASE IF NOT EXISTS evidence_psu CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE evidence_psu;

-- Tabulka uživatelů
CREATE TABLE users (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    address VARCHAR(255),
    city VARCHAR(100),
    zip_code VARCHAR(20),
    country VARCHAR(100) DEFAULT 'Czech Republic',
    is_active BOOLEAN DEFAULT TRUE,
    email_verified_at TIMESTAMP NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_email (email),
    INDEX idx_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Tabulka psů
CREATE TABLE dogs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    registration_number VARCHAR(50) UNIQUE,
    name VARCHAR(100) NOT NULL,
    breed VARCHAR(100) NOT NULL,
    color VARCHAR(50),
    gender ENUM('male', 'female') NOT NULL,
    date_of_birth DATE NOT NULL,
    date_of_death DATE NULL,
    microchip_number VARCHAR(50),
    tattoo_number VARCHAR(50),
    health_notes TEXT,
    titles VARCHAR(255),
    photo_url VARCHAR(255),
    father_id BIGINT UNSIGNED NULL,
    mother_id BIGINT UNSIGNED NULL,
    created_by BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (father_id) REFERENCES dogs(id) ON DELETE SET NULL,
    FOREIGN KEY (mother_id) REFERENCES dogs(id) ON DELETE SET NULL,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_registration (registration_number),
    INDEX idx_father (father_id),
    INDEX idx_mother (mother_id),
    INDEX idx_created_by (created_by),
    INDEX idx_breed (breed)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Propojení uživatelů s psy (majitelství)
CREATE TABLE user_dogs (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    user_id BIGINT UNSIGNED NOT NULL,
    dog_id BIGINT UNSIGNED NOT NULL,
    ownership_type ENUM('owner', 'breeder', 'co-owner') DEFAULT 'owner',
    from_date DATE NOT NULL,
    to_date DATE NULL,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (dog_id) REFERENCES dogs(id) ON DELETE CASCADE,
    INDEX idx_user (user_id),
    INDEX idx_dog (dog_id),
    INDEX idx_ownership (ownership_type),
    UNIQUE KEY unique_active_ownership (user_id, dog_id, ownership_type, to_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Šablony rodokmenů
CREATE TABLE pedigree_templates (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    template_file VARCHAR(255) NOT NULL,
    generations TINYINT DEFAULT 3,
    is_default BOOLEAN DEFAULT FALSE,
    created_by BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_default (is_default)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Historie vygenerovaných rodokmenů
CREATE TABLE pedigree_exports (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    dog_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
    template_id BIGINT UNSIGNED NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    generated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (dog_id) REFERENCES dogs(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (template_id) REFERENCES pedigree_templates(id) ON DELETE CASCADE,
    INDEX idx_dog (dog_id),
    INDEX idx_user (user_id),
    INDEX idx_generated (generated_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Volitelná tabulka pro záznamy o vrhu
CREATE TABLE breeding_records (
    id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    mother_id BIGINT UNSIGNED NOT NULL,
    father_id BIGINT UNSIGNED NOT NULL,
    breeding_date DATE NOT NULL,
    birth_date DATE,
    number_of_puppies TINYINT,
    notes TEXT,
    created_by BIGINT UNSIGNED NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (mother_id) REFERENCES dogs(id) ON DELETE CASCADE,
    FOREIGN KEY (father_id) REFERENCES dogs(id) ON DELETE CASCADE,
    FOREIGN KEY (created_by) REFERENCES users(id) ON DELETE CASCADE,
    INDEX idx_mother (mother_id),
    INDEX idx_father (father_id),
    INDEX idx_birth_date (birth_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
