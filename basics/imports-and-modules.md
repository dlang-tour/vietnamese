# Mô-đun và nạp mô-đun

{{#img-right}}turtle.svg{{/img-right}}

Một trong những tiêu chuẩn thiết kế cốt lõi của D là đảm bảo sự vững chắc
và tránh các trường hợp ngoại lệ trong ngôn ngữ.
Thành ngữ tiếng Anh phản ánh ý tưởng này là [_turtles all the way down_](https://en.wikipedia.org/wiki/Turtles_all_the_way_down).
Một ví dụ về sự chắc chắn là việc nạp mô-đun với `import`.

## Nạp mô-đun

Chương trình chào thế giới đơn giản nhất trong `D` cũng cần nạp vài mô-đun
bằng `import`, nhờ đó các hàm và kiểu từ mô-đun có thể dùng được trong chương trình.

### The turtles start falling down

Bạn __không cần__ phải để chỉ thị `import` ở đầu tập tin mã nguồn,
mà có thể đặt nó bên trong định nghĩa của hàm hay ngữ cảnh cụ thể.
Trong trong các phần tiếp theo, bạn sẽ thấy ý tuởng về vị trí này
áp dụng với hầu hết các thiết kế của D. Ngôn ngữ D không đặt ra các giới hạn tùy hứng.

### Giới hạn khi nạp mô-đun

Thư viện tiêu chuẩn [Phobos](https://dlang.org/phobos/) được nạp từ
gói có tên bắt đầu bằng `std`, và các mô-đun của thư viện đó được nạp
theo dạng `import std.MÔ-ĐUN`.

Đôi khi bạn chỉ cần nạp một số thứ thật sự cần:

    import std.stdio : writeln, writefln;

Bằng cách này bạn sẽ thấy ngay được hàm, biểu thức được lấy từ mô-đun nào,
và cũng giúp tránh việc trùng tên giữa các thành phần của các mô-đun khác nhau.

### Mô-đun và sự liên quan với cấu trúc thư mục

Hệ thống mô-đun của D dựa hoàn toàn vào cấu trúc tập tin trên hệ thống.
Ví dụ, mô-đun `my.cat` luôn có mã nguồn tên `cat.d` nằm trong thư mục `my/`,
còn thư mục này có thể nằm trong thư mục hiện tại, hoặc một trong các thư mục
được liệt kê trong chỉ thị `-I` khi biên dịch.

Các mô-đun lớn có thể được chia nhỏ ra nhờ sử dụng các thư mục con.
Ví dụ, thay cho `cat.d` bạn có thể dùng `my/cat/package.d`, và nhờ đó,
bạn có thể có mô-dun khác `my/dog/package.d` cùng bên trong thư mục `my/`.

Việc dùng tên `package.d` là để quy ước nạp tất cả các mô-đun khác cùng thư mục.

## {SourceCode}

```d
void main()
{
    import std.stdio;
    // or import std.stdio : writeln;
    writeln("Chào thế giới!");
}
```
