# Chặn phạm vi

Chặn phạm vi (scope guard) cho phép thực hiện các biểu thức trước khi
kết thúc khối mã nguồn (`block`, mỗi `block` là nhóm các biểu thức, mã
nguồn đặt bên trong cặp dấu ngoại `{ ... }`) hiện tại:

* `scope(exit)` sẽ luôn thi hành khi kết thúc `block`
* `scope(success)` chỉ thi hành khi khối mã hiện tại không phát sinh lỗi ngoại lệ
* `scope(failure)` chỉ thi hành khi khối mã hiện tại phát sinh lỗi ngoại lệ

Dùng các chặn phạm vi giúp mã nguồn sạch hơn, và cho phép đặt gần nhau
phần mã nguồn để truy xuất tài nguyên và phần mã nguồn để dọn dẹp.
Các chặn cũng tăng tính an toàn, bởi nhờ đó bạn có thể đảm bảo việc
dọn dẹp luôn được thực hiện, độc lập với các hướng phát triển khác nhau
trong mạch logic của ứng dụng.

Các chặn phạm vi trong D thay thế hiệu qua cho ý niệm `RAII` trong C++
(`RAII` thường dẫn tới các đối tượng chặn phạm vi đặc biệt dành cho
các tài nguyên đặc biệt.)

Lưu ý là các biểu thức chặn phạm vi được gọi theo thứ tự ngược
với thứ tự mà chúng được định nghĩa.

### Nâng cao

- [`scope` trong sách _Programming in D_](http://ddili.org/ders/d.en/scope.html)

## {SourceCode}

```d
import std.stdio : writefln, writeln;

void main()
{
    writeln("<html>");
    scope(exit) writeln("</html>");

    {
        writeln("\t<head>");
        scope(exit) writeln("\t</head>");
        "\t<title>%s</title>".writefln("Hello");
    } // biểu thức scope(exit) ở dòng trước
      // được thi hành ở đây.

    writeln("\t<body>");
    scope(exit) writeln("\t</body>");

    writeln("\t\t<h1>Hello World!</h1>");

    // chặn phạm vi cho phép đặt gần nhau
    // mã truy xuất tài nguyên (`malloc`)
    // và mã dọn dẹp tài nguyên (`free`).
    import core.stdc.stdlib : free, malloc;
    int* p = cast(int*) malloc(int.sizeof);
    scope(exit) free(p);
}
```
