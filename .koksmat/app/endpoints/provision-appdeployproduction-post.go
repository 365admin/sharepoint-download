// -------------------------------------------------------------------
// Generated by 365admin-publish/api/20 makeschema.ps1
// -------------------------------------------------------------------
/*
---
title: App deploy to production
---
*/
package endpoints

import (
	"context"

	"github.com/swaggest/usecase"

	"github.com/365admin/sharepoint-download/execution"
)

func ProvisionAppdeployproductionPost() usecase.Interactor {
	type Request struct {
	}
	u := usecase.NewInteractor(func(ctx context.Context, input Request, output *string) error {

		_, err := execution.ExecutePowerShell("john", "*", "sharepoint-download", "60-provision", "10-app-restapi.ps1", "")
		if err != nil {
			return err
		}

		return err

	})
	u.SetTitle("App deploy to production")
	// u.SetExpectedErrors(status.InvalidArgument)
	u.SetTags("Provision")
	return u
}