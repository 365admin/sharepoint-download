package schemas

type DownloadResponse struct {
	Filename       string `json:"filename"`
	ParentPath     string `json:"parentPath"`
	Publiclink     string `json:"publiclink"`
	RelativePath   string `json:"relativePath"`
	Sharepointlink string `json:"sharepointlink"`
	Status         string `json:"status"`
}
