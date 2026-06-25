package tools

import (
	"context"

	"github.com/IceRain26/mcp-server/internals/database"
	"github.com/modelcontextprotocol/go-sdk/mcp"
)

type SchemaOutput struct {
	Tables []TableSchema `json:"tables"`
}

type TableSchema struct {
	Name    string         `json:"name"`
	Columns []ColumnSchema `json:"columns"`
}

type ColumnSchema struct {
	Name     string `json:"name"`
	DataType string `json:"data_type"`
	IsNull   bool   `json:"is_null"`
}

func GetSchemaTool(ctx context.Context, req *mcp.CallToolRequest, _ interface{}) (*mcp.CallToolResult, SchemaOutput, error) {
	// Query to get information
	rows, err := database.DB.QueryContext(ctx, `
		SELECT table_name, column_name, data_type, is_nullable
		FROM information_schema.columns
		WHERE table_schema = 'public'
		ORDER BY table_name, ordinal_position;
	`)
	if err != nil {
		return nil, SchemaOutput{}, err
	}
	defer rows.Close()

	tableMap := make(map[string][]ColumnSchema)

	for rows.Next() {
		var table, col, dataType, isNullable string
		if err := rows.Scan(&table, &col, &dataType, &isNullable); err != nil {
			return nil, SchemaOutput{}, err
		}

		tableMap[table] = append(tableMap[table], ColumnSchema{
			Name:     col,
			DataType: dataType,
			IsNull:   isNullable == "YES",
		})
	}

	var tables []TableSchema
	for name, cols := range tableMap {
		tables = append(tables, TableSchema{
			Name:    name,
			Columns: cols,
		})
	}

	return nil, SchemaOutput{Tables: tables}, nil

}
