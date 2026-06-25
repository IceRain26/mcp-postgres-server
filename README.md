# MCP server that exposes your database(PostgreSQL) database to AI applications.

## QUick Start
1. `docker-compose up -d`
2. `go run ./cmd/server
    or 
   npx @modelcontextprotocol/inspector go run . ` 
3. Connect to any MCP client

## Tools

- `query` - Execute read-only SQL SELECT queries
- `get_schema` - Get the complete database schema