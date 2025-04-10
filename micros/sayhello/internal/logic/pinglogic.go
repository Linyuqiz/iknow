package logic

import (
	"context"

	"iknow/micros/sayhello/internal/svc"
	"iknow/micros/sayhello/sayhello"

	"github.com/zeromicro/go-zero/core/logx"
)

type PingLogic struct {
	ctx    context.Context
	svcCtx *svc.ServiceContext
	logx.Logger
}

func NewPingLogic(ctx context.Context, svcCtx *svc.ServiceContext) *PingLogic {
	return &PingLogic{
		ctx:    ctx,
		svcCtx: svcCtx,
		Logger: logx.WithContext(ctx),
	}
}

func (l *PingLogic) Ping(in *sayhello.Request) (*sayhello.Response, error) {
	// todo: add your logic here and delete this line
	return &sayhello.Response{Pong: in.Ping}, nil
}
