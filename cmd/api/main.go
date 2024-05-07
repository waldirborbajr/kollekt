package main

import (
	"net/http"
	"time"

	"github.com/rs/zerolog/log"

	handlers "github.com/waldirborbajr/kollekt/internal"
)

func main() {
	mux := http.NewServeMux()
	mux.HandleFunc("GET /v1/healthz", handlers.Healthz)

	s := &http.Server{
		Addr:         ":4000",
		Handler:      mux,
		IdleTimeout:  time.Minute,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 30 * time.Second,
	}

	log.Printf("Starting server on %s", s.Addr)
	err := http.ListenAndServe(":4000", mux)
	log.Fatal().Msgf("ERROR: %v", err)
}
