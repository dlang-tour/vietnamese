# Tài liệu

D cố gắng tích hợp trực tiếp những phần quan trọng của công nghệ phần mềm
vào trong ngôn ngữ. Bên cạnh lập trình hợp đồng và kiểm định đơn vị,
bản thân D còn cho phép sinh ra tài liệu
  [documentation](https://dlang.org/phobos/std_variant.html)
được viết kèm với mã nguồn.

Tài liệu kèm với mã nguồn được viết tuân theo các mẫu *DDoc*,
sau đó, việc thi hành `dmd -D` sẽ sinh ra các tập tin `HTML` mà nội dung
là các phần tài liệu được viết trong tập tin mã nguồn.
Ví dụ, toàn bộ tài liệu của [thư viện Phobos](https://dlang.org/phobos)
được tạo ra bằng cách này.

Trong phần chú thích của mã nguồn, các kiểu sau đây được *DDoc* hiểu:

* `/// Ba dấu chéo trước kiểu hay hàm`
* `/++ Nhiều dòng với hai dấu cộng +  +/`
* `/** Nhiều dòng với hai dấu sao *  */`

Hãy xem ví dụ trong phần mã nguồn ở trang này.

### Nâng cao

- [Thiết kế của DDoc](https://dlang.org/spec/ddoc.html)
- [Tài liệu của thư viện Phobos](https://dlang.org/phobos)

## {SourceCode:incomplete}

```d
/**
  Tính căn bận hai của một số.


  Mô tả rất dài dòng, nói thêm về lợi ích
  to lớn cho xã hội khi có một hàm thật sự
  tính toán được căn bậc hai của một số.

  Ví dụ:
  -------------------
  double sq = sqrt(4);
  -------------------
  Tham số:
    number = Số cần tính căn bậc hai .

  License: dùng thoải mái cho mọi mục đích
  Throws: không quăng lỗi ngoại lệ nào.
  Returns: căn bậc hai của số nhập vào.
*/
T sqrt(T)(T number) {
}
```
