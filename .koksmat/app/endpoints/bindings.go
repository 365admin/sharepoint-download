// -------------------------------------------------------------------
// Generated by 365admin-publish
// -------------------------------------------------------------------

package endpoints

import (
	"net/http"

	chi "github.com/go-chi/chi/v5"
	"github.com/swaggest/rest/nethttp"
	"github.com/swaggest/rest/web"
)

func AddEndpoints(s *web.Service, jwtAuth func(http.Handler) http.Handler) {
	s.Route("/v1", func(r chi.Router) {
		r.Group(func(r chi.Router) {
			//r.Use(adminAuth, nethttp.HTTPBasicSecurityMiddleware(s.OpenAPICollector, "User", "User access"))
			r.Use(jwtAuth, nethttp.HTTPBearerSecurityMiddleware(s.OpenAPICollector, "Bearer", "", ""))
			//	r.Use(rateLimitByAppId(50))
			//r.Method(http.MethodPost, "/", nethttp.NewHandler(ExchangeCreateRoomsPost()))
			r.Method(http.MethodPost, "/health/ping", nethttp.NewHandler(HealthPingPost()))
			r.Method(http.MethodPost, "/health/coreversion", nethttp.NewHandler(HealthCoreversionPost()))
			r.Method(http.MethodPost, "/download/onefile", nethttp.NewHandler(DownloadOnefilePost()))
			r.Method(http.MethodPost, "/provision/appdeployproduction", nethttp.NewHandler(ProvisionAppdeployproductionPost()))
			r.Method(http.MethodPost, "/provision/webdeployproduction", nethttp.NewHandler(ProvisionWebdeployproductionPost()))
			r.Method(http.MethodPost, "/provision/webdeploytest", nethttp.NewHandler(ProvisionWebdeploytestPost()))
			r.Method(http.MethodPost, "/sandbox/download", nethttp.NewHandler(SandboxDownloadPost()))

		})
	})

}
