# Chạy chương trình D

Bộ cài đặt D đi kèm với trình biên dịch `dmd`, công cụ `rdmd` để chạy kịch bản
viết bằng D, và công cụ quản lý gói `dub`.

### Trình biên dịch DMD

Trình biên dịch *DMD* chuyển hóa mã nguồn D thành dạng mã máy _(nhị phân)_.
Từ dòng lệnh, bạn gửi yêu cầu biên dịch như sau

    dmd hello.d

Xem thêm về tham số điều khiển quá trình và kết quả biên dịch
  [tại trang này](https://dlang.org/dmd.html#switches)
hoặc từ kết quả của lệnh `dmd --help`.

### Chạy ngay kịch bản với `rdmd`

Theo cách truyền thống ở các ngôn ngữ biên dịch, bạn cần dịch `hello.d`
bằng `dmd`, rồi đó tự gõ vào lệnh `./hello` để thi hành kết quả.
Việc này hơi mất chút thời gian.

Phỏng theo kiểu ngôn ngữ thông dịch, bộ cài đặt D đi kèm công cụ `rdmd`
cho phép bạn chạy ngay ứng dụng của bạn:

    rdmd hello.d

Trên hệ thống UNIX, bạn dùng _(shebang)_ chỉ dấu `#!/usr/bin/env rdmd` ở
dòng đầu tiên của tập tin mã nguồn để có một _kịch bản_ trong D.

Xem thêm tham số điều khiển của `rmd` [ở đây](https://dlang.org/rdmd.html)
hoặc từ kết quả của lệnh `rdmd --help`.

### Quản lý gói với `dub`

Khi dùng D, các gói hay thư viện được quản lý nhờ ứng dụng  [`dub`](http://code.dlang.org).

Trước tiên, để tạo dự án mới, ví dụ  `hello`, bạn chạy tham số `init`:

    dub init hello

`dub` tạo ra thư mục mới `hello` và bên trong đó, sau khi thi hành

    dub

`dub` tải về các gói phụ thuộc, rồi biên dịch chương trình và thi
hành luôn kết quả.

Nếu chỉ muốn biên dịch mà không thi hành kết quả, bạn dùng `dub build`.

Xem thêm về các tham số điều khiển [ở đây](https://code.dlang.org/docs/commandline)
hoặc từ kết quả của lệnh `dub help`.

`dub` quản lý các gói nhờ vào [thư viện chung ở đây](https://code.dlang.org).
