package logic

import (
	"context"
	"iknow/micros/sayhello/sayhello"

	"iknow/apis/sayhello/internal/svc"
	"iknow/apis/sayhello/internal/types"

	"github.com/zeromicro/go-zero/core/logx"
)

type SayhelloLogic struct {
	logx.Logger
	ctx    context.Context
	svcCtx *svc.ServiceContext
}

func NewSayhelloLogic(ctx context.Context, svcCtx *svc.ServiceContext) *SayhelloLogic {
	return &SayhelloLogic{
		Logger: logx.WithContext(ctx),
		ctx:    ctx,
		svcCtx: svcCtx,
	}
}

func (l *SayhelloLogic) Sayhello(req *types.Request) (resp *types.Response, err error) {
	// todo: add your logic here and delete this line
	response, err := l.svcCtx.SayHelloZRpc.Ping(l.ctx, &sayhello.Request{Ping: req.Name})
	if err != nil {
		return nil, err
	}
	return &types.Response{Message: response.Pong}, nil
}
