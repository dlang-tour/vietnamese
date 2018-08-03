# Bộ nhớ

Dlang cho phép lập trình viên can thiệp vào việc quản lý bộ nhớ.
Và để hạn chế lỗi phát sinh trong việc cấp phát bộ nhớ,
Dlang có cơ chế dọn dẹp rác bộ nhớ (`garbage collector`);
cơ chế này được kích hoạt mặc định khi bạn chạy chương trình D.

Giống trong `C`, bạn có thể dùng kiểu con trỏ `T*` trong `D`:

    int a;
    int* b = &a; // b chứa địa chỉ của a
    auto c = &a; // c có kiểu int*, giá trị là địa chỉ củ a

Vùng bộ nhớ trên `heap` được cấp nhờ  chỉ thị `new`, kết quả của nó
là con trỏ đến vùng được phát:

    int* a = new int;

Đến khi nào `a` không trỏ tới vùng nhớ đã cấp, bộ dọn rác sẽ kích hoạt
và giải phóng vùng đó cho việc khác.

Các hàm trong D được xếp vào một trong ba cấp an toàn liên quan tới
cấp phát bộ nhớ: `@system` _(mặc định)_, `@trusted`, và `@safe`.
Trong đó, `@safe` dành cho hàm có thiết kế tránh được lỗi liên quan bộ nhớ,
và chúng chỉ có thể gọi các hàm khác trong cùng cấp `@safe`, hoặc `@trusted`.
Các hàm `@safe` cũng không chấp nhận phép tính số học trên con trỏ:

    void main() @safe {
        int a = 5;
        int* p = &a;
        int* c = p + 5; // lỗi
    }

Các hàm `@trusted` được xác nhận bằng tay rằng chúng cho phép cầu nối
giữa `SafeD` và các cấp thấp hơn.

### Đọc tiếp

* [SafeD](https://dlang.org/safed.html)

## {SourceCode}

```d
import std.stdio : writeln;

void safeFun() @safe
{
    writeln("Chào thế giới");
    // Hàm bộ nhớ bằng GC thuộc lớp @safe
    int* p = new int;
}

void unsafeFun()
{
    int* p = new int;
    int* fiddling = p + 5;
}

void main()
{
    safeFun();
    unsafeFun();
}
```
