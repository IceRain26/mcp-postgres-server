package tools

import (
    "context"
    "fmt"
    "strings"
    "github.com/modelcontextprotocol/go-sdk/mcp"
	"github.com/IceRain26/mcp-server/internals/database"
	

)

type QueryInput struct {
	SQL string `json:"sql" jsonschema:"The SELECT query to execute. LIMIT 10"`
}

type QueryOutput struct {
	Columns []string `json:"columns"`
	Rows   [][]interface{} `json:"rows"`
	Count int `json:"count"`
}

func QueryTool(ctx context.Context, req *mcp.CallToolRequest, input *QueryInput) (*mcp.CallToolResult, QueryOutput, error){

	// Validation of SELECT Query
	sqlLower := strings.ToLower(strings.TrimSpace(input.SQL))
	if !strings.HasPrefix(sqlLower, "select") {
		return nil, QueryOutput{}, fmt.Errorf("only SELECT queries are allowed")
	}

	// Security against Dangerous keywords
	dangerousKeywords := []string{"insert", "update", "delete", "drop", "alter", "create", "truncate"}
	for _, keyword := range dangerousKeywords {
		if strings.Contains(sqlLower, keyword){
			return nil, QueryOutput{}, fmt.Errorf("dangerous keyword detected in query: %s", keyword)
		}
	}

	rows, err := database.DB.QueryContext(ctx, input.SQL)
	if err != nil {
		return nil, QueryOutput{}, err
	}
	defer rows.Close()
	
	cols, err := rows.Columns()
	if err != nil {
		return nil, QueryOutput{}, err
	}

	var results [][]interface{}
	
	const MaxRows = 100
	rowCount := 0

	for rows.Next() {
		if rowCount >= MaxRows {
			break
		}
		rowCount++
		row := make([]interface{}, len(cols))
		rowPtrs := make([]interface{}, len(cols))
		for i := range row {
			rowPtrs[i] = &row[i]
		}
		if err := rows.Scan(rowPtrs...); err != nil {
			return nil, QueryOutput{}, err
		}

		// convert to string 
		strRow := make([]interface{}, len(row))
		for i, val := range row {
			// Handle Null and Bytes
			if val == nil {
				strRow[i] = nil
			} else {
				switch v := val.(type) {
				case []byte:
					strRow[i] = string(v)
				default:
					strRow[i] = v
				}
			}
		}
		results = append(results, strRow)
	}

	return nil, QueryOutput{
			Columns: cols,
			Rows: results,
			Count: len(results),
		}, nil

}