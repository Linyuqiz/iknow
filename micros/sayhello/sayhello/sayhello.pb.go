// Code generated by protoc-gen-go. DO NOT EDIT.
// versions:
// 	protoc-gen-go v1.36.6
// 	protoc        v3.19.4
// source: sayhello.proto

package sayhello

import (
	protoreflect "google.golang.org/protobuf/reflect/protoreflect"
	protoimpl "google.golang.org/protobuf/runtime/protoimpl"
	reflect "reflect"
	sync "sync"
	unsafe "unsafe"
)

const (
	// Verify that this generated code is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(20 - protoimpl.MinVersion)
	// Verify that runtime/protoimpl is sufficiently up-to-date.
	_ = protoimpl.EnforceVersion(protoimpl.MaxVersion - 20)
)

type Request struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Ping          string                 `protobuf:"bytes,1,opt,name=ping,proto3" json:"ping,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *Request) Reset() {
	*x = Request{}
	mi := &file_sayhello_proto_msgTypes[0]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *Request) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Request) ProtoMessage() {}

func (x *Request) ProtoReflect() protoreflect.Message {
	mi := &file_sayhello_proto_msgTypes[0]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Request.ProtoReflect.Descriptor instead.
func (*Request) Descriptor() ([]byte, []int) {
	return file_sayhello_proto_rawDescGZIP(), []int{0}
}

func (x *Request) GetPing() string {
	if x != nil {
		return x.Ping
	}
	return ""
}

type Response struct {
	state         protoimpl.MessageState `protogen:"open.v1"`
	Pong          string                 `protobuf:"bytes,1,opt,name=pong,proto3" json:"pong,omitempty"`
	unknownFields protoimpl.UnknownFields
	sizeCache     protoimpl.SizeCache
}

func (x *Response) Reset() {
	*x = Response{}
	mi := &file_sayhello_proto_msgTypes[1]
	ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
	ms.StoreMessageInfo(mi)
}

func (x *Response) String() string {
	return protoimpl.X.MessageStringOf(x)
}

func (*Response) ProtoMessage() {}

func (x *Response) ProtoReflect() protoreflect.Message {
	mi := &file_sayhello_proto_msgTypes[1]
	if x != nil {
		ms := protoimpl.X.MessageStateOf(protoimpl.Pointer(x))
		if ms.LoadMessageInfo() == nil {
			ms.StoreMessageInfo(mi)
		}
		return ms
	}
	return mi.MessageOf(x)
}

// Deprecated: Use Response.ProtoReflect.Descriptor instead.
func (*Response) Descriptor() ([]byte, []int) {
	return file_sayhello_proto_rawDescGZIP(), []int{1}
}

func (x *Response) GetPong() string {
	if x != nil {
		return x.Pong
	}
	return ""
}

var File_sayhello_proto protoreflect.FileDescriptor

const file_sayhello_proto_rawDesc = "" +
	"\n" +
	"\x0esayhello.proto\x12\bsayhello\"\x1d\n" +
	"\aRequest\x12\x12\n" +
	"\x04ping\x18\x01 \x01(\tR\x04ping\"\x1e\n" +
	"\bResponse\x12\x12\n" +
	"\x04pong\x18\x01 \x01(\tR\x04pong29\n" +
	"\bSayhello\x12-\n" +
	"\x04Ping\x12\x11.sayhello.Request\x1a\x12.sayhello.ResponseB\fZ\n" +
	"./sayhellob\x06proto3"

var (
	file_sayhello_proto_rawDescOnce sync.Once
	file_sayhello_proto_rawDescData []byte
)

func file_sayhello_proto_rawDescGZIP() []byte {
	file_sayhello_proto_rawDescOnce.Do(func() {
		file_sayhello_proto_rawDescData = protoimpl.X.CompressGZIP(unsafe.Slice(unsafe.StringData(file_sayhello_proto_rawDesc), len(file_sayhello_proto_rawDesc)))
	})
	return file_sayhello_proto_rawDescData
}

var file_sayhello_proto_msgTypes = make([]protoimpl.MessageInfo, 2)
var file_sayhello_proto_goTypes = []any{
	(*Request)(nil),  // 0: sayhello.Request
	(*Response)(nil), // 1: sayhello.Response
}
var file_sayhello_proto_depIdxs = []int32{
	0, // 0: sayhello.Sayhello.Ping:input_type -> sayhello.Request
	1, // 1: sayhello.Sayhello.Ping:output_type -> sayhello.Response
	1, // [1:2] is the sub-list for method output_type
	0, // [0:1] is the sub-list for method input_type
	0, // [0:0] is the sub-list for extension type_name
	0, // [0:0] is the sub-list for extension extendee
	0, // [0:0] is the sub-list for field type_name
}

func init() { file_sayhello_proto_init() }
func file_sayhello_proto_init() {
	if File_sayhello_proto != nil {
		return
	}
	type x struct{}
	out := protoimpl.TypeBuilder{
		File: protoimpl.DescBuilder{
			GoPackagePath: reflect.TypeOf(x{}).PkgPath(),
			RawDescriptor: unsafe.Slice(unsafe.StringData(file_sayhello_proto_rawDesc), len(file_sayhello_proto_rawDesc)),
			NumEnums:      0,
			NumMessages:   2,
			NumExtensions: 0,
			NumServices:   1,
		},
		GoTypes:           file_sayhello_proto_goTypes,
		DependencyIndexes: file_sayhello_proto_depIdxs,
		MessageInfos:      file_sayhello_proto_msgTypes,
	}.Build()
	File_sayhello_proto = out.File
	file_sayhello_proto_goTypes = nil
	file_sayhello_proto_depIdxs = nil
}
