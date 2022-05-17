# xmacro实现c++编译期反射

- 参考教程：https://www.bilibili.com/video/BV16Z4y1T7ec
- 本地代码：/data/test/cpp/xmacro-refect

## main.cpp

```c++
#include <stdio.h>
#include <iostream>
#include <string>
#include <stdint.h>
#include <stdarg.h>
using namespace std;
#define XADD(x, y) ((x) + (y))


#define MESSAGE_NAME foo
#define MESSAGE_FIELDS \
    MESSAGE_FILED_string(name, "tommy")    \
    MESSAGE_FILED_int(state)    \
    MESSAGE_FILED_double(value, 1.3)    \


#include "message-define.h"

#define MESSAGE_NAME foo1
#define MESSAGE_FIELDS \
    MESSAGE_FILED_string(name, "senna")    \
    MESSAGE_FILED_int(state,2)    \
    MESSAGE_FILED_double(value)    \


#include "message-define.h"
/*
class foo{
public:    
    int i = 2;
    std::string name = "tommy";
    double val = 1.2;
friend std::ostream &operator<<(std::ostream &os , const foo & f);

};

std::ostream &operator<<(std::ostream &os , const foo & f)
{
    os << "i = " << f.i << std::endl;
    os << "val = " << f.val << std::endl;
    os << "name = " << f.name.c_str() << std::endl;
    return os;
}*/

int main()
{
    foo f;
    std::cout << f;
    foo1 f1;
    std::cout << f1;
}
```

## message-define.h

```cpp
#include <stdarg.h>
#include <stdio.h>
#ifndef MESSAGE_NAME
# error "Please define MESSAGE_NAME at first"
#endif
#ifndef MESSAGE_FIELDS
# error "Please define MESSAGE_FIELDS at first"
#endif

#ifdef MESSAGE_NAME


class MESSAGE_NAME{
public:

#undef MESSAGE_FILED_string    
#define MESSAGE_FILED_string(name, ...) std::string name = { __VA_ARGS__ };

#undef MESSAGE_FILED_int
#define MESSAGE_FILED_int(state, ...) int state =  { __VA_ARGS__ };

#undef MESSAGE_FILED_double
#define MESSAGE_FILED_double(value, ...) double value = { __VA_ARGS__ };

    MESSAGE_FIELDS;


friend std::ostream &operator<<(std::ostream &os, const MESSAGE_NAME & f );
};

#undef MESSAGE_FILED_string 
#define MESSAGE_FILED_string(name, ...) std::cout << f.name << std::endl;

#undef MESSAGE_FILED_int
#define MESSAGE_FILED_int(state, ...) std::cout << f.state << std::endl;

#undef MESSAGE_FILED_double
#define MESSAGE_FILED_double(value, ...) std::cout << f.value << std::endl;


std::ostream &operator<<(std::ostream &os, const MESSAGE_NAME & f )
{
    MESSAGE_FIELDS;
    return os;

}



#undef MESSAGE_NAME
#undef MESSAGE_FIELDS

#endif
```

## 执行结果

```bash
g++ main.cpp  -o test
 ./test
# 执行结果 
tommy
0
1.3
senna
2
0
```







## 优劣点

- 效率高
- 不适合做接口，修改不方便