package main

import (
	"runtime/debug"
	"strings"

	"github.com/365admin/sharepoint-download/magicapp"
	"github.com/365admin/sharepoint-download/utils"
)

func main() {
	info, _ := debug.ReadBuildInfo()

	// split info.Main.Path by / and get the last element
	s1 := strings.Split(info.Main.Path, "/")
	name := s1[len(s1)-1]
	description := `---
title: sharepoint-download
description: Describe the main purpose of this kitchen
---

# sharepoint-download
`
	magicapp.Setup(".env")
	magicapp.RegisterServeCmd("sharepoint-download", description, "0.0.1", 8336)
	magicapp.RegisterCmds()
	magicapp.RootCmd.PersistentFlags().BoolVarP(&utils.Verbose, "verbose", "v", false, "verbose output")

	magicapp.Execute(name, "sharepoint-download", "")
}
