# Databázové schéma

## Přehled tabulek

### 1. users
Uživatelé aplikace (chovatelé, majitelé psů)

```sql
- id (PK)
- username (UNIQUE)
- email (UNIQUE)
- password_hash
- first_name
- last_name
- phone
- address
- city
- zip_code
- country
- is_active
- email_verified_at
- created_at
- updated_at
```

### 2. dogs
Všichni psi v evidenci

```sql
- id (PK)
- registration_number (UNIQUE, např. číslo zápisu)
- name
- breed (plemeno)
- color (barva)
- gender (pohlaví: male/female)
- date_of_birth
- date_of_death (nullable)
- microchip_number
- tattoo_number
- health_notes (poznámky o zdraví)
- titles (tituly)
- photo_url
- father_id (FK -> dogs.id, nullable)
- mother_id (FK -> dogs.id, nullable)
- created_by (FK -> users.id)
- created_at
- updated_at
```

### 3. user_dogs
Propojení uživatelů s psy (majitelství)

```sql
- id (PK)
- user_id (FK -> users.id)
- dog_id (FK -> dogs.id)
- ownership_type (owner, breeder, co-owner)
- from_date
- to_date (nullable)
- notes
- created_at
- updated_at
```

### 4. pedigree_templates
Šablony pro generování rodokmenů

```sql
- id (PK)
- name
- description
- template_file (cesta k PDF šabloně)
- generations (počet generací: 3, 4, 5)
- is_default
- created_by (FK -> users.id)
- created_at
- updated_at
```

### 5. pedigree_exports
Historie vygenerovaných rodokmenů

```sql
- id (PK)
- dog_id (FK -> dogs.id)
- user_id (FK -> users.id)
- template_id (FK -> pedigree_templates.id)
- file_path
- generated_at
- created_at
```

### 6. breeding_records (volitelná - pro záznamy o vrhu)
```sql
- id (PK)
- mother_id (FK -> dogs.id)
- father_id (FK -> dogs.id)
- breeding_date
- birth_date
- number_of_puppies
- notes
- created_by (FK -> users.id)
- created_at
- updated_at
```

## Relace

- **dogs.father_id** → dogs.id (self-reference)
- **dogs.mother_id** → dogs.id (self-reference)
- **user_dogs.user_id** → users.id
- **user_dogs.dog_id** → dogs.id
- **pedigree_exports.dog_id** → dogs.id
- **pedigree_exports.user_id** → users.id

## Indexy

- users: email, username
- dogs: registration_number, father_id, mother_id, created_by
- user_dogs: user_id, dog_id, ownership_type

## Poznámky

- Rodokmen se generuje rekurzivním procházením father_id a mother_id
- Jeden pes může mít více majitelů v různých časových obdobích
- Šablony umožňují různé styly rodokmenů
