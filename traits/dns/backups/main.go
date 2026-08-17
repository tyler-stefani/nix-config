package main

import (
	"flag"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func main() {
	url := flag.String("url", "", "Technitium API base URL, e.g. http://192.168.1.200:5380")
	tokenFile := flag.String("token-file", "", "file containing the API bearer token")
	out := flag.String("out", "", "path to write the backup zip to")
	flag.Parse()

	token, err := os.ReadFile(*tokenFile)
	if err != nil {
		fatal(err)
	}

	params := []string{
		"authConfig=true",
		"dnsSettings=true",
		"zones=true",
		"allowedZones=true",
		"blockedZones=true",
		"blockLists=true",
		"stats=true",
	}

	req, err := http.NewRequest("GET", strings.TrimRight(*url, "/")+"/api/settings/backup?"+strings.Join(params, "&"), nil)
	if err != nil {
		fatal(err)
	}
	req.Header.Set("Authorization", "Bearer "+strings.TrimSpace(string(token)))

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		fatal(err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
		fatal(fmt.Errorf("%s: %s", resp.Status, strings.TrimSpace(string(body))))
	}

	if err := os.MkdirAll(filepath.Dir(*out), 0o755); err != nil {
		fatal(err)
	}

	f, err := os.Create(*out)
	if err != nil {
		fatal(err)
	}
	defer f.Close()

	if _, err := io.Copy(f, resp.Body); err != nil {
		fatal(err)
	}
	fmt.Println("backup written to", *out)
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, "technitium-backup:", err)
	os.Exit(1)
}
