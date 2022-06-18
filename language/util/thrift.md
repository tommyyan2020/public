# thrift使用

## 参考

- https://blog.csdn.net/weixin_30892763/article/details/97998593

## 安装thrift

```bash
wget https://dlcdn.apache.org/thrift/0.16.0/thrift-0.16.0.tar.gz
tar -zxvf thrift-0.16.0.tar.gz
 cd thrift-0.16.0/
./configure --prefix=/usr/local
make
make check
make install
thrift --version
```

# 使用技巧

### optional字段判断

```c++
#define HANDLE_TYPE(t_task_type, work_pool, req_member)                                             \
    case t_task_type:                                                                               \
        if (task.__isset.req_member) {                                                              \
            task_divider[t_task_type].push_back(task);                                              \
        } else {                                                                                    \
            ret_st = Status::InvalidArgument(                                                       \
                    strings::Substitute("task(signature=$0) has wrong request member", signature)); \
        }                                                                                           \
        break;
```

### 枚举值转字符串

```cpp
// Util used to get string name of thrift enum item
#define EnumToString(enum_type, index, out)                                                         \
    do {                                                                                            \
        std::map<int, const char*>::const_iterator it = _##enum_type##_VALUES_TO_NAMES.find(index); \
        if (it == _##enum_type##_VALUES_TO_NAMES.end()) {                                           \
            out = "NULL";                                                                           \
        } else {                                                                                    \
            out = it->second;                                                                       \
        }                                                                                           \
    } while (0)

} // namespace starrocks

// 原生生成的
std::string to_string(const TAggregationType::type& val) {
  std::map<int, const char*>::const_iterator it = _TAggregationType_VALUES_TO_NAMES.find(val);
  if (it != _TAggregationType_VALUES_TO_NAMES.end()) {
    return std::string(it->second);
  } else {
    return std::to_string(static_cast<int>(val));
  }
}

```

