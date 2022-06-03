Khúc dạo đầu về DLang
=====================

... hay là phiên bản tiếng Việt của Dlang Tour.

[![sanitycheck build status](https://github.com/dlang-tour/vietnamese/actions/workflows/d.yml/badge.svg)](https://github.com/dlang-tour/vietnamese/actions/workflows/d.yml)

Bạn đang đọc chỉ dẫn đầu tiên của dự án chuyển ngữ DLang Tour.
Kết quả của dự án có ở trang web

https://tour.dlang.org/tour/vi

Nếu bạn tìm thấy cần cải thiện, thay đổi hay trao đổi về việc chuyển ngữ
hay các vấn đề khác về ngôn ngữ, vui lòng tham gia ở
[ở đây](https://github.com/dlang-tour/vietnamese/issues).

Dự án gốc có thể xem [ở đây](https://github.com/dlang-tour/core).

Thử nghiệm
----------

Tài liệu gốc của bản dịch ở định dạng `Markdown`.
Để xem trước kết quả dịch hãy theo các bước sau:

```sh
$ dub fetch dlang-tour # chỉ cần làm một lần

# Đảm bảo rằng bạn có dlang-tour phiên bản >= 1.1.0
$ dub list | grep dlang-tour
  dlang-tour 1.1.0: .../dlang-tour-1.1.0/dlang-tour/

$ dub run dlang-tour \
  --verbose \
  --override-config="vibe-d:tls/openssl-1.1" \
  -- --lang-dir .
...

[main(----) INF] Listening for requests on http://127.0.0.1:8080/
```

Bây giờ có thể xem http://localhost:8080/ từ trình duyệt của bạn rồi:)
