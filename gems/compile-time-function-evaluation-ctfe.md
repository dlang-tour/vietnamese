# Triển khai hàm lúc biên dịch (CTFE)

Trình biên dịch D có khả năng triển khai các hàm trong quá trình biên dịch
mã nguồn chương trình. Khả năng này gọi là
`Compile Time Function Evaluation`, viết tắt `CTFE`.

Thông thường, khi bạn định nghĩa một hàm, hàm đó chỉ được gọi đến và
triển khai (thi hành) lúc chương trình đang chạy. D mở rộng khả năng
gọi hàm đến thời điểm **biên dịch** mã nguồn, trước khi chương trình
hoạt động.

Khả năng CTFE được kích hoạt không nhờ vào biểu thức đặc biệt nào, mà do
trình biên dịch D quyết định dựa trên những giá trị đã được biết lúc
biên dịch.

    // giá trị căn bậc hai được tính lúc biên dịch
    // mã nguồn. Mã máy ứng với mã nguồn sau
    // không gồm lệnh gọi hàm nào.
    static val = sqrt(50);

Các từ khóa `static`, `immutable` hay `enum` sẽ báo trình biên dịch
thử kích hoạt CTFE nếu được. Kỹ thuật này có điểm hay là bạn không
cần viết lại mã nguồn của hàm để dùng CTFE:

    int n = doSomeRuntimeStuff();
    // giống ví dụ đầu, nhưng lần này CTFE
    // không gọi hàm nào được, do giá trị n
    // chưa có lúc biên dịch
    auto val = sqrt(n);

Ví dụ xuất sắc của việc dùng CTFE có trong thư viện
[std.regex](https://dlang.org/phobos/std_regex.html).
Kiểu `ctRegex` dùng `mixin` chuỗi và CTFE để tự động hóa việc
phát sinh và tinh chỉnh các biểu thức chính quy (`regular expression`)
lúc biên dịch mã nguồn của bạn. Phần mã nguồn cơ sở của `ctRegex`
cũng được dùng lại cho `regex` là phiên bản xử lý các biểu thức
chính quy ở lúc chạy chương trình (`run-time`).

    auto ctr = ctRegex!(`^.*/([^/]+)/?$`);
    auto tr = regex(`^.*/([^/]+)/?$`);
    // ctr và tr có thể dùng như nhau, nhưng ctr
    // sẽ nhanh hơn, do hiệu quả của CTFE.

Dù CTFE không thể kích hoạt với mọi thứ trong D,
khả năng CTFE của trình biên dịch có xu hướng mở rộng trong các phiên bản về sau.

### Nâng cao

- [Biểu thức chính quy D](https://dlang.org/regular-expression.html)
- [std.regex](https://dlang.org/phobos/std_regex.html)
- [Biên dịch theo điều kiện](https://dlang.org/spec/version.html)

## {SourceCode}

```d
import std.stdio : writeln;

/**
Tính căn bận hai của số nhờ xấp xỉ Newton.

Tham số:
    x = con số cần tính căn

Trả về: căn bậc hai của x
*/
auto sqrt(T)(T x) {
    // `epsilon` dùng để ngừng vòng lặp
    enum GoodEnough = 0.01;
    import std.math : abs;
    // chọn giá trị bắt đầu
    T z = x*x, old = 0;
    int iter;
    while (abs(z - old) > GoodEnough) {
        old = z;
        z -= ((z*z)-x) / (2*z);
    }

    return z;
}

void main() {
    double n = 4.0;
    writeln("Căn bậc hai của 4 = ",
        sqrt(n));
    static cn = sqrt(4.0);
    writeln("Tính lúc biên dịch (CTFE) 4 = ",
        cn);
}
```
