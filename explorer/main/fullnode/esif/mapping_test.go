package main

import "testing"

func TestCreateMappingExchange(*testing.T) {

	Test = true

	initESNodes("http://localhost:9200")

	resetESIndex()
}
