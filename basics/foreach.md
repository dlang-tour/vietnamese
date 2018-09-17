# Foreach

{{#img-right}}dman-teacher-foreach.jpg{{/img-right}}

Phép lặp `foreach` dễ nhìn hơn và hạn chế những sai sót vặt.

### Quét cạn mọi phần tử

Có thể dùng `foreach` để quét cạn mọi phần tử của mảng `arr` kiểu `int[]`:

    foreach (int e; arr) {
        writeln(e);
    }

Chỗ `int e` ngay sau `foreach` là tên biến đại diện cho phần tử của mảng
trong mỗi lần lặp. Bạn không cần khai báo kiểu cho biến đó:

    foreach (e; arr) {
        // typeof(e) trả về int
        writeln(e);
    }

Chỗ còn lại hiển nhiên là chính mảng `arr`, hoặc là đối tượng có thể
chịu tác động bởi phép lặp mà sau này ta gọi tên là `dải` như
[trong phần tiếp](basics/ranges).

### Lặp nhờ con trỏ tham chiếu

Trong ví dụ về phép lặp `foreach (int e; arr)` ở phần ở trên,
mỗi lần lặp việc sao chép giá trị (`copy by value`) được thực hiện:
cách sao chép này gây tốn kém bộ nhớ đáng kể với các kiểu ghép phức tạp.

Lường trước vấn đề này, D cho phép lặp nhờ con trỏ tham chiếu tới phần tử
của mảng:

    foreach (ref e; arr) {
        e = 10; // sau phép gán này
                // arr bị thay đổi
    }

### Nhấn mạnh số lần lặp

Để nhấn mạnh số lần có thể lặp, bạn có thể dùng cú pháp `..` như sau:

    foreach (i; 0 .. 3) {
        writeln(i);
    }
    // 0 1 2

Như thế `a .. b` là một dải các số nguyên, trừ số cuối cùng `b`.
Số vòng lặp tối đa là `b - a`.

### Nhấn mạnh thứ tự vòng lặp

Bạn có thể khai báo biến để D tự ghi vào đó thứ tự vòng lặp:

    foreach (i, e; [4, 5, 6]) {
        writeln(i, ":", e);
    }
    // 0:4 1:5 2:6

Ở đây, `i` sẽ lần lượt nhận giá trị `0`, `1`, ... khi ở vòng lặp đầu tiên,
thứ hai, ...

### Lặp từ cuối với `foreach_reverse`

Bạn có thể bắt đầu các vòng lặp từ phần tử cuối cùng của mảng
thay vì phần từ đầu tiên:

    foreach_reverse (e; [1, 2, 3]) {
        writeln(e);
    }
    // 3 2 1

### Đọc thêm

- [`foreach` trong sách _Programming in D_](http://ddili.org/ders/d.en/foreach.html)
- [`foreach` với kiểu ghép và lớp trong sách _Programming in D_](http://ddili.org/ders/d.en/foreach_opapply.html)
- [Đặc tả `foreach`](https://dlang.org/spec/statement.html#ForeachStatement)

## {SourceCode}

```d
import std.stdio : writefln;

void main() {
    auto arr = [
        [5, 15],      // 20
        [2, 3, 2, 3], // 10
        [3, 6, 2, 9], // 20
    ];

    foreach (i, row; arr)
    {
        double total = 0.0;
        foreach (e; row)
            total += e;

        auto avg = total / row.length;
        writefln("AVG [row=%d]: %.2f", i, avg);
    }
}
```
