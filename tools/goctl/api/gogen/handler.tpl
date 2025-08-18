package {{.PkgName}}

import (
	"net/http"
	"strings"

	"github.com/zeromicro/go-zero/rest/httpx"
	{{.ImportPackages}}
)

{{if .HasDoc}}{{.Doc}}{{end}}
func {{.HandlerName}}(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		{{if .HasRequest}}var req types.{{.RequestType}}
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err, func(w http.ResponseWriter, err error) {
				msg := strings.ReplaceAll(err.Error(), "\"", "'")
				code := 0

				var resp any
				_, _ = msg, code

				httpx.OkJsonCtx(r.Context(), w, resp)
			})
			return
		}

		{{end}}l := {{.LogicName}}.New{{.LogicType}}(r.Context(), svcCtx)
		{{if .HasResp}}resp, {{end}}err := l.{{.Call}}({{if .HasRequest}}&req{{end}})
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err, func(w http.ResponseWriter, err error) {
				msg := strings.ReplaceAll(err.Error(), "\"", "'")
				code := 0

				var resp any
				_, _ = msg, code

				httpx.OkJsonCtx(r.Context(), w, resp)
			})
		} else {
			{{if .HasResp}}httpx.OkJsonCtx(r.Context(), w, resp){{else}}httpx.Ok(w){{end}}
		}
	}
}
