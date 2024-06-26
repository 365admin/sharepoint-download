// -------------------------------------------------------------------
// Generated by 365admin-publish/api/20 makeschema.ps1
// -------------------------------------------------------------------
/*
---
title: Download
---
*/
package endpoints

import (
	"context"

	"github.com/swaggest/usecase"

	"github.com/365admin/sharepoint-download/execution"
)

func SandboxDownloadPost() usecase.Interactor {
	type Request struct {
		Siteurl   string `query:"siteurl" binding:"required"`
		Folderref string `query:"folderref" binding:"required"`
		Filename  string `query:"filename" binding:"required"`
		Copyto    string `query:"copyto" binding:"required"`
	}
	u := usecase.NewInteractor(func(ctx context.Context, input Request, output *string) error {

		_, err := execution.ExecutePowerShell("john", "*", "sharepoint-download", "90-sandbox", "10-download.ps1", "", "-siteurl", input.Siteurl, "-folderref", input.Folderref, "-filename", input.Filename, "-copyto", input.Copyto)
		if err != nil {
			return err
		}

		return err

	})
	u.SetTitle("Download")
	// u.SetExpectedErrors(status.InvalidArgument)
	u.SetTags("Sandbox")
	return u
}
