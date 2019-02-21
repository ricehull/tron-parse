package main

// ESCluster ...
type ESCluster struct {
	URL      []string
	TaskChan chan chan []byte
}

// NewESCluster ...
func NewESCluster(urls []string, bufferLen int) *ESCluster {
	ret := &ESCluster{
		URL:      urls,
		TaskChan: make(chan chan []byte, len(urls)),
	}

	for i := 0; i < len(urls); i++ {
		ret.TaskChan <- make(chan []byte, bufferLen)
	}
	return ret
}
