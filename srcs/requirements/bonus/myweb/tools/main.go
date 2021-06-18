package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func rootHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello world!\n\nI'm sikeda, 42Tokyo student.\n\nThis page powered by GO-lang.")
}

func main() {

	r := mux.NewRouter()
	r.HandleFunc("/myweb", rootHandler)

	http.Handle("/myweb", r)
	http.ListenAndServe(":3000", nil)
}
