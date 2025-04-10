package handler

import (
	"net/http"

	"github.com/zeromicro/go-zero/rest/httpx"
	"iknow/apis/sayhello/internal/logic"
	"iknow/apis/sayhello/internal/svc"
	"iknow/apis/sayhello/internal/types"
)

func SayhelloHandler(svcCtx *svc.ServiceContext) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		var req types.Request
		if err := httpx.Parse(r, &req); err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
			return
		}

		l := logic.NewSayhelloLogic(r.Context(), svcCtx)
		resp, err := l.Sayhello(&req)
		if err != nil {
			httpx.ErrorCtx(r.Context(), w, err)
		} else {
			httpx.OkJsonCtx(r.Context(), w, resp)
		}
	}
}
