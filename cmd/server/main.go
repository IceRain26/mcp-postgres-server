package main

import (
    "context"
    "fmt"
    "log"
	"database/sql" 
    "github.com/IceRain26/mcp-server/internals/database"
    "github.com/IceRain26/mcp-server/tools"
    "github.com/modelcontextprotocol/go-sdk/mcp"
    "github.com/spf13/viper"
)

func main() {

	// Loading Configuration
	viper.SetConfigName("config")
	viper.SetConfigType("yaml")
	viper.AddConfigPath("../..")
	if err := viper.ReadInConfig(); err != nil {
		log.Fatalf("Error reading config file, %s", err)
	}

	var cfg database.Config
	if err := viper.Unmarshal(&cfg); err != nil {
		log.Fatalf("Unable to parse config, %v", err)
	}

	// Database Connection To PostgreSQL
	connStr := fmt.Sprintf(
		"host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		cfg.Database.Host, 
		cfg.Database.Port,
		cfg.Database.User,
		cfg.Database.Password,
		cfg.Database.DBname,
		cfg.Database.SSLMode,
	)

	var err error 
	database.DB, err = sql.Open("postgres", connStr)
	if err != nil {
		log.Fatalf("Error opening database: %v", err)
	}
	if err = database.DB.Ping(); err != nil {
		log.Fatalf("Error connecting to the database: %v", err)
	}
	log.Println("Successfully connected to the database.")


	// Creating MCP server
	server := mcp.NewServer(&mcp.Implementation{
		Name: cfg.Server.Name,
		Version: cfg.Server.Version,
	}, nil)

	mcp.AddTool(server, &mcp.Tool{
		Name: "query",
		Description: "Execute a read-only SQL Select query against database. Only SELECT statements are allowed.",
	}, tools.QueryTool)

	mcp.AddTool(server, &mcp.Tool{
		Name: "get_schema",
		Description: "Get the schema of the database.",
	}, tools.GetSchemaTool)

	if err := server.Run(context.Background(), &mcp.StdioTransport{}); err != nil {
		log.Fatal(err)
	}

}