// -------------------------------------------------------------------
// Generated by 365admin-publish
// -------------------------------------------------------------------
/*
---
title: Download Graph
---
*/
package cmds

import (
	"context"
	"encoding/json"
	"fmt"
	"os"
	"path"

	"github.com/365admin/sharepoint-download/execution"
	"github.com/365admin/sharepoint-download/schemas"
	"github.com/365admin/sharepoint-download/utils"
)

func DownloadOnefilePost(ctx context.Context, body []byte, args []string) (*schemas.DownloadResponse, error) {
	inputErr := os.WriteFile(path.Join(utils.WorkDir("sharepoint-download"), "download-request.json"), body, 0644)
	if inputErr != nil {
		return nil, inputErr
	}

	result, pwsherr := execution.ExecutePowerShell("john", "*", "sharepoint-download", "20-download", "download-graph.ps1", "")
	if pwsherr != nil {
		return nil, pwsherr
	}

	resultingFile := path.Join(utils.WorkDir("sharepoint-download"), "download-response.json")
	data, err := os.ReadFile(resultingFile)
	if err != nil {
		return nil, err
	}
	resultObject := schemas.DownloadResponse{}
	err = json.Unmarshal(data, &resultObject)
	if utils.Output == "json" {
		fmt.Println(string(data))
	}
	utils.PrintSkip2FirstAnd2LastLines(string(result))

	return nil, nil

}
