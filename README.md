# Chap12_1 - SQL Gateway Application
## Query Examples:

```sql
-- Show all users
SELECT * FROM User;

-- Count users
SELECT COUNT(*) FROM User;

-- Search by name
SELECT * FROM User WHERE first_name LIKE 'J%';

-- Group by domain
SELECT SUBSTRING_INDEX(email, '@', -1) as domain, COUNT(*)
FROM User GROUP BY domain;
```
