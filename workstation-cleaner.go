package main

import (
	"io"
	"log"
	"os"
	"regexp"
	"strings"
	"sync"
)

var root = "C:\\Users"

const workers = 64

const maxPathDepth = 4096

var ignore = []string{
	".*winbox.*\\.exe",
	"^.*\\.lnk$",
	"^.*\\.url$",
	"^.*Documents\\\\*$",
	"^.*3D Objects\\\\*$",
	"^.*Contacts\\\\*$",
	"^.*Desktop\\\\*$",
	"^.*Downloads\\\\*$",
	"^.*Favorites\\\\*$",
	"^.*Links\\\\*$",
	"^.*Music\\\\*$",
	"^.*Pictures\\\\*$",
	"^.*Saved Games\\\\*$",
	"^.*Searches\\\\*$",
	"^.*Videos\\\\*$",
	"^.*NetHood\\\\*$",
	"^.*PrintHood\\\\*$",
	"^.*Recent\\\\*$",
	"^.*SendTo\\\\*$",
	"^.*Start Menu\\\\*$",
	"^.*Templates\\\\*$",
	"^.*Cookies\\\\*$",
	"^.*Local Settings\\\\*$",
	"^.*NTUSER\\.DAT.*$",
	"^.*NTUSER\\.DAT\\.LOG.*$",
	"^.*ntuser\\.dat\\.*$",
	"^.*ntuser\\.dat\\.log.*$",
	"^.*ntuser\\.dat\\.LOG.*$",
	"^.*ntuser\\.ini.*$",
	"^.*IntelGraphicsProfiles.*$",
	"^.*\\.config.*$",
	"^.*\\.dlv.*$",
	"^.*Application Data.*$",
	"^.*AppData.*$",
	"^C:\\\\Users\\\\All Users.*$",
	"^C:\\\\Users\\\\Default User.*$",
	"^C:\\\\Users\\\\Default.*$",
	"^C:\\\\Users\\\\Public.*$",
	"^.*desktop\\.ini$",
}

var (
	ignoreRegexes      []*regexp.Regexp
	directoryChan      chan string
	directoriesByDepth [maxPathDepth][]string
	wg                 sync.WaitGroup
)

func main() {
	compileRegexes()
	directoryChan = make(chan string, 4096)
	wg = sync.WaitGroup{}
	for i := 0; i < workers; i++ {
		go directoryWorker()
	}
	pushDir(&root)
	wg.Wait()
	close(directoryChan)
	deleteEmptyDirectories()
	log.Print("DONE!")
}

func compileRegexes() {
	ignoreRegexes = make([]*regexp.Regexp, len(ignore))
	for i, ignoreRegexStr := range ignore {
		regex, err := regexp.Compile(ignoreRegexStr)
		if err != nil {
			log.Fatalf("Could not compile ignore regex %s: %s", ignoreRegexStr, err.Error())
		}
		ignoreRegexes[i] = regex
	}
}

func pushDir(dir *string) {
	depth := strings.Count(*dir, "\\")
	if depth >= maxPathDepth {
		log.Fatalf("Path lenght exceeded with path %s", *dir)
	}
	directoriesByDepth[depth] = append(directoriesByDepth[depth], *dir)
	wg.Add(1)
	directoryChan <- *dir
}

func directoryWorker() {
	for dir := range directoryChan {
		dirLs, err := os.ReadDir(dir)
		if err != nil {
			log.Fatalf("Could not ls path %s: %s", dir, err.Error())
		}
		for _, entry := range dirLs {
			f, err := entry.Info()
			path := dir + "\\" + f.Name()
			if err != nil {
				log.Printf("Could not stat FI from path %s: %s", path, err.Error())
				continue
			}
			if f.IsDir() {
				pushDir(&path)
				continue
			} else if !matchAny(path, ignoreRegexes) {
				err = os.RemoveAll(path)
				log.Printf("REMOVING %s", path)
				if err != nil {
					log.Printf("Cannot remove path %s: %s", path, err.Error())
				}
			} else {
				//log.Printf("SKIPPING %s", path)
			}
		}
		wg.Done()
	}
}

func deleteEmptyDirectories() {
	for depth := maxPathDepth - 1; depth >= 0; depth-- {
		for _, dir := range directoriesByDepth[depth] {
			if !dirIsEmpty(dir) {
				continue
			}
			if !matchAny(dir, ignoreRegexes) {
				err := os.RemoveAll(dir)
				log.Printf("REMOVING EMPTY DIR %s", dir)
				if err != nil {
					log.Printf("Cannot remove path %s: %s", dir, err.Error())
				}
			} else {
				//log.Printf("SKIPPING EMPTY DIR %s", dir)
			}
		}
	}
}

func dirIsEmpty(name string) bool {
	f, err := os.Open(name)
	if err != nil {
		log.Printf("Could not stat emptiness of path %s: %s", name, err.Error())
	}
	defer func(f *os.File) {
		_ = f.Close()
	}(f)

	_, err = f.Readdirnames(1)
	if err == io.EOF {
		return true
	}
	return false
}

func matchAny(str string, regexes []*regexp.Regexp) bool {
	for _, regex := range regexes {
		if regex.MatchString(str) {
			return true
		}
	}
	return false
}
