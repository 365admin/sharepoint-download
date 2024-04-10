package magicapp

import (
	"os"

	"github.com/spf13/cobra"

	"github.com/365admin/sharepoint-download/cmds"
	"github.com/365admin/sharepoint-download/utils"
)

func RegisterCmds() {
	RootCmd.PersistentFlags().StringVarP(&utils.Output, "output", "o", "", "Output format (json, yaml, xml, etc.)")

	healthCmd := &cobra.Command{
		Use:   "health",
		Short: "Health",
		Long:  ``,
	}
	HealthPingPostCmd := &cobra.Command{
		Use:   "ping  pong",
		Short: "Ping",
		Long:  `Simple ping endpoint`,
		Args:  cobra.MinimumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.HealthPingPost(ctx, args)
		},
	}
	healthCmd.AddCommand(HealthPingPostCmd)
	HealthCoreversionPostCmd := &cobra.Command{
		Use:   "coreversion ",
		Short: "Core Version",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.HealthCoreversionPost(ctx, args)
		},
	}
	healthCmd.AddCommand(HealthCoreversionPostCmd)

	RootCmd.AddCommand(healthCmd)
	downloadCmd := &cobra.Command{
		Use:   "download",
		Short: "Download",
		Long:  ``,
	}
	DownloadOnefilePostCmd := &cobra.Command{
		Use:   "onefile ",
		Short: "Download Graph",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()
			body, err := os.ReadFile(args[0])
			if err != nil {
				panic(err)
			}

			cmds.DownloadOnefilePost(ctx, body, args)
		},
	}
	downloadCmd.AddCommand(DownloadOnefilePostCmd)

	RootCmd.AddCommand(downloadCmd)
	provisionCmd := &cobra.Command{
		Use:   "provision",
		Short: "Provision",
		Long:  ``,
	}
	ProvisionAppdeployproductionPostCmd := &cobra.Command{
		Use:   "appdeployproduction ",
		Short: "App deploy to production",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.ProvisionAppdeployproductionPost(ctx, args)
		},
	}
	provisionCmd.AddCommand(ProvisionAppdeployproductionPostCmd)
	ProvisionWebdeployproductionPostCmd := &cobra.Command{
		Use:   "webdeployproduction ",
		Short: "Web deploy to production",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.ProvisionWebdeployproductionPost(ctx, args)
		},
	}
	provisionCmd.AddCommand(ProvisionWebdeployproductionPostCmd)
	ProvisionWebdeploytestPostCmd := &cobra.Command{
		Use:   "webdeploytest ",
		Short: "Web deploy to Test",
		Long:  ``,
		Args:  cobra.MinimumNArgs(0),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.ProvisionWebdeploytestPost(ctx, args)
		},
	}
	provisionCmd.AddCommand(ProvisionWebdeploytestPostCmd)

	RootCmd.AddCommand(provisionCmd)
	sandboxCmd := &cobra.Command{
		Use:   "sandbox",
		Short: "Sandbox",
		Long:  ``,
	}
	SandboxDownloadPostCmd := &cobra.Command{
		Use:   "download  siteurl folderref filename copyto",
		Short: "Download",
		Long:  ``,
		Args:  cobra.MinimumNArgs(4),
		Run: func(cmd *cobra.Command, args []string) {
			ctx := cmd.Context()

			cmds.SandboxDownloadPost(ctx, args)
		},
	}
	sandboxCmd.AddCommand(SandboxDownloadPostCmd)

	RootCmd.AddCommand(sandboxCmd)
}
