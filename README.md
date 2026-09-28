## Database

The project uses PostgreSQL for the business data layer.

### Database files

- `sql/schema.sql` — creates the database tables and constraints
- `sql/seed.sql` — inserts reproducible sample business data
- `sql/business_queries.sql` — contains business analysis queries
- `db_check.py` — verifies Python-to-PostgreSQL connectivity
- `week2_check.py` — runs core business queries from Python

### Rebuild the database

```bash
psql -h localhost -U analytics_user -d enterprise_analytics -f sql/schema.sql
psql -h localhost -U analytics_user -d enterprise_analytics -f sql/seed.sql
