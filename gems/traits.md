# Traits

Một trong những sức mạnh của D là CTFE (compile-time function evaluation),
hay khả năng tính toán các biểu thức lúc biên dịch chương trình.
Cùng với introspection (nội soi), CTFE viết các chương trình ở dạng tổng quát
và đạt được mức độ tối ưu cao .

## Hợp đồng tường minh

Trait cho phép chỉ rõ những đầu vào được chấp nhận.
Ví dụ, hàm `splitIntoWords` sau có thể chấp nhận bất kỳ kiểu chuỗi nào:

```d
S[] splitIntoWord(S)(S input)
if (isSomeString!S)
```

Điều này cũng đúng với tham số mẫu, như ví dụ `myWrapper` sau đây có thể
đảm bảo đầu vào là một hàm (có thể gọi được, `isCallable`)

```d
void myWrapper(alias f)
if (isCallable!f)
```

Ví dụ, hàm [`commonPrefix`](https://dlang.org/phobos/std_algorithm_searching.html#.commonPrefix)
từ thư viện `std.algorithm.searching`, là hàm dùng để trả về phần đầu chung giữa hai dải,
bao gồm phép phân tích đầu vào như sau

```d
auto commonPrefix(alias pred = "a == b", R1, R2)(R1 r1, R2 r2)
if (isForwardRange!R1 &&
    isInputRange!R2 &&
    is(typeof(binaryFun!pred(r1.front, r2.front)))) &&
    !isNarrowString!R1)
```

Trình biên dịch xác định việc gọi hàm này được không lúc biên dịch chương
trình, và chỉ tiếp tục nếu các điều kiện sau thỏa mãn

- `r1` có thể lưu được (do `isForwardRange`)
- `r2` là một dải (do `isInputRange`)
- `pred` gọi được với các kiểu phần tử của `r1` và `r2`
- `r1` không phải là chuỗi hẹp (`char[]`, `string`, `wchar` hay `wstring`) - cái này là để cho đơn giản, nếu không sẽ phải cần thêm các phép giải mã.

### Đặc biệt hóa

Nhiều API hướng tới nhu cầu chung chung, nhưng chúng cũng không muốn phải
trả giá phát sinh lúc chạy chương trình cho sự tổng quát hóa đó.
Nhờ khả năng của nội soi (introspection) và CTFE, ta có thể đặc biệt hóa
lúc biên dịch để đạt hiệu quả cao nhất ứng với một số kiểu đầu vào.

Một bài toán phổ biến là cần biết chính xác độ dài của danh sách hay stream
trước khi duyệt qua (khác với khi xử lý mảng). Như ví dụ sau đây là một cách
xét tới trường hợp đặc biệt để tránh dùng hàm tổng quát `walkLength`
từ thư viện `std.range`:

```d
static if (hasMember!(r, "length"))
    return r.length; // O(1)
else
    return r.walkLength; // O(n)
```

#### `commonPrefix`

Phép nội soi lúc biên dịch được dùng khắp nơi trong Phobos.
Ví dụ, trong định nghĩa của `commonPrefix`, có sự phân biệt giữa các dải
truy cập ngẫu nhiên (`RandomAccessRange`) và dải truy cập tuyến tính,
để tận dụng tốc độ cao khi có thể truy cập tùy ý các  phần từ của dải truy cập ngẫu nhiên.

#### Thêm về phép lạ của CTFE

Thư viện [std.traits](https://dlang.org/phobos/std_traits.html) tận dụng
hầu hết các [tính chất của trait trong D](https://dlang.org/spec/traits.html)
ngoại trừ  vài chỗ như  `compiles` thì không thể, bởi nó dẫn tới lỗi biên dịch

```d
__traits(compiles, obvious error - $%42); // false
```

#### Từ khóa đặc biệt

Để hỗ trợ bổ sung cho mục đích gỡ lỗi, một số từ khóa được gán nghĩa đặc biệt,
ví dụ hàm `test` sau cho thấy cách sử dụng chúng:

```d
void test(string file = __FILE__, size_t line = __LINE__, string mod = __MODULE__,
          string func = __FUNCTION__, string pretty = __PRETTY_FUNCTION__)
{
    writefln("file: '%s', line: '%s', module: '%s',\nfunction: '%s', pretty function: '%s'",
             file, line, mod, func, pretty);
}
```

Chế độ dòng lệnh của D thậm chí còn cho phép phân giải giá trị thời gian
ngay lúc dịch chương trình:

```d
rdmd --force --eval='pragma(msg, __TIMESTAMP__);'
```

## Nâng cao

- [std.range.primitives](https://dlang.org/phobos/std_range_primitives.html)
- [std.traits](https://dlang.org/phobos/std_traits.html)
- [std.meta](https://dlang.org/phobos/std_meta.html)
- [Đặc tả của traits](https://dlang.org/spec/traits.html)

## {SourceCode}

```d
import std.functional : binaryFun;
import std.range.primitives : empty, front,
    popFront,
    isInputRange,
    isForwardRange,
    isRandomAccessRange,
    hasSlicing,
    hasLength;
import std.stdio : writeln;
import std.traits : isNarrowString;

/**
Returns the common prefix of two ranges
without the auto-decoding special case.

Params:
    pred = Predicate for commonality comparison
    r1 = A forward range of elements.
    r2 = An input range of elements.

Returns:
A slice of r1 which contains the characters
that both ranges start with.
 */
auto commonPrefix(alias pred = "a == b", R1, R2)
                 (R1 r1, R2 r2)
if (isForwardRange!R1 && isInputRange!R2 &&
    !isNarrowString!R1 &&
    is(typeof(binaryFun!pred(r1.front,
                             r2.front))))
{
    import std.algorithm.comparison : min;
    static if (isRandomAccessRange!R1 &&
               isRandomAccessRange!R2 &&
               hasLength!R1 && hasLength!R2 &&
               hasSlicing!R1)
    {
        immutable limit = min(r1.length,
                              r2.length);
        foreach (i; 0 .. limit)
        {
            if (!binaryFun!pred(r1[i], r2[i]))
            {
                return r1[0 .. i];
            }
        }
        return r1[0 .. limit];
    }
    else
    {
        import std.range : takeExactly;
        auto result = r1.save;
        size_t i = 0;
        for (;
             !r1.empty && !r2.empty &&
             binaryFun!pred(r1.front, r2.front);
             ++i, r1.popFront(), r2.popFront())
        {}
        return takeExactly(result, i);
    }
}

void main()
{
    // prints: "hello, "
    writeln(commonPrefix("hello, world"d,
                         "hello, there"d));
}
```
