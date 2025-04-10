package svc

import (
	"github.com/zeromicro/go-zero/zrpc"
	"iknow/apis/sayhello/internal/config"
	"iknow/micros/sayhello/sayhello"
)

type ServiceContext struct {
	Config config.Config

	SayHelloZRpc sayhello.SayhelloClient
}

func NewServiceContext(c config.Config) *ServiceContext {
	return &ServiceContext{
		Config:       c,
		SayHelloZRpc: sayhello.NewSayhelloClient(zrpc.MustNewClient(c.SayHelloZRpc).Conn()),
	}
}
