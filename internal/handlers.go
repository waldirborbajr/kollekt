package handlers

import (
	"encoding/json"
	"log"
	"net/http"
)

type statusCode struct {
	Status  string `json:"status"`
	Code    int    `json:"code"`
	Message string `json:"message"`
}

type textToSpeech struct {
	Text string `json:"text"`
}

// Show the status of api
func Healthz(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	status := &statusCode{
		Code:    http.StatusOK,
		Status:  "Online",
		Message: "API is running smoothly",
	}

	statusJson, _ := json.Marshal(status)
	if _, err := w.Write(statusJson); err != nil {
		log.Panicf("Error to parssing statusJson to json, error: %v", err)
	}
}
