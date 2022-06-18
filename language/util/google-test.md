# google-test安装使用

## 参考

- 官方
  - 主页：https://google.github.io/googletest/
  - github：https://github.com/google/googletest
  - 教程：https://google.github.io/googletest/primer.html#simple-tests
  - 例子：https://google.github.io/googletest/samples.html，在下载包的googletest/samples目录下也有
- 安装参考：https://blog.csdn.net/liuzubing/article/details/107706818
- 非官方教程：https://zhuanlan.zhihu.com/p/369466622
- 非官方教程：https://www.jb51.net/article/220288.htm#_label8
- 非官方教程：https://blog.csdn.net/yyz_1987/article/details/124101531
- b站视频：https://www.bilibili.com/video/BV1N54y1q7mv

## 安装教程

- 最新版本：https://github.com/google/googletest/archive/refs/tags/release-1.11.0.tar.gz

- 安装cmake make，用yum即可
- yum默认安装的是cmake3.2 ，需要安装 libarchive  ，yum安装即可，不然提示一下错误：

![1652024573501](images/1652024573501.png)

```bash
yum install -y make cmake libarchive  
wget https://github.com/google/googletest/archive/refs/tags/release-1.11.0.tar.gz -O google-test-release-1.11.0.tar.gz
tar -zxvf google-test-release-1.11.0.tar.gz
cd google-test-release-1.11.0
vi googletest/CMakeLists.txt
# 将下面这个选项打开可以编译例子程序
# option(gtest_build_samples "Build gtest's sample programs." ON)
mkdir build
cd build
cmake ..
make
# 头文件默认安装到/usr/local/include
# lib库默认撞到/usr/local/lib64
make install

```

![1652025735237](images/1652025735237.png)

![1652151036598](images/1652151036598.png)

## 基本概念

### 要点

- 匿名的命名空间：保证测试的代码是不会全局变量出现、类似于static

![1652337934113](images/1652337934113.png)



- 对于没有main函数的需要添加链接到库gtest_main
- 默认需要链接pthread库

- 

### TEST宏

- 两个参数，第一个参数是模块名（test suite），第二个参数是当前测试用例的名字（testcase）

```c++
TEST(FactorialTest, Negative)
```

![1652339535990](images/1652339535990.png)

### ASSERT vs EXPECT

-  在写单元测试时，更加倾向于使用`EXPECT_XXX`，因为`ASSERT_XXX`是直接crash退出的，可能会导致一些内存、文件资源没有释放，因此可能会引入一些bug 
- 

 ![img](https://pic1.zhimg.com/80/v2-d36430993a475c4e69136fec1139becc_720w.jpg) 

 ![img](https://pic1.zhimg.com/80/v2-e1424fd945562da4ee65487de97e90c4_720w.jpg) 

### 事件机制

- 事件类型：testcase级别、testsuite级别，全局事件

#### testcase级别

- 重载两个虚函数：SetUp（相当于构造函数）、TearDown（相当于析构函数）,多个testcase都会调用这两个函数

![1652342088863](images/1652342088863.png)



- 可以通过this指针直接访问测试类中的成员函数

![1652342274533](images/1652342274533.png)

- ccc

#### TestSuite级别（单例）

![1652343228189](images/1652343228189.png)

#### 全局事件

![1652343478834](images/1652343478834.png)

#### 一个例子

```cpp
#include <iostream>

#include <map>

#include "gtest/gtest.h"

#pragma comment(lib, "gtestd.lib")

using namespace std;

class Student 

{

public:

    Student() 

    {

        age = 0;

    }

    Student(int a) 

    {

        age = a;

    }

    void print() 

    {

        cout << "*********** " << age << " **********" << endl;;

    }

private:

    int age;

};

class FooEnvironment : public testing::Environment 

{

public:

    virtual void SetUp()

    {

        std::cout << "Foo FooEnvironment SetUP" << std::endl;

    }

    virtual void TearDown()

    {

        std::cout << "Foo FooEnvironment TearDown" << std::endl;

    }

};

static Student* s;

//在第一个test之前，最后一个test之后调用SetUpTestCase()和TearDownTestCase()

class TestMap :public testing::Test

{

public:

    static void SetUpTestCase()

    {

        cout << "SetUpTestCase()" << endl;

        s = new Student(23);

    }

    static void TearDownTestCase()

    {

        delete s;

        cout << "TearDownTestCase()" << endl;

    }

    void SetUp()

    {

        cout << "SetUp() is running" << endl;

    }

    void TearDown()

    {

        cout << "TearDown()" << endl;

    }

};

TEST_F(TestMap, Test1)

{

    // you can refer to s here

    s->print();

}

int main(int argc, char** argv)

{

    testing::AddGlobalTestEnvironment(new FooEnvironment);

    testing::InitGoogleTest(&argc, argv);

    return RUN_ALL_TESTS();

}
```



## 快速开始

### 失败输出自定义消息

![1652345163486](images/1652345163486.png)

### 相同类型多个参数测试

- 可以测试更复杂

- 截屏后面那个23后面还有一个17

- 支持几种参数设置方式

  - Values：参数列表，本例中用的就是这个
  - Range：可以支持步长

  ```cpp
  testing::Range(3, 10, 2) == testing::Values(3, 5, 7, 9)
  ```

  - ValuesIn(容器或者数组) ValuesIn(begin, end)

  - 如果是bool类型，则直接可以用Bool()(分别取true 和 false)

  - combine(g1, g2, ..., gn) 排列组合

```cpp
#include<gtest/gtest.h>

// Returns true iff n is a prime number.

bool IsPrime(int n)

{

    // Trivial case 1: small numbers

    if (n <= 1) return false;

    // Trivial case 2: even numbers

    if (n % 2 == 0) return n == 2;

    // Now, we have that n is odd and n >= 3.

    // Try to divide n by every odd number i, starting from 3

    for (int i = 3; ; i += 2) {

        // We only have to try i up to the squre root of n

        if (i > n/i) break;

        // Now, we have i <= n/i < n.

        // If n is divisible by i, n is not prime.

        if (n % i == 0) return false;

    }

    // n has no integer factor in the range (1, n), and thus is prime.

    return true;

}

class IsPrimeParamTest : public::testing::TestWithParam<int>{};

TEST_P(IsPrimeParamTest, HandleTrueReturn)

{

 int n =  GetParam();

 EXPECT_TRUE(IsPrime(n));

}

//被测函数须传入多个相关的值

INSTANTIATE_TEST_CASE_P(TrueReturn, IsPrimeParamTest, testing::Values(3, 5, 11, 23, 17));

int main(int argc, char **argv)

{

    testing::InitGoogleTest(&argc, argv);

    return RUN_ALL_TESTS();

}
```



​    

![1652339889830](images/1652339889830.png)

![1652340054860](images/1652340054860.png)

### 控制顺序

![1652342838052](images/1652342838052.png)



## 官方例子

### 例子1

#### CMakeLists.txt

- 正好熟悉了一些cmake，原来官方有一个带main函数的库(gtest_main)，官方的cmake写的没完全明白后面再研究吧

  ```cmake
  #指定使用cmake的最小版本
  cmake_minimum_required(VERSION 3.5)
  
  #指定项目信息
  project(gtest_sample)
  
  #设置项目安装目录
  set(INSTALL_DIR ${CMAKE_SOURCE_DIR}/install)
  
  # 指定生成目标
  
  add_executable(sample1  samples/sample1.cc samples/sample1_unittest.cc)
  target_link_libraries(sample1 gtest_main gtest pthread) 
  
  #安装到指定目录
  install(TARGETS sample1 DESTINATION ${INSTALL_DIR}/)
  ```

  
  
#### 命令方式

  ![1652339083713](images/1652339083713.png)

