package schemas

type DownloadRequest struct {
	Assetskey string `json:"assetskey"`
	Pin       string `json:"pin"`
	Site      string `json:"site"`
}
