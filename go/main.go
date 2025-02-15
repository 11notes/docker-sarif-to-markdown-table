package main

import (
	"fmt"
	"io"
	"log"
	"os"
	"regexp"

	"github.com/jedib0t/go-pretty/v6/table"
	"github.com/owenrumney/go-sarif/v2/sarif"
)

func main() {
	content, err := io.ReadAll(os.Stdin)
	if err != nil {
		log.Fatal(err)
	}

	sarif, err := sarif.FromBytes(content)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Print("## Security Vulnerabilities Report\n\n")

	// Loop through all the runs in the SARIF input
	for _, run := range sarif.Runs {
		tw := table.NewWriter()
		tw.AppendHeader(table.Row{
			"CVE",
			"Severity",
			"Description",
			"Path",
		})
		for _, result := range run.Results {
			ruleIndex, ruleIdString := getOrCreateRule(
				*result.RuleID,
				sarif.Runs[0].Tool.Driver,
			)

			tw.AppendRow(table.Row{
				ruleIdString,
				nilToEmptyStringFilter(run.Tool.Driver.Rules[ruleIndex].Properties["security-severity"]),
				*result.Message.Text,
				nilToEmptyStringFilter(*result.Locations[0].PhysicalLocation.ArtifactLocation.URI),
			})
		}
		// Sort by severity
		tw.SortBy([]table.SortBy{
			{Name: "Severity", Mode: table.DscNumeric},
		})

		// Drop empty columns
		tw.SuppressEmptyColumns()

		// Loop through each run
		if len(run.Results) > 0 {
			fmt.Print(tw.RenderMarkdown())
			fmt.Print("\n---\n")
		} else {
			fmt.Print("")
		}
	}

}

// Find a particular rule by ID - return index and the ID, if helpUri exists, the ID is markdown link format
func getOrCreateRule(id string, driver *sarif.ToolComponent) (uint, string) {
	for i, r := range driver.Rules {
		if r.ID == id {
			re := regexp.MustCompile(`CVE-\d{4}-\d+`)
			matches := re.FindStringSubmatch(id)

			if matches != nil {
				return uint(i), fmt.Sprintf("[%s](https://nvd.nist.gov/vuln/detail/%s)", matches[0], matches[0])
			}

			return uint(i), fmt.Sprintf("%s", id)
		}
	}
	return uint(len(driver.Rules) - 1), fmt.Sprintf("%s", id)
}

func nilToEmptyStringFilter(input interface{}) interface{} {
	if input == nil {
		return ""
	} else {
		return input
	}
}