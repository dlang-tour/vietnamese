# Kiểm định mức đơn vị

Các phép thử (kiểm định) là cách hay để đảm bảo chương trình ổn định, không lỗi.
Các phép thử mức đơn vị có thể xem như tài liệu trực quan, và cho phép lập
trình viên thay đổi mã nguồn mà không làm thay đổi tính năng của hàm
hay chương trình.

Trong `D` có hỗ trợ sẵn từ khóa `unittest` để tạo khối các phép thử mức đơn vị;
các khối này có thể để ở bất kỳ đâu trong một mô-đun D.

    // Khối mã kiểm định mức đơn vị
    unittest
    {
        assert(myAbs(-1) == 1);
        assert(myAbs(1)  == 1);
    }

Bằng cách này hiển nhiên tư duy
[phát triển với động cơ kiểm định (Test-Driven Development)](https://en.wikipedia.org/wiki/Test-driven_development)
được áp dụng.

### Thực hiện kiểm định

Các khối `unittest` có thể gồm bất kỳ mã nguồn nào, và chúng được biên dịch
và thi hành khi cờ `-unittest` được trình biên dịch `DMD` đón nhận.
Khi dùng `dub`, các mã kiểm định được thi hành với `dub test`.

### Các mã chặn `assert`

Thường các khối mã `unittest` gồm các biểu thức chặn `assert` cho các
tính năng khác nhau của hàm. Khối mã kiểm định thường được viết gần với
định nghĩa của hàm, và có thể nằm bên trong định nghĩa của lớp hay kiểu ghép.

### Mức phủ của mã kiểm định

Phép đo thông dụng để biết một ứng dụng được kiểm định tới mức nào,
là dùng chỉ số _code coverage_ (độ phủ của mã kiểm định).
Đó là tỉ lệ giữa số dòng mã được thi hành (lúc chạy kiểm định)
so với tổng số dòng mã của hàm hay ứng dụng.
Trình biên dịch DMD có thể phát sinh thông tin này khi
bạn gửi đến nó cờ `-cov`; thông tin thông kê cho từng mô-đun được sinh
ra trong tập tin `.lst` tương ứng.

Vì trình biên dịch có thể nội suy các thuộc tính của mã mẫu, nên trong D
bạn thường nên viết thêm các nhãn cho mã kiểm định để chắc chắn một số
ràng buộc xảy ra với mã kiểm định.

    @safe @nogc nothrow pure unittest
    {
        assert(myAbs() == 1);
    }

### Nâng cao

- [Unit Testing trong sách _Programming in D_](http://ddili.org/ders/d.en/unit_testing.html)
- [Unittest trong D](https://dlang.org/spec/unittest.html)

## {SourceCode}

```d
import std.stdio : writeln;

struct Vector3 {
    double x;
    double y;
    double z;

    double dot(Vector3 rhs) const {
        return x*rhs.x + y*rhs.y + z*rhs.z;
    }

    // Qua được kiểm định này là tốt
    unittest {
        assert(Vector3(1,0,0).dot(
          Vector3(0,1,0)) == 0);
    }

    string toString() const {
        import std.string : format;
        return format("x:%.1f y:%.1f z:%.1f",
          x, y, z);
    }

    // .. cái này cũng vậy
    unittest {
        assert(Vector3(1,0,0).toString() ==
          "x:1.0 y:0.0 z:0.0");
    }
}

void main()
{
    Vector3 vec = Vector3(0,1,0);
    writeln(`Vector vừa được kiểm định: `,
      vec);
}

/*
Mã kiểm định ở một nơi khác. Những mà này
không được biên dịch và được bỏ qua trong
chế độ biên dịch bình thường. Bạn cần chạy
`dub test` hoặc `dmd -unittest` để thực
hiện việc kiểm định.
*/
unittest {
    Vector3 vec;
    // T.init trả về giá trị khởi tạo mặc định
    // cho bất kỳ biến kiểu T nào được khai báo
    // mà không gán cho giá trị ban đầu.
    assert(vec.x == double.init);
}
```
