package database

import (
	_ "github.com/lib/pq"
	"database/sql"


	
)

type Config struct {
	Database struct {
		Host	   string `mapstructure:"host"`
		Port   	   int    `mapstructure:"port"`
		User  	   string `mapstructure:"user"`
		Password   string `mapstructure:"password"`
		DBname     string `mapstructure:"dbname"`
		SSLMode    string `mapstructure:"sslmode"`
	} `mapstructure:"database"`
	Server struct {
		Name	string `mapstructure:"name"`
		Version string `mapstructure:"version"`
	} `mapstructure:"server"`
}

var DB *sql.DB
