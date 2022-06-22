Google benchmark

# 参考

## 官方

- github：https://github.com/google/benchmark

## 第三方

-  https://www.cnblogs.com/apocelipes/p/14929728.html

# 要点

## 基本用法

### 例子

```c++
// 添加头文件
#include <benchmark/benchmark.h>

//定义指定函数
static void bench_array_operator(benchmark::State& state)
{
    std::array<int, len> arr;
    constexpr int i = 1;
    //这里这么写
    for (auto _: state) {
        arr[0] = my_pow(i);
        arr[1] = my_pow(i+1);
        arr[2] = my_pow(i+2);
        arr[3] = my_pow(i+3);
        arr[4] = my_pow(i+4);
        arr[5] = my_pow(i+5);
    }
}
//测试宏
BENCHMARK(bench_array_operator);
```

### 编译

```bash
g++ test.cc -pthread -lbenchmark -lbenchmark_main -o test
```

## 传递参数

### 例子

```c++
static void bench_array_ring_insert_int(benchmark::State& state)
{
    // 使用state.range方法获取参数
    auto length = state.range(0);
    auto ring = ArrayRing<int>(length);
    for (auto _: state) {
        for (int i = 1; i <= length; ++i) {
            ring.insert(i);
        }
        state.PauseTiming();
        ring.clear();
        state.ResumeTiming();
    }
}
// 通过arg传递参数
BENCHMARK(bench_array_ring_insert_int)->Arg(10);
```

### 传递多个参数

```c++
static void bench_array_ring_insert_int(benchmark::State& state)
{
    // 使用state.range方法获取参数获取第一个参数
    auto ring = ArrayRing<int>(state.range(0));
    for (auto _: state) {
        // 使用state.range方法获取参数 第二个参数
        for (int i = 1; i <= state.range(1); ++i) {
            ring.insert(i);
        }
        state.PauseTiming();
        ring.clear();
        state.ResumeTiming();
    }
}
// 通过Args传递多个参数
BENCHMARK(bench_array_ring_insert_int)->Args({10, 10});
```

### 多个测试

```c++
BENCHMARK(bench_array_ring_insert_int)->Arg(10)->Arg(100)->Arg(1000);
```

 ![pass args](https://img2018.cnblogs.com/blog/1434464/201906/1434464-20190622023217004-602810259.jpg) 

### 通过范围简化多个测试

#### 默认

```c++
BENCHMARK(bench_array_ring_insert_int)->Range(10, 1000);
```

 ![error](https://img2018.cnblogs.com/blog/1434464/201906/1434464-20190622023150158-2094667392.jpg) 

默认是以8为基数的n次方，

#### 改为10为基数的n次方

```c++
BENCHMARK(bench_array_ring_insert_int)->RangeMultiplier(10)->Range(10, 1000);
```

![pass args](https://img2018.cnblogs.com/blog/1434464/201906/1434464-20190622023217004-602810259.jpg)

#### 多个范围

笛卡尔积

```c++
BENCHMARK(func)->RangeMultiplier(10)->Ranges({{10, 1000}, {128， 256}});
```



等价于下面的

```cpp
BENCHMARK(func)->Args({10, 128})
               ->Args({100, 128})
               ->Args({1000, 128})
               ->Args({10, 256})
               ->Args({100, 256})
               ->Args({1000, 256})
```

## 模板简化代码量

### 例子

```c++

template <typename T, std::size_t length, bool is_reserve = true>
void bench_vector_reserve(benchmark::State& state)
{
	for (auto _ : state) {
		std::vector<T> container;
		if constexpr (is_reserve) {
			container.reserve(length);
		}
		for (std::size_t i = 0; i < length; ++i) {
			container.push_back(T{});
		}
	}
}

// 下面这个是错误的 
// BENCHMARK( bench_vector_reserve<std::string,100> );

auto t = bench_vector_reserve<std::string,100> ;
BENCHMARK(t);

BENCHMARK_TEMPLATE( bench_vector_reserve, std::string, 100);
```





