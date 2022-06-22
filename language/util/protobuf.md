

# ProtoBuff使用

# 参考

- 官方（中国）：https://developers.google.cn/protocol-buffers
- github：https://github.com/protocolbuffers/protobuf/
- 官方链接：https://developers.google.com/protocol-buffers/docs/overview
- CSDN翻译文档：https://so.csdn.net/so/search?q=ProtoBuf&t=blog&u=chuifuhuo6864
- 官方文档：api参考：http://code.google.com/apis/protocolbuffers/docs/reference/overview.html
- 官方文档：报文格式编码：http://code.google.com/apis/protocolbuffers/docs/encoding.html
- 官方文档：CPP： https://developers.google.com/protocol-buffers/docs/cpptutorial 
- 官方文档proto3：https://developers.google.com/protocol-buffers/docs/proto3
- 简单参考这个：https://www.cnblogs.com/silvermagic/p/9087539.html
- 官方python文档： https://developers.google.com/protocol-buffers/docs/reference/python-generated 
- python入门：https://mp.weixin.qq.com/s/QbLq5gVKjaHyoaY2Vv5MRQ
- c++ linux入门：https://zhuanlan.zhihu.com/p/451390348
- Protobuf3语法详解：https://blog.csdn.net/qq_36373500/article/details/86551886
- protobuf简介：https://sunzhy.blog.csdn.net/article/details/105078580 
- 图文分析：如何利用Google的protobuf，来思考、设计、实现自己的RPC框架 ： https://www.sohu.com/a/463259739_115128

# 下载安装

- 官方

```bash
wget https://github.com/protocolbuffers/protobuf/releases/download/v3.20.1/protobuf-all-3.20.1.tar.gz
tar -zxvf protobuf-all-3.20.1.tar.gz
cd protobuf-3.20.1
./configure --prefix=/usr/local/
make
make check
make install
protoc --version
```

# 版本

proto3和proto2的区别

-  https://solicomo.com/network-dev/protobuf-proto3-vs-proto2.html

# 生成cpp文件

## Makefile

### 例子1：统一存放proto并生成

```makefile
BUILD_DIR = ${CURDIR}/../build/

PROTOC = ${DORIS_THIRDPARTY}/installed/bin/protoc

SOURCES = $(shell find ${CURDIR} -name "*.proto")
OBJECTS = $(patsubst ${CURDIR}/%.proto, ${BUILD_DIR}/gen_cpp/%.pb.cc, ${SOURCES})
HEADERS = $(patsubst ${CURDIR}/%.proto, ${BUILD_DIR}/gen_cpp/%.pb.h, ${SOURCES})

#JAVA_OBJECTS = $(patsubst ${CURDIR}/%.proto, ${BUILD_DIR}/java/org/apache/doris/proto/%.java, ${SOURCES})

#all: ${JAVA_OBJECTS} ${OBJECTS} ${HEADERS}
all: ${OBJECTS} ${HEADERS}
.PHONY: all

${BUILD_DIR}/gen_cpp/%.pb.h ${BUILD_DIR}/gen_cpp/%.pb.cc: ${CURDIR}/%.proto | ${BUILD_DIR}/gen_cpp
	${PROTOC} --proto_path=${CURDIR} --cpp_out=${BUILD_DIR}/gen_cpp $<

#${BUILD_DIR}/java/org/apache/doris/proto/%.java: ${CURDIR}/%.proto | ${BUILD_DIR}/java
#	${PROTOC} --proto_path=${CURDIR} --java_out=${BUILD_DIR}/java/ $<

${BUILD_DIR}/gen_cpp:
	mkdir -p $@
```

### 例子2：项目单独组织

```makefile
NEED_GPERFTOOLS=0
BRPC_PATH=../..
include $(BRPC_PATH)/config.mk
# Notes on the flags:
# 1. Added -fno-omit-frame-pointer: perf/tcmalloc-profiler use frame pointers by default
# 2. Added -D__const__= : Avoid over-optimizations of TLS variables by GCC>=4.8
CXXFLAGS+=$(CPPFLAGS) -std=c++0x -DNDEBUG -O2 -D__const__= -pipe -W -Wall -Wno-unused-parameter -fPIC -fno-omit-frame-pointer
ifeq ($(NEED_GPERFTOOLS), 1)
	CXXFLAGS+=-DBRPC_ENABLE_CPU_PROFILER
endif
HDRS+=$(BRPC_PATH)/output/include
LIBS+=$(BRPC_PATH)/output/lib

HDRPATHS=$(addprefix -I, $(HDRS))
LIBPATHS=$(addprefix -L, $(LIBS))
COMMA=,
SOPATHS=$(addprefix -Wl$(COMMA)-rpath$(COMMA), $(LIBS))

CLIENT_SOURCES = client.cpp
SERVER_SOURCES = server.cpp
PROTOS = $(wildcard *.proto)

PROTO_OBJS = $(PROTOS:.proto=.pb.o)
PROTO_GENS = $(PROTOS:.proto=.pb.h) $(PROTOS:.proto=.pb.cc)
CLIENT_OBJS = $(addsuffix .o, $(basename $(CLIENT_SOURCES))) 
SERVER_OBJS = $(addsuffix .o, $(basename $(SERVER_SOURCES))) 

ifeq ($(SYSTEM),Darwin)
 ifneq ("$(LINK_SO)", "")
	STATIC_LINKINGS += -lbrpc
 else
	# *.a must be explicitly specified in clang
	STATIC_LINKINGS += $(BRPC_PATH)/output/lib/libbrpc.a
 endif
	LINK_OPTIONS_SO = $^ $(STATIC_LINKINGS) $(DYNAMIC_LINKINGS)
	LINK_OPTIONS = $^ $(STATIC_LINKINGS) $(DYNAMIC_LINKINGS)
else ifeq ($(SYSTEM),Linux)
	STATIC_LINKINGS += -lbrpc
	LINK_OPTIONS_SO = -Xlinker "-(" $^ -Xlinker "-)" $(STATIC_LINKINGS) $(DYNAMIC_LINKINGS)
	LINK_OPTIONS = -Xlinker "-(" $^ -Wl,-Bstatic $(STATIC_LINKINGS) -Wl,-Bdynamic -Xlinker "-)" $(DYNAMIC_LINKINGS)
endif

.PHONY:all
all: echo_client echo_server

.PHONY:clean
clean:
	@echo "> Cleaning"
	rm -rf echo_client echo_server $(PROTO_GENS) $(PROTO_OBJS) $(CLIENT_OBJS) $(SERVER_OBJS)

echo_client:$(PROTO_OBJS) $(CLIENT_OBJS)
	@echo "> Linking $@"
ifneq ("$(LINK_SO)", "")
	$(CXX) $(LIBPATHS) $(SOPATHS) $(LINK_OPTIONS_SO) -o $@
else
	$(CXX) $(LIBPATHS) $(LINK_OPTIONS) -o $@
endif

echo_server:$(PROTO_OBJS) $(SERVER_OBJS)
	@echo "> Linking $@"
ifneq ("$(LINK_SO)", "")
	$(CXX) $(LIBPATHS) $(SOPATHS) $(LINK_OPTIONS_SO) -o $@
else
	$(CXX) $(LIBPATHS) $(LINK_OPTIONS) -o $@
endif

%.pb.cc %.pb.h:%.proto
	@echo "> Generating $@"
	$(PROTOC) --cpp_out=. --proto_path=. $(PROTOC_EXTRA_ARGS) $<

%.o:%.cpp
	@echo "> Compiling $@"
	$(CXX) -c $(HDRPATHS) $(CXXFLAGS) $< -o $@

%.o:%.cc
	@echo "> Compiling $@"
	$(CXX) -c $(HDRPATHS) $(CXXFLAGS) $< -o $@

```

## CMake

- 这个里面讲的比较全，三种方法：https://blog.csdn.net/qq_37868450/article/details/113727764

### 例子1：多个项目多proto

- 使用execute_process命令调用protoc生成源码

最好也放一起，因为

- 参考：https://www.jb51.net/article/207588.htm

```cmake
file(GLOB protobuf_files
    mediapipe/framework/*.proto
    mediapipe/framework/tool/*.proto
    mediapipe/framework/deps/*.proto
    mediapipe/framework/testdata/*.proto
    mediapipe/framework/formats/*.proto
    mediapipe/framework/formats/annotation/*.proto
    mediapipe/framework/formats/motion/*.proto
    mediapipe/framework/formats/object_detection/*.proto
    mediapipe/framework/stream_handler/*.proto
    mediapipe/util/*.proto
    mediapipe/calculators/internal/*.proto
    )

FOREACH(FIL ${protobuf_files})
 
  GET_FILENAME_COMPONENT(FIL_WE ${FIL} NAME_WE)
 
  string(REGEX REPLACE ".+/(.+)\\..*" "\\1" FILE_NAME ${FIL})
  string(REGEX REPLACE "(.+)\\${FILE_NAME}.*" "\\1" FILE_PATH ${FIL})
 
  string(REGEX MATCH "(/mediapipe/framework.*|/mediapipe/util.*|/mediapipe/calculators/internal/)" OUT_PATH ${FILE_PATH})
 
  set(PROTO_SRCS "${CMAKE_CURRENT_BINARY_DIR}${OUT_PATH}${FIL_WE}.pb.cc")
  set(PROTO_HDRS "${CMAKE_CURRENT_BINARY_DIR}${OUT_PATH}${FIL_WE}.pb.h")
 
  EXECUTE_PROCESS(
      COMMAND ${PROTOBUF_PROTOC_EXECUTABLE} ${PROTO_FLAGS} --cpp_out=${PROTO_META_BASE_DIR} ${FIL}
  )
  message("Copying " ${PROTO_SRCS} " to " ${FILE_PATH})
 
  file(COPY ${PROTO_SRCS} DESTINATION ${FILE_PATH})
  file(COPY ${PROTO_HDRS} DESTINATION ${FILE_PATH})
 
ENDFOREACH()
```

```cmake
find_package(Protobuf 3 REQUIRED)

#设置输出路径
(MESSAGE_DIR ${CMAKE_BINARY_DIR}/message)
if(EXISTS "${CMAKE_BINARY_DIR}/message" AND IS_DIRECTORY "${CMAKE_BINARY_DIR}/message")
        SET(DST_DIR ${MESSAGE_DIR})
else()
        file(MAKE_DIRECTORY ${MESSAGE_DIR})
        SET(DST_DIR ${MESSAGE_DIR})
endif()

#设置protoc的搜索路径
LIST(APPEND PROTO_FLAGS -I${CMAKE_SOURCE_DIR}/msg/message)

#获取需要编译的proto文件
file(GLOB_RECURSE MSG_PROTOS ${CMAKE_SOURCE_DIR}/msg/message/*.proto)
set(MESSAGE_SRC "")
set(MESSAGE_HDRS "")
foreach(msg ${MSG_PROTOS})
        get_filename_component(FIL_WE ${msg} NAME_WE)

        list(APPEND MESSAGE_SRC "${PROJECT_BINARY_DIR}/message/${FIL_WE}.pb.cc")
        list(APPEND MESSAGE_HDRS "${PROJECT_BINARY_DIR}/message/${FIL_WE}.pb.h")
        
        # 生成源码
        execute_process(
            COMMAND ${PROTOBUF_PROTOC_EXECUTABLE} ${PROTO_FLAGS} --cpp_out=${DST_DIR} ${msg}
            )
endforeach()
set_source_files_properties(${MESSAGE_SRC} ${MESSAGE_HDRS} PROPERTIES GENERATED TRUE)

```



### 例子2：单独项目，protobuf_generate_cpp生成

```cmake
include(FindProtobuf)
protobuf_generate_cpp(PROTO_SRC PROTO_HEADER echo.proto)
```

### 例子3：方案1改为使用add_custom_target与add_custom_command生成源码

```cmake
find_package(Protobuf 3 REQUIRED)

#设置输出路径
SET(MESSAGE_DIR ${CMAKE_BINARY_DIR}/message)
if(EXISTS "${CMAKE_BINARY_DIR}/message" AND IS_DIRECTORY "${CMAKE_BINARY_DIR}/message")
        SET(PROTO_META_BASE_DIR ${MESSAGE_DIR})
else()
        file(MAKE_DIRECTORY ${MESSAGE_DIR})
        SET(PROTO_META_BASE_DIR ${MESSAGE_DIR})
endif()

#设置protoc的搜索路径
LIST(APPEND PROTO_FLAGS -I${CMAKE_SOURCE_DIR}/msg/message)
#获取需要编译的proto文件
file(GLOB_RECURSE MSG_PROTOS ${CMAKE_SOURCE_DIR}/msg/message/*.proto)
set(MESSAGE_SRC "")
set(MESSAGE_HDRS "")

foreach(msg ${MSG_PROTOS})
        get_filename_component(FIL_WE ${msg} NAME_WE)

        list(APPEND MESSAGE_SRC "${PROJECT_BINARY_DIR}/message/${FIL_WE}.pb.cc")
        list(APPEND MESSAGE_HDRS "${PROJECT_BINARY_DIR}/message/${FIL_WE}.pb.h")

		# 使用自定义命令
        add_custom_command(
          OUTPUT "${PROJECT_BINARY_DIR}/message/${FIL_WE}.pb.cc"
                 "${PROJECT_BINARY_DIR}/message/${FIL_WE}.pb.h"
          COMMAND  ${PROTOBUF_PROTOC_EXECUTABLE}
          ARGS --cpp_out  ${PROTO_META_BASE_DIR}
            -I ${CMAKE_SOURCE_DIR}/msg/message
            ${msg}
          DEPENDS ${msg}
          COMMENT "Running C++ protocol buffer compiler on ${msg}"
          VERBATIM
        )
endforeach()

# 设置文件属性为 GENERATED
set_source_files_properties(${MESSAGE_SRC} ${MESSAGE_HDRS} PROPERTIES GENERATED TRUE)

# 添加自定义target
add_custom_target(generate_message ALL
                DEPENDS ${MESSAGE_SRC} ${MESSAGE_HDRS}
                COMMENT "generate message target"
                VERBATIM
                )
```

- 设置生成的源码文件属性GENERATED为TRUE,否则cmake时会因找不到源码而报错
- 使用**add_custom_target**添加目标时要设置ALL关键字,否则target将不在默认编译列表中

# 例子

## case1 

- 路径：:/data/test/cpp/protobuf
- 参考：protobuf 序列化原理，运行时反射 https://www.bilibili.com/video/BV1Wv41117pT

### test.proto

```protobuf
syntax = "proto2";
package test;
message something
{
    optional int32 num = 1;
    repeated string strs = 2;
}
```

### 生成c++文件

```bash
 protoc  test.proto --cpp_out=./
```

### main.cpp

```cpp
// 一些公共头文件
#include "../header/common.h"
#include "test.pb.h"

int main()
{
    test::something msg;
    msg.set_num(42);
    msg.add_strs("hello");
    msg.add_strs("world");
    msg.PrintDebugString();
    
    
}
```

### 编译运行

- 注意需要将静态库copy过来，不然有可能找不到库
- 要pthead库
- 参考：https://www.cnblogs.com/LiuYanYGZ/p/14308342.html

```ba
cp /usr/local/lib/libprotobuf.a .
g++ *.cpp *.cc -g -lpthread -L./ -lprotobuf  -o test
./test

# 运行结果
num: 42
strs: "hello"
strs: "world"
```

## case 2：python：person

- 参考：https://mp.weixin.qq.com/s/QbLq5gVKjaHyoaY2Vv5MRQ

- 路径：/data/test/cpp/protobuf/person

- 要点

  ```bash
  # 要用python3 系列
  # 用用pip3 先安装protobuf，貌似下载编译安装后无法用
  # 建议先用pip3安装，确定版本后，再找对应的版本下载编译安装protoc
  pip3 install protobuf
  python3 ./add_person.py 
  ```

  vscode的terminal运行后的效果

  ![1651029476958](images/1651029476958.png)

## case3：cpp：addressbook

- 参考：https://zhuanlan.zhihu.com/p/425528252
- 路径：/data/test/cpp/protobuf/address

## case4：CPP：官方例子

- 视频：https://www.bilibili.com/video/BV1dT4y137DP
- 官方地址：https://developers.google.com/protocol-buffers/docs/cpptutorial
- CSDN翻译地址：https://blog.csdn.net/chuifuhuo6864/article/details/100891172
- 例子代码：在官方包的example目录下有
- 本地路径：/data/test/cpp/protobuf/offical

```bas
cp ../protobuf-3.20.1/examples/add*.cc  ../protobuf-3.20.1/examples/*.proto .
protoc *.proto --cpp_out=./
g++ add*.cc -g -L../ -lprotobuf -o add_person
g++ addressbook*.cc list_people.cc -g -L../ -lprotobuf -o list_people
```

### addressbook.proto

```protobuf
// See README.txt for information and build instructions.
//
// Note: START and END tags are used in comments to define sections used in
// tutorials.  They are not part of the syntax for Protocol Buffers.
//
// To get an in-depth walkthrough of this file and the related examples, see:
// https://developers.google.com/protocol-buffers/docs/tutorials

// [START declaration]
syntax = "proto3";
package tutorial;

import "google/protobuf/timestamp.proto";
// [END declaration]

// [START java_declaration]
option java_multiple_files = true;
option java_package = "com.example.tutorial.protos";
option java_outer_classname = "AddressBookProtos";
// [END java_declaration]

// [START csharp_declaration]
option csharp_namespace = "Google.Protobuf.Examples.AddressBook";
// [END csharp_declaration]

// [START go_declaration]
option go_package = "github.com/protocolbuffers/protobuf/examples/go/tutorialpb";
// [END go_declaration]

// [START messages]
message Person {
  string name = 1;
  int32 id = 2;  // Unique ID number for this person.
  string email = 3;

  enum PhoneType {
    MOBILE = 0;
    HOME = 1;
    WORK = 2;
  }

  message PhoneNumber {
    string number = 1;
    PhoneType type = 2;
  }

  repeated PhoneNumber phones = 4;

  google.protobuf.Timestamp last_updated = 5;
}

// Our address book file is just one of these.
message AddressBook {
  repeated Person people = 1;
}
// [END messages]
```

### add_person.cc

```cpp
// See README.txt for information and build instructions.

#include <ctime>
#include <fstream>
#include <google/protobuf/util/time_util.h>
#include <iostream>
#include <string>

#include "addressbook.pb.h"

using namespace std;

using google::protobuf::util::TimeUtil;

// This function fills in a Person message based on user input.
void PromptForAddress(tutorial::Person* person) {
  cout << "Enter person ID number: ";
  int id;
  cin >> id;
  person->set_id(id);
  cin.ignore(256, '\n');

  cout << "Enter name: ";
  getline(cin, *person->mutable_name());

  cout << "Enter email address (blank for none): ";
  string email;
  getline(cin, email);
  if (!email.empty()) {
    person->set_email(email);
  }

  while (true) {
    cout << "Enter a phone number (or leave blank to finish): ";
    string number;
    getline(cin, number);
    if (number.empty()) {
      break;
    }

    tutorial::Person::PhoneNumber* phone_number = person->add_phones();
    phone_number->set_number(number);

    cout << "Is this a mobile, home, or work phone? ";
    string type;
    getline(cin, type);
    if (type == "mobile") {
      phone_number->set_type(tutorial::Person::MOBILE);
    } else if (type == "home") {
      phone_number->set_type(tutorial::Person::HOME);
    } else if (type == "work") {
      phone_number->set_type(tutorial::Person::WORK);
    } else {
      cout << "Unknown phone type.  Using default." << endl;
    }
  }
  *person->mutable_last_updated() = TimeUtil::SecondsToTimestamp(time(NULL));
}

// Main function:  Reads the entire address book from a file,
//   adds one person based on user input, then writes it back out to the same
//   file.
int main(int argc, char* argv[]) {
  // Verify that the version of the library that we linked against is
  // compatible with the version of the headers we compiled against.
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  if (argc != 2) {
    cerr << "Usage:  " << argv[0] << " ADDRESS_BOOK_FILE" << endl;
    return -1;
  }

  tutorial::AddressBook address_book;

  {
    // Read the existing address book.
    fstream input(argv[1], ios::in | ios::binary);
    if (!input) {
      cout << argv[1] << ": File not found.  Creating a new file." << endl;
    } else if (!address_book.ParseFromIstream(&input)) {
      cerr << "Failed to parse address book." << endl;
      return -1;
    }
  }

  // Add an address.
  PromptForAddress(address_book.add_people());

  {
    // Write the new address book back to disk.
    fstream output(argv[1], ios::out | ios::trunc | ios::binary);
    if (!address_book.SerializeToOstream(&output)) {
      cerr << "Failed to write address book." << endl;
      return -1;
    }
  }

  // Optional:  Delete all global objects allocated by libprotobuf.
  google::protobuf::ShutdownProtobufLibrary();

  return 0;
}

```

### list_people.cc

```cpp
// See README.txt for information and build instructions.

#include <fstream>
#include <google/protobuf/util/time_util.h>
#include <iostream>
#include <string>

#include "addressbook.pb.h"

using namespace std;

using google::protobuf::util::TimeUtil;

// Iterates though all people in the AddressBook and prints info about them.
void ListPeople(const tutorial::AddressBook& address_book) {
  for (int i = 0; i < address_book.people_size(); i++) {
    const tutorial::Person& person = address_book.people(i);

    cout << "Person ID: " << person.id() << endl;
    cout << "  Name: " << person.name() << endl;
    if (person.email() != "") {
      cout << "  E-mail address: " << person.email() << endl;
    }

    for (int j = 0; j < person.phones_size(); j++) {
      const tutorial::Person::PhoneNumber& phone_number = person.phones(j);

      switch (phone_number.type()) {
        case tutorial::Person::MOBILE:
          cout << "  Mobile phone #: ";
          break;
        case tutorial::Person::HOME:
          cout << "  Home phone #: ";
          break;
        case tutorial::Person::WORK:
          cout << "  Work phone #: ";
          break;
        default:
          cout << "  Unknown phone #: ";
          break;
      }
      cout << phone_number.number() << endl;
    }
    if (person.has_last_updated()) {
      cout << "  Updated: " << TimeUtil::ToString(person.last_updated()) << endl;
    }
  }
}

// Main function:  Reads the entire address book from a file and prints all
//   the information inside.
int main(int argc, char* argv[]) {
  // Verify that the version of the library that we linked against is
  // compatible with the version of the headers we compiled against.
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  if (argc != 2) {
    cerr << "Usage:  " << argv[0] << " ADDRESS_BOOK_FILE" << endl;
    return -1;
  }

  tutorial::AddressBook address_book;

  {
    // Read the existing address book.
    fstream input(argv[1], ios::in | ios::binary);
    if (!address_book.ParseFromIstream(&input)) {
      cerr << "Failed to parse address book." << endl;
      return -1;
    }
  }

  ListPeople(address_book);

  // Optional:  Delete all global objects allocated by libprotobuf.
  google::protobuf::ShutdownProtobufLibrary();

  return 0;
}

```

## 特性

### varint

- Varint https://blog.csdn.net/zgaoq/article/details/103182952
- varint压缩算法详解  https://blog.csdn.net/weixin_43708622/article/details/111397322