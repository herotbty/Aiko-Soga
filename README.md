# crack-soga-v2ray
 A cracked version of soga v2ray backend

> Phiên bản đã crack có thể có nhiều rủi ro không xác định khác nhau. Vui lòng sử dụng nó sau khi nhận định của riêng bạn.
# Phiên bản này là một phiên bản crack bẩn, bạn chỉ cần tìm hiểu để sử dụng nó một mình, xin vui lòng hỗ trợ phiên bản gốc

[Soga backend là một backend hỗ trợ v2ray, Trojan và Shadowsocks cùng lúc. Phiên bản cộng đồng hỗ trợ tối đa 88 người dùng và tối ưu hóa việc sử dụng bộ nhớ dài hạn.](https://github.com/sprov065/soga)

# ~~ Crack địa chỉ tải xuống tệp nhị phân：[release](https://github.com/herotbty/Aiko-Soga-Crack/releases)~~

## HOW TO CRACK

[How to crack a soga backend](https://www.rman.top/2021/02/07/crack-soga/)

# Hướng dẫn (gỡ bỏ Relase)

## Các vấn đề đã biết

Phiên bản này không phải là một bản crack hoàn chỉnh và sẽ được khởi động lại trong chu kỳ từ nửa giờ đến 1 ngày. Vui lòng xem xét cẩn thận tác động của sự cố này.

## Bật bẻ khóa.

Để kích hoạt phiên bản crack, bạn chỉ cần nhập một ký tự bất kỳ tại soga_key, nếu để trống thì đó là phiên bản cộng đồng gốc.

## hướng dẫn đầy đủ

[doc.sprov.xyz](https://doc.sprov.xyz/)

## Cài đặt đơn giản

``` bash
sudo bash < <(curl -Ls https://raw.githubusercontent.com/herotbty/Aiko-Soga-Crack/master/install.sh)
```

## Cài đặt Docker

```
# kéo hình ảnh (AikoCuteHotme)
docker pull herotbty/Aiko-Soga-Crack
# Chạy hình ảnh, vui lòng tham khảo hướng dẫn riêng của soga để biết thông số. (AikoCutehotme)
docker run --restart=always --name crack-soga -d -v /etc/soga/:/etc/soga/ --network host herotbty/Aiko-Soga-Crack \
--type=sspanel-uim \
--server_type=v2ray \
--api=webapi \
--webapi_url=https://aikocute.tk/ \
--webapi_mukey=aikocutehotmeaikocutehotme \
--soga_key=cracked_by_Aiko \
--node_id=1
```