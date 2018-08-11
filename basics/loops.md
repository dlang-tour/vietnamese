# Phép lặp

Có bốn phép lặp trong D.

### 1) `while`

`while` bắt đầu phép lặp sau khi kiểm tra điều kiện:

    while (condition)
    {
        foo();
    }

### 2) `do ... while`

`do .. while` thực hiện phép lặp rồi mới kiểm tra điều kiện.
Như vậy, phép lặp luôn chạy được ít nhất một vòng.

    do
    {
        foo();
    } while (condition);

### 3) Lặp với `for`

`for` được xem là phép lặp truyền thống, bắt đầu từ C/C++ hay Java.
Mỗi phép lặp bao gồm _giá trị ban đầu_, _điều kiện_ và _biểu thức lặp_.

    for (int i = 0; i < arr.length; i++)
    {
        ...

### 4) `foreach`

Tạm thời ở đây chỉ đưa ra cú pháp của [`foreach`](basics/foreach),
còn chi tiết sẽ có ở các phần sau.

    foreach (el; arr)
    {
        ...
    }

#### Thoát vội vòng lặp

Dùng `break` khi cần thoát ngay ra khỏi vòng đang lặp.
Nếu muốn thoát ra nhiều vòng khác cùng lúc thì có thể dùng nhãn:

    NHÃN_THOÁT: for (int i = 0; i < 10; ++i)
    {
        for (int j = 0; j < 5; ++j)
        {
            ...
            break NHÃN_THOÁT;

Dùng `continue` để bỏ qua vòng lặp hiện tại và bắt đầu ngay vòng kế tiếp.

### Đọc thêm

- `for` trong sách [_Programming in D_](http://ddili.org/ders/d.en/for.html), [specification](https://dlang.org/spec/statement.html#ForStatement)
- `while` trong sách [_Programming in D_](http://ddili.org/ders/d.en/while.html), [specification](https://dlang.org/spec/statement.html#WhileStatement)
- `do-while` trong sách [_Programming in D_](http://ddili.org/ders/d.en/do_while.html), [specification](https://dlang.org/spec/statement.html#do-statement)

## {SourceCode}

```d
import std.stdio : writeln;

/*
Tính trung bình
các phần tử trong mảng.
*/
double average(int[] array)
{
    immutable initialLength = array.length;
    double accumulator = 0.0;
    while (array.length)
    {
        // Cũng có thể dùng .front
        //  import std.array : front;
        accumulator += array[0];
        array = array[1 .. $];
    }

    return accumulator / initialLength;
}

void main()
{
    auto testers = [ [5, 15], // 20
          [2, 3, 2, 3], // 10
          [3, 6, 2, 9] ]; // 20

    for (auto i = 0; i < testers.length; ++i)
    {
      writeln("Giá trị trung bình ", testers[i],
        " = ", average(testers[i]));
    }
}
```
