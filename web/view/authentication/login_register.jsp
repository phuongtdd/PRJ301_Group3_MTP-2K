<%-- 
    Document   : login
    Created on : Mar 8, 2025, 5:08:04 PM
    Author     : Minh Tuan
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <title>MTP-2K - Login</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css">
        <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
        <style>

            /* Custom scrollbar styles */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: rgba(2, 12, 27, 0.95);
            }

            ::-webkit-scrollbar-thumb {
                background: #64ffda;
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: #4ad3b3;
            }

            body {
                font-family: 'Poppins', sans-serif;
                background: #0f172a;
                overflow-x: hidden;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                align-items: center;
            }

            .logo-title {
                font-size: 2.5rem;
                font-weight: bold;
                color: #4FFFB0;
                text-shadow: 0 0 5px rgba(79, 255, 176, 0.5), 0 0 10px rgba(79, 255, 176, 0.3);
                margin-top: 2rem;
                margin-bottom: 0.5rem;
                text-align: center;
                cursor: pointer;
                transition: all 0.3s ease;
                text-decoration: none;
                display: inline-block;
            }

            .logo-title:hover {
                transform: scale(1.05);
                text-shadow: 0 0 10px rgba(79, 255, 176, 0.8), 0 0 20px rgba(79, 255, 176, 0.5);
                color: #5FFFBF;
            }

            .logo-title:active {
                transform: scale(0.95);
            }

            /* music-banner là một phần tử có nền trong suốt, với chữ trắng và có bóng mờ */
            .music-banner {
                position: absolute;
                top: 8vh; /* Giảm khoảng cách từ trên xuống để gần với logo hơn */
                left: 0;
                width: 100%;
                background: transparent;
                color: #4FFFB0;
                text-align: center;
                padding: 1vh 0;
                font-size: clamp(0.875rem, 2vw, 1rem);
                z-index: 10;
                text-shadow: 0 0 5px rgba(79, 255, 176, 0.7);
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 1vh;
            }


            /* .music-waves có dạng một thanh màu trắng mờ (mô phỏng sóng âm nhạc) chạy ngang đáy trang, với nền gradient từ trắng sang trong suốt. */
            .music-waves {
                position: absolute; /* Đặt phần tử ở vị trí tuyệt đối so với phần tử chứa, hoặc trang nếu không có phần tử chứa. */
                bottom: 0; /* Đặt phần tử cách cạnh dưới của phần tử chứa (hoặc trang) 0px */
                left: 0; /* Đặt phần tử cách cạnh trái của phần tử chứa (hoặc trang) 0px */
                width: 100%; /* Đặt chiều rộng của phần tử chiếm toàn bộ chiều rộng của phần tử chứa (hoặc trang) */
                height: 100px; /* Đặt chiều cao phần tử là 100px */
                background: linear-gradient(to top, rgba(255,255,255,0.1) 0%, transparent 100%); /* Tạo nền với gradient từ trắng nhạt sang trong suốt từ dưới lên trên */
                z-index: 0; /* Chỉ số z-index thấp, phần tử này sẽ hiển thị phía dưới các phần tử có z-index cao hơn */
            }


            /* .container là một hộp chứa có các góc bo tròn */
            .container {
                position: relative; /* Đặt phần tử ở vị trí tương đối so với vị trí ban đầu của nó */
                width: 90%;
                max-width: min(90vw, 850px); /* More responsive max-width */
                min-height: min(85vh, 700px); /* Tăng chiều cao container */
                background: #fff; /* Màu nền của phần tử là màu trắng (#fff) */
                border-radius: clamp(1rem, 3vw, 2rem); /* Responsive border radius */
                box-shadow: 0 1rem 3rem rgba(0, 0, 0, 0.1); /* Thêm hiệu ứng bóng đổ với đổ bóng hướng xuống dưới và mờ dần */
                overflow: hidden; /* Ẩn phần nội dung tràn ra ngoài phần tử */
                margin: 4rem auto; /* Tăng margin trên dưới */
            }


            /* 
            Lớp .form-container là một phần tử chứa các form (như đăng nhập hoặc đăng ký), được đặt vị trí tuyệt đối, chiếm một nửa chiều rộng của phần tử chứa, và căn giữa các phần tử con cả theo chiều ngang và chiều dọc. 
            Thêm vào đó, nó có hiệu ứng chuyển tiếp để làm cho giao diện trở nên mượt mà khi có sự thay đổi.
            */
            .form-container {
                position: absolute; /* Đặt phần tử ở vị trí tuyệt đối, tức là nó sẽ được căn chỉnh dựa trên phần tử chứa gần nhất có position khác 'static'. */
                top: 0; /* Đặt phần tử bắt đầu từ cạnh trên của phần tử chứa. */
                width: 50%; /* Chiếm 50% chiều rộng của phần tử chứa. */
                height: 100%; /* Chiều cao của phần tử sẽ chiếm toàn bộ chiều cao của phần tử chứa. */
                background: #fff; /* Đặt nền của phần tử này là màu trắng. */
                display: flex; /* Sử dụng flexbox để căn chỉnh các phần tử con bên trong. */
                align-items: center; /* Căn giữa các phần tử con theo chiều dọc (trục y). */
                justify-content: center; /* Căn giữa các phần tử con theo chiều ngang (trục x). */
                transition: all 0.6s ease-in-out; /* Thêm hiệu ứng chuyển tiếp cho tất cả các thuộc tính của phần tử này, mất 0.6 giây với hiệu ứng easing để chuyển tiếp mềm mại. */
                z-index: 2; /* Đảm bảo phần tử này sẽ hiển thị trên các phần tử khác có z-index thấp hơn. */
            }


            /* .sign-in-container là phần tử chứa form đăng nhập và sẽ hiển thị ở vị trí bên trái của phần tử chứa với độ ưu tiên cao hơn (z-index: 2).*/
            .sign-in-container {
                left: 0; /* Đặt phần tử này ở vị trí bên trái của phần tử chứa (0 pixel từ bên trái). */
                z-index: 2; /* Đảm bảo phần tử này sẽ hiển thị trên các phần tử khác có z-index thấp hơn. */
            }


            /* .sign-up-container là phần tử chứa form đăng ký và sẽ bị ẩn đi (opacity: 0), có z-index thấp hơn, vì vậy nó sẽ không chồng lên form đăng nhập cho đến khi có sự thay đổi trong layout (ví dụ: khi người dùng nhấp vào nút chuyển từ đăng nhập sang đăng ký).*/
            .sign-up-container {
                left: 0; /* Đặt phần tử này ở vị trí bên trái của phần tử chứa (0 pixel từ bên trái). */
                opacity: 0; /* Đặt độ mờ (opacity) của phần tử này là 0, nghĩa là phần tử sẽ không nhìn thấy được. */
                z-index: 1; /* Đảm bảo phần tử này sẽ hiển thị dưới phần tử có z-index lớn hơn, trong trường hợp này là `.sign-in-container` (với z-index là 2). */
            }


            /* .container.right-panel-active .sign-in-container sẽ di chuyển sang bên phải và ẩn đi khi lớp .right-panel-active được thêm vào, có hiệu ứng chuyển động. */
            .container.right-panel-active .sign-in-container {
                transform: translateX(100%); /* Di chuyển form đăng nhập ra khỏi màn hình 100% chiều ngang, tạo hiệu ứng chuyển động */
                opacity: 0; /* Đặt độ mờ của form đăng nhập thành 0, khiến nó không hiển thị */
            }


            /* .container.right-panel-active .sign-up-container sẽ di chuyển sang bên phải và hiển thị khi lớp .right-panel-active được thêm vào, có hiệu ứng chuyển động. */
            .container.right-panel-active .sign-up-container {
                transform: translateX(100%); /* Di chuyển form đăng ký vào màn hình */
                opacity: 1; /* Đặt độ mờ của form đăng ký là 1, cho phép hiển thị form */
                z-index: 5; /* Đảm bảo form đăng ký hiển thị lên trên form đăng nhập */
            }


            /* .overlay-container là phần tử chứa overlay (màn hình phủ) và có hiệu ứng chuyển động khi lớp .right-panel-active được áp dụng. */
            .overlay-container {
                position: absolute; /* Đặt container của overlay ở vị trí tuyệt đối trong phần tử chứa */
                top: 0; /* Đặt container bắt đầu từ trên cùng */
                left: 50%; /* Đặt container ở giữa màn hình theo chiều ngang */
                width: 50%; /* Đặt chiều rộng container là 50% của phần tử chứa */
                height: 100%; /* Đặt chiều cao container là 100% của phần tử chứa */
                overflow: hidden; /* Ẩn phần nội dung thừa ra ngoài container */
                transition: transform 0.6s ease-in-out; /* Hiệu ứng chuyển động cho overlay khi có sự thay đổi */
                z-index: 100; /* Đảm bảo overlay sẽ chồng lên các phần tử khác */
            }


            /* .overlay là phần tử màn hình phủ với nền gradient, sẽ di chuyển khi lớp .right-panel-active được áp dụng. */
            .overlay {
                position: relative; /* Đặt overlay ở vị trí tương đối trong container */
                color: #fff; /* Màu chữ của overlay là trắng */
                background: linear-gradient(to right, #1a5276, #2980b9); /* Gradient từ xanh dương tối đến xanh dương trung bình */
                left: -100%; /* Đặt overlay ở ngoài màn hình, phía bên trái */
                height: 100%; /* Đặt chiều cao overlay là 100% chiều cao của container */
                width: 200%; /* Đặt chiều rộng overlay là 200%, gấp đôi chiều rộng của container */
                transform: translateX(0); /* Khởi tạo overlay ở vị trí bình thường */
                transition: transform 0.6s ease-in-out; /* Thêm hiệu ứng chuyển động khi thay đổi vị trí của overlay */
            }


            /* .container.right-panel-active .overlay sẽ di chuyển sang bên phải khi lớp .right-panel-active được thêm vào. */
            .container.right-panel-active .overlay {
                transform: translateX(50%); /* Khi lớp `right-panel-active` được thêm vào, overlay sẽ di chuyển vào 50% từ bên trái */
            }


            /* .overlay-panel là phần tử chứa các nội dung của overlay (màn hình phủ) và sẽ hiển thị ở vị trí bên trái hoặc bên phải của container. */
            .overlay-panel {
                position: absolute; /* Đặt overlay panel ở vị trí tuyệt đối */
                top: 0; /* Đặt overlay panel bắt đầu từ trên cùng */
                display: flex; /* Sử dụng flexbox để căn chỉnh các phần tử con trong overlay panel */
                flex-direction: column; /* Sắp xếp các phần tử theo chiều dọc */
                justify-content: center; /* Căn giữa các phần tử theo chiều dọc */
                align-items: center; /* Căn giữa các phần tử theo chiều ngang */
                padding: 0 40px; /* Thêm khoảng cách lề 40px từ hai bên */
                height: 100%; /* Đặt chiều cao overlay panel là 100% */
                width: 50%; /* Đặt chiều rộng overlay panel là 50% */
                text-align: center; /* Canh giữa nội dung trong overlay panel */
                transform: translateX(0); /* Khởi tạo overlay panel ở vị trí bình thường */
                transition: transform 0.6s ease-in-out; /* Thêm hiệu ứng chuyển động khi thay đổi vị trí */
                background: linear-gradient(to right, #1a5276, #2980b9); /* Gradient từ xanh dương tối đến xanh dương trung bình */
            }


            /* .overlay-left là phần tử chứa nội dung bên trái của overlay, sẽ di chuyển khi lớp .right-panel-active được áp dụng. */
            .overlay-left {
                transform: translateX(-20%); /* Đưa overlay panel sang bên trái 20% khi chưa kích hoạt */
            }


            /* .overlay-right là phần tử chứa nội dung bên phải của overlay, sẽ di chuyển khi lớp .right-panel-active được áp dụng. */
            .overlay-right {
                right: 0; /* Đặt overlay panel bên phải */
                transform: translateX(0); /* Đặt overlay panel ở vị trí bình thường */
            }


            /* .container.right-panel-active .overlay-left sẽ di chuyển trở lại khi lớp .right-panel-active được thêm vào. */
            .container.right-panel-active .overlay-left {
                transform: translateX(0); /* Khi lớp `right-panel-active` được thêm vào, overlay panel bên trái di chuyển vào vị trí ban đầu */
            }


            /* .container.right-panel-active .overlay-right sẽ di chuyển trở lại khi lớp .right-panel-active được thêm vào. */
            .container.right-panel-active .overlay-right {
                transform: translateX(20%); /* Khi lớp `right-panel-active` được thêm vào, overlay panel bên phải di chuyển vào 20% từ vị trí ban đầu */
            }



            /* .container.right-panel-active .overlay-container sẽ di chuyển sang bên trái khi lớp .right-panel-active được thêm vào. */
            .container.right-panel-active .overlay-container {
                transform: translateX(-100%); /* Khi lớp `right-panel-active` được thêm vào, container overlay di chuyển ra ngoài màn hình bên trái */
            }


            /* .form-box là phần tử chứa các trường nhập liệu trong form, có hiệu ứng căn giữa và chuyển động khi có sự thay đổi trong layout. */
            .form-box {
                display: flex; /* Sử dụng flexbox để căn chỉnh các phần tử con trong form */
                align-items: center; /* Căn giữa các phần tử theo chiều dọc */
                justify-content: center; /* Căn giữa các phần tử theo chiều ngang */
                flex-direction: column; /* Sắp xếp các phần tử theo chiều dọc */
                padding: 0 clamp(1rem, 5%, 2.5rem); /* Responsive padding */
                height: 100%; /* Đặt chiều cao form box là 100% */
                width: 100%; /* Đặt chiều rộng form box là 100% */
                position: relative; /* Đặt form box ở vị trí tương đối trong phần tử chứa */
                margin: 2vh 0; /* Changed from 20px to 2vh */
            }


            /* .music-icon là các biểu tượng nhạc, sẽ thay đổi độ mờ và kích thước khi người dùng di chuột qua. */
            .music-icon {
                position: absolute; /* Đặt các icon âm nhạc ở vị trí tuyệt đối */
                opacity: 0.15; /* Đặt độ mờ của icon âm nhạc */
                z-index: 0; /* Đảm bảo icon âm nhạc nằm dưới các phần tử khác */
                transition: all 0.5s ease; /* Thêm hiệu ứng chuyển động cho các icon âm nhạc */
                color: #4FFFB0; /* Màu xanh mint neon */
                text-shadow: 0 0 5px rgba(79, 255, 176, 0.7);
            }


            /* Các icon âm nhạc với vị trí và hiệu ứng riêng biệt 
            .music-icon-1, .music-icon-2, .music-icon-3 là các biểu tượng nhạc với vị trí và xoay khác nhau. */
            .music-icon-1 {
                top: 30px; /* Đặt icon âm nhạc ở vị trí 30px từ trên cùng */
                right: 30px; /* Đặt icon âm nhạc ở vị trí 30px từ bên phải */
                font-size: 20px; /* Đặt kích thước font của icon là 20px */
                transform: rotate(15deg); /* Quay icon 15 độ */
            }

            .music-icon-2 {
                bottom: 30px; /* Đặt icon âm nhạc ở vị trí 30px từ dưới cùng */
                left: 30px; /* Đặt icon âm nhạc ở vị trí 30px từ bên trái */
                font-size: 22px; /* Đặt kích thước font của icon là 22px */
                transform: rotate(-10deg); /* Quay icon -10 độ */
            }

            .music-icon-3 {
                top: 50%; /* Đặt icon âm nhạc ở giữa màn hình theo chiều dọc */
                right: 40px; /* Đặt icon âm nhạc ở vị trí 40px từ bên phải */
                font-size: 18px; /* Đặt kích thước font của icon là 18px */
                transform: rotate(25deg); /* Quay icon 25 độ */
            }


            /* Hiệu ứng hover cho các icon âm nhạc 
            Khi người dùng di chuột qua, các biểu tượng nhạc sẽ trở nên rõ ràng và phóng to. */
            .form-box:hover .music-icon {
                opacity: 0.3; /* Tăng độ mờ của icon khi hover */
                transform: scale(1.2) rotate(0deg); /* Tăng kích thước và loại bỏ độ quay của icon khi hover */
            }


            /* .input-group là phần tử chứa một trường nhập liệu, có hiệu ứng chuyển động khi người dùng di chuột qua. */
            .input-group {
                position: relative; /* Đặt phần tử vào vị trí tương đối để có thể điều chỉnh vị trí của các phần tử con. */
                width: 100%; /* Chiều rộng phần tử chiếm 100% chiều rộng của phần tử chứa. */
                margin-bottom: 2vh; /* Changed from 20px to 2vh */
                transition: all 0.3s ease; /* Thêm hiệu ứng chuyển động mượt mà khi có sự thay đổi. */
            }

            /* Khi người dùng di chuột qua input group, nó sẽ dịch chuyển một chút sang phải. */
            .input-group:hover {
                transform: translateX(5px); /* Dịch chuyển sang phải 5px khi di chuột qua. */
            }

            /* Khi di chuột qua .input-group, biểu tượng input sẽ thay đổi màu và kích thước. */
            .input-group:hover .input-icon {
                color: #3498db; /* Thay đổi màu của biểu tượng thành màu xanh dương. */
                transform: translateY(-50%) scale(1.2); /* Đẩy biểu tượng lên và phóng to nó lên 1.2 lần. */
            }

            /* .form-input là trường nhập liệu, có hiệu ứng chuyển động và thay đổi khi người dùng nhập vào. */
            .form-input {
                background-color: #f5f5f5; /* Nền màu xám nhạt cho trường nhập liệu. */
                border: none; /* Không có viền. */
                padding: 1.2vh 1.5vh 1.2vh 4.5vh; /* Changed from px to vh */
                width: 100%; /* Chiều rộng chiếm 100% phần tử chứa. */
                border-radius: 1rem; /* Changed from 15px to 1rem */
                outline: none; /* Loại bỏ viền khi trường nhập liệu được focus. */
                transition: all 0.3s ease; /* Hiệu ứng chuyển động mượt mà khi có sự thay đổi. */
                font-size: clamp(0.875rem, 1.5vw, 1rem); /* Responsive font size */
            }

            /* Khi trường nhập liệu được focus, nền sẽ chuyển sang trắng và có bóng đổ. */
            .form-input:focus {
                background-color: #fff; /* Nền chuyển thành màu trắng khi focus. */
                box-shadow: 0 0 0 2px #3498db; /* Thêm bóng đổ màu xanh dương khi focus vào trường nhập liệu. */
                transform: scale(1.02); /* Phóng to trường nhập liệu một chút khi focus vào. */
            }

            /* .input-icon là biểu tượng trong trường nhập liệu, có hiệu ứng chuyển động khi người dùng di chuột qua. */
            .input-icon {
                position: absolute; /* Đặt biểu tượng ở vị trí tuyệt đối trong trường nhập liệu. */
                left: 15px; /* Khoảng cách từ bên trái là 15px. */
                top: 50%; /* Đặt biểu tượng tại giữa của trường nhập liệu theo chiều dọc. */
                transform: translateY(-50%); /* Điều chỉnh vị trí biểu tượng để nó căn giữa theo chiều dọc. */
                color: #6b7280; /* Màu của biểu tượng là màu xám. */
                transition: all 0.3s ease; /* Thêm hiệu ứng chuyển động mượt mà khi có sự thay đổi. */
            }

            /* .equalizer là một phần tử chứa các thanh âm nhấp nhô, thường dùng để tạo hiệu ứng âm thanh. */
            .equalizer {
                display: flex; /* Sử dụng flexbox để sắp xếp các thanh âm. */
                align-items: flex-end; /* Căn chỉnh các thanh âm ở phía dưới cùng. */
                height: 20px; /* Chiều cao của equalizer là 20px. */
                margin: 0 auto; /* Căn giữa thanh âm trong container. */
            }

            /* .bar là các thanh âm trong equalizer. */
            .bar {
                width: 4px; /* Chiều rộng mỗi thanh âm là 4px. */
                margin: 0 2px; /* Khoảng cách giữa các thanh âm là 2px. */
                background: white; /* Màu của thanh âm là trắng. */
            }

            /* Các thanh âm sẽ có chiều cao khác nhau để tạo hiệu ứng nhấp nhô. */
            .bar1 {
                height: 8px;
            }
            .bar2 {
                height: 16px;
            }
            .bar3 {
                height: 10px;
            }
            .bar4 {
                height: 14px;
            }
            .bar5 {
                height: 18px;
            }
            .bar6 {
                height: 10px;
            }
            .bar7 {
                height: 16px;
            }
            .bar8 {
                height: 8px;
            }

            /* .logo-container là phần tử chứa logo, có hiệu ứng phóng to và thay đổi bóng đổ khi hover. */
            .logo-container {
                position: relative; /* Đặt phần tử logo ở vị trí tương đối. */
                width: clamp(100px, 20vw, 150px); /* Responsive logo size */
                height: clamp(100px, 20vw, 150px);
                margin: 0 auto; /* Căn giữa logo. */
                border-radius: 50%; /* Tạo hình tròn cho logo. */
                overflow: hidden; /* Ẩn phần thừa ra ngoài hình tròn. */
                box-shadow: 0 0 25px rgba(255, 255, 255, 0.4); /* Thêm bóng đổ nhẹ cho logo. */
                transition: all 0.5s ease; /* Thêm hiệu ứng chuyển động mượt mà. */
                border: 4px solid rgba(255, 255, 255, 0.3); /* Thêm viền mờ cho logo. */
            }

            /* Khi người dùng di chuột qua logo, nó sẽ phóng to và bóng đổ sẽ tăng lên. */
            .logo-container:hover {
                transform: scale(1.05); /* Phóng to logo lên 1.05 lần. */
                box-shadow: 0 0 30px rgba(255, 255, 255, 0.5); /* Tăng bóng đổ khi hover. */
            }

            /* .logo-image là hình ảnh trong logo, với hiệu ứng cover để đảm bảo hình ảnh phủ đầy container. */
            .logo-image {
                width: 100%; /* Chiều rộng hình ảnh chiếm 100% phần tử chứa. */
                height: 100%; /* Chiều cao hình ảnh chiếm 100% phần tử chứa. */
                object-fit: cover; /* Đảm bảo hình ảnh phủ đầy container mà không bị méo. */
                transition: all 0.5s ease; /* Thêm hiệu ứng chuyển động mượt mà. */
            }

            /* .logo-text là phần văn bản dưới logo, có hiệu ứng đổ bóng và canh giữa. */
            .logo-text {
                position: absolute; /* Đặt văn bản ở vị trí tuyệt đối. */
                bottom: -30px; /* Đặt văn bản cách dưới logo 30px. */
                left: 0;
                right: 0;
                text-align: center; /* Căn giữa văn bản. */
                font-weight: bold; /* Đậm cho văn bản. */
                font-size: clamp(1rem, 2.5vw, 1.25rem); /* Responsive font size */
                color: white; /* Màu chữ là trắng. */
                text-shadow: 0 0 10px rgba(0,0,0,0.3); /* Thêm bóng đổ cho chữ. */
                color: #4FFFB0; /* Màu xanh mint neon */
                font-weight: bold;
                text-shadow: 0 0 5px #4FFFB0, 0 0 10px #4FFFB0, 0 0 20px #4FFFB0;
                letter-spacing: 2px;
            }

            /* .social-container là phần tử chứa các nút chia sẻ mạng xã hội, căn giữa các nút. */
            .social-container {
                margin: 15px 0; /* Khoảng cách trên và dưới là 15px. */
                display: flex; /* Dùng flexbox để căn chỉnh các nút chia sẻ. */
                justify-content: center; /* Căn giữa các nút trong container. */
            }

            /* .social-btn là các nút chia sẻ mạng xã hội, có hiệu ứng hover và ripple khi nhấn. */
            .social-btn {
                width: 45px; /* Chiều rộng mỗi nút là 45px. */
                height: 45px; /* Chiều cao mỗi nút là 45px. */
                border-radius: 50%; /* Đặt các nút chia sẻ thành hình tròn. */
                display: flex; /* Dùng flexbox để căn chỉnh các icon trong nút. */
                justify-content: center;
                align-items: center;
                margin: 0 10px; /* Khoảng cách giữa các nút là 10px. */
                color: #333; /* Màu của các icon là xám đậm. */
                border: none; /* Không có viền cho nút. */
                transition: all 0.3s; /* Thêm hiệu ứng chuyển động mượt mà khi hover. */
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); /* Thêm bóng đổ cho nút. */
                position: relative;

                background: #fff;
                border-radius: 30px;
                box-shadow: 0 15px 50px rgba(0, 0, 0, 0.1);
                overflow: hidden;
                margin: 0 1rem;

            }

            /* Khi người dùng di chuột qua nút, nó sẽ có hiệu ứng ripple. */
            .social-btn:after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 5px;
                height: 5px;
                background: rgba(255, 255, 255, 0.5); /* Màu hiệu ứng ripple là màu trắng mờ. */
                opacity: 0;
                border-radius: 100%;
                transform: scale(1, 1) translate(-50%); /* Đặt vị trí của hiệu ứng ripple tại giữa nút. */
                transform-origin: 50% 50%; /* Căn chỉnh hiệu ứng từ giữa nút. */
            }

            /* Khi người dùng di chuột qua nút, sẽ có hiệu ứng ripple. */
            .social-btn:hover:after {
                animation: ripple 1s ease-out;
            }

            /* Các nút chia sẻ có màu sắc và hiệu ứng khi hover. */
            .social-btn.google {
                background-color: #db4437; /* Nền màu đỏ cho nút Google. */
                color: white; /* Màu chữ là trắng. */
            }

            .social-btn.facebook {
                background-color: #3b5998; /* Nền màu xanh cho nút Facebook. */
                color: white; /* Màu chữ là trắng. */
            }

            /* Khi người dùng hover qua các nút chia sẻ, nút sẽ dịch chuyển lên một chút và có bóng đổ. */
            .social-btn:hover {
                transform: translateY(-5px);
                box-shadow: 0 7px 14px rgba(0, 0, 0, 0.2);
            }

            /* .toggle-password là phần tử cho phép người dùng chuyển đổi giữa hiển thị và ẩn mật khẩu, có hiệu ứng con trỏ dạng 'pointer' khi di chuột qua. */
            .toggle-password {
                cursor: pointer; /* Thay đổi con trỏ khi di chuột qua thành hình tay (pointer) để cho thấy đây là phần tử có thể nhấn vào. */
            }

            /* .login-btn là nút đăng nhập, với màu nền tím và các hiệu ứng chuyển động khi hover hoặc click. */
            .login-btn {
                position: relative; /* Đặt vị trí của nút ở tương đối trong container. */
                overflow: hidden; /* Ẩn các phần tử thừa ra ngoài nút. */
                z-index: 1; /* Đảm bảo nút có độ ưu tiên cao hơn các phần tử khác. */
                background: #3498db; /* Nền nút có màu xanh dương. */
                transition: all 0.3s ease; /* Thêm hiệu ứng chuyển động cho các thay đổi. */
                border: none; /* Không có viền cho nút. */
                padding: clamp(0.8rem, 2vh, 1.2rem) clamp(1.5rem, 4vw, 2rem);
                border-radius: 30px; /* Bo tròn góc của nút. */
                font-weight: bold; /* Đặt chữ đậm. */
                letter-spacing: 1px; /* Khoảng cách giữa các ký tự là 1px. */
                text-transform: uppercase; /* Viết hoa toàn bộ chữ. */
                margin-top: 10px; /* Khoảng cách từ trên xuống là 10px. */
                cursor: pointer; /* Đổi con trỏ thành hình tay khi người dùng di chuột qua nút. */
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1); /* Thêm bóng đổ nhẹ cho nút. */
                color: white; /* Màu chữ là trắng. */
                width: 100%; /* Chiều rộng nút chiếm 100% phần tử chứa. */
                display: flex; /* Dùng Flexbox để căn giữa các phần tử con trong nút. */
                align-items: center; /* Căn giữa các phần tử theo chiều dọc. */
                justify-content: center; /* Căn giữa các phần tử theo chiều ngang. */
            }

            /* Khi người dùng hover qua nút, nút sẽ dịch chuyển lên và có bóng đổ mạnh hơn. */
            .login-btn:hover {
                transform: translateY(-3px); /* Dịch chuyển nút lên trên 3px khi hover. */
                box-shadow: 0 15px 25px rgba(0, 0, 0, 0.2); /* Tăng độ bóng đổ khi hover. */
            }

            /* Khi người dùng nhấn vào nút, nó sẽ dịch chuyển xuống một chút. */
            .login-btn:active {
                transform: translateY(1px); /* Dịch chuyển nút xuống 1px khi click. */
            }

            /* Hiệu ứng cho nút đăng nhập, khi hover sẽ xuất hiện gradient từ trái sang phải. */
            .login-btn::before {
                content: ''; /* Không có nội dung trong phần này, chỉ sử dụng để tạo hiệu ứng. */
                position: absolute; /* Đặt phần tử này ở vị trí tuyệt đối. */
                top: 0; /* Đặt phần tử này ở vị trí trên cùng của nút. */
                left: -100%; /* Đặt phần tử ra ngoài nút ở bên trái. */
                width: 100%; /* Chiều rộng phần tử này chiếm 100% nút. */
                height: 100%; /* Chiều cao phần tử này chiếm 100% nút. */
                background: linear-gradient(90deg, transparent, rgba(255,255,255,0.4), transparent); /* Tạo hiệu ứng gradient từ trái sang phải với màu trắng mờ. */
                transition: 0.5s; /* Hiệu ứng chuyển động mượt mà khi hover. */
                z-index: -1; /* Đảm bảo phần tử này nằm dưới nút chính. */
            }

            /* Khi hover qua nút, gradient sẽ di chuyển sang phải. */
            .login-btn:hover::before {
                left: 100%; /* Dịch chuyển phần tử gradient sang phải khi hover. */
            }

            /* .btn-content là phần tử chứa nội dung của nút, bao gồm cả icon và chữ. */
            .btn-content {
                display: flex; /* Sử dụng flexbox để căn giữa các phần tử con (chữ và icon). */
                align-items: center; /* Căn giữa các phần tử theo chiều dọc. */
                justify-content: center; /* Căn giữa các phần tử theo chiều ngang. */
            }

            /* .music-note là phần tử biểu tượng nốt nhạc, với hiệu ứng biến mất khi di chuột qua. */
            .music-note {
                position: absolute; /* Đặt phần tử ở vị trí tuyệt đối trong container. */
                color: white; /* Màu của nốt nhạc là trắng. */
                font-size: 1.2rem; /* Kích thước font chữ của biểu tượng nốt nhạc là 1.2rem. */
                opacity: 0; /* Đặt độ mờ ban đầu là 0, nghĩa là không nhìn thấy. */
                pointer-events: none; /* Loại bỏ khả năng tương tác với phần tử này (không gây sự kiện khi nhấp vào). */
            }

            /* .ghost-btn là một nút với nền trong suốt và viền trắng. Khi hover sẽ có hiệu ứng chuyển động và thay đổi màu sắc. */
            .ghost-btn {
                background: transparent; /* Nền của nút là trong suốt. */
                border: 2px solid white; /* Viền của nút là 2px và màu trắng. */
                color: white; /* Màu chữ là trắng. */
                padding: clamp(0.8rem, 2vh, 1.2rem) clamp(1.5rem, 4vw, 2rem);
                border-radius: 30px; /* Bo tròn góc của nút. */
                font-weight: bold; /* Đặt chữ đậm. */
                letter-spacing: 1px; /* Khoảng cách giữa các chữ là 1px. */
                text-transform: uppercase; /* Viết hoa chữ. */
                margin-top: 15px; /* Khoảng cách từ trên xuống là 15px. */
                cursor: pointer; /* Đổi con trỏ thành hình tay khi di chuột qua. */
                transition: all 0.3s ease; /* Thêm hiệu ứng chuyển động mượt mà khi hover. */
                position: relative; /* Đặt phần tử này ở vị trí tương đối. */
                overflow: hidden; /* Ẩn các phần tử thừa ra ngoài nút. */
                z-index: 1; /* Đảm bảo nút có độ ưu tiên cao hơn các phần tử khác. */
            }

            /* Hiệu ứng cho phần tử .ghost-btn khi hover, nền sẽ chuyển màu và có bóng đổ. */
            .ghost-btn:hover:before {
                left: 100%; /* Dịch chuyển phần tử gradient ra ngoài khi hover. */
            }

            /* Hiệu ứng hover cho .ghost-btn: nền của nút sẽ chuyển thành màu trắng và chữ chuyển thành màu tím. */
            .ghost-btn:hover {
                background: white; /* Nền nút sẽ chuyển thành màu trắng khi hover. */
                color: #1a5276; /* Màu chữ chuyển thành xanh dương. */
                transform: translateY(-3px); /* Dịch chuyển nút lên một chút khi hover. */
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1); /* Tăng độ bóng đổ khi hover. */
            }

            /* h1 là tiêu đề chính trong trang, có kiểu chữ đậm và kích thước chữ 22px. */
            h1 {
                font-weight: bold; /* Đặt chữ đậm. */
                margin: 0; /* Loại bỏ khoảng cách ngoài tiêu đề. */
                font-size: clamp(1.2rem, 4vw, 1.5rem); /* Responsive font size */
                color: #333; /* Màu chữ là xám đậm. */
            }

            /* p là đoạn văn bản với kích thước chữ 14px và khoảng cách dòng là 20px. */
            p {
                font-size: clamp(0.875rem, 2vw, 1rem); /* Responsive font size */
                font-weight: 300; /* Đặt chữ nhẹ (ít đậm). */
                line-height: 20px; /* Khoảng cách giữa các dòng là 20px. */
                letter-spacing: 0.5px; /* Khoảng cách giữa các chữ là 0.5px. */
                margin: 15px 0 20px; /* Khoảng cách trên và dưới là 15px và 20px. */
            }

            /* .overlay h1 là tiêu đề trong phần overlay, có màu chữ trắng và kích thước chữ 24px. */
            .overlay h1 {
                color: white; /* Màu chữ là trắng. */
                font-size: 24px; /* Kích thước chữ là 24px. */
                text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
            }

            /* .overlay p là đoạn văn bản trong phần overlay, có màu chữ trắng và độ mờ 0.8. */
            .overlay p {
                color: white; /* Màu chữ là trắng. */
                opacity: 0.8; /* Độ mờ của chữ là 0.8 (mờ đi một chút). */
                text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
            }

            /* Thay đổi màu của các liên kết từ tím sang xanh nước biển */
            .text-purple-500 {
                color: #3498db !important; /* Màu xanh nước biển */
            }

            .hover\:text-purple-600:hover {
                color: #2980b9 !important; /* Màu xanh nước biển đậm hơn khi hover */
            }

            /* Responsive styles for different screen sizes */
            @media (max-width: 768px) {
                .container {
                    width: 95%;
                    min-height: auto;
                    margin: 1rem auto;
                }

                .form-container {
                    width: 100%;
                }

                .overlay-container {
                    display: none; /* Hide overlay on mobile */
                }

                .sign-up-container {
                    opacity: 1;
                    z-index: 5;
                    transform: translateX(100%);
                }

                .form-box {
                    padding: 0 1rem;
                }

                .social-btn {
                    width: 2.5rem; /* Smaller social buttons on mobile */
                    height: 2.5rem;
                }

                h1 {
                    font-size: clamp(1.2rem, 4vw, 1.5rem);
                }

                p {
                    font-size: clamp(0.875rem, 2vw, 1rem);
                }
            }

            @media (max-width: 480px) {
                body {
                    padding: 1rem;
                }

                .container {
                    width: 100%;
                    margin: 0.5rem auto;
                }

                .music-banner {
                    font-size: 0.8rem;
                }

                .form-input {
                    padding: 1vh 1.2vh 1vh 3vh;
                }

                .social-container {
                    flex-wrap: wrap;
                    gap: 1rem;
                }
            }

            /* Styles cho validation */
            .error-message {
                color: #e74c3c;
                font-size: 0.8rem;
                margin-top: 5px;
                animation: fadeIn 0.3s ease;
                padding-left: 15px;
                position: absolute; /* Thêm position absolute */
                left: 0;
                bottom: -20px; /* Đặt thông báo lỗi phía dưới input */
                width: 100%;
                z-index: 1;
            }

            .input-error {
                border: 1px solid #e74c3c !important;
                background-color: rgba(231, 76, 60, 0.05) !important;
            }

            .input-success {
                border: 1px solid #2ecc71 !important;
                background-color: rgba(46, 204, 113, 0.05) !important;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Ẩn icon mắt mặc định của trình duyệt */
            input[type="password"]::-ms-reveal,
            input[type="password"]::-ms-clear {
                display: none;
            }

            input[type="password"]::-webkit-contacts-auto-fill-button,
            input[type="password"]::-webkit-credentials-auto-fill-button {
                visibility: hidden;
                display: none !important;
                pointer-events: none;
                height: 0;
                width: 0;
                margin: 0;
            }

            /* Thêm style cho input password */
            input[type="password"] {
                -webkit-text-security: none !important;
                -moz-text-security: none !important;
                text-security: none !important;
            }

            /* Sửa lại style cho container thông báo lỗi */
            #loginError {
                position: absolute;
                bottom: 80px; /* Điều chỉnh vị trí để không đẩy form */
                left: 50%;
                transform: translateX(-50%);
                width: 90%;
                max-width: 400px;
                z-index: 1000;
                display: none; /* Ẩn mặc định */
                opacity: 0;
                transition: opacity 0.5s ease;
            }

            /* Thêm style cho form-box để đảm bảo vị trí tương đối cho thông báo lỗi */
            .form-box {
                position: relative;
                width: 100%;
                height: 100%;
                display: flex;
                flex-direction: column;
                align-items: center;
                justify-content: center;
                padding: 2rem;
            }

            /* Style cho thông báo lỗi đăng nhập */
            .login-error-message {
                background-color: rgba(231, 76, 60, 0.1);
                border: 1px solid #e74c3c;
                color: #e74c3c;
                padding: 12px 15px;
                border-radius: 8px;
                text-align: center;
                margin-top: 15px;
                font-size: 0.9rem;
                opacity: 0;
                transition: opacity 0.5s ease;
                display: none;
            }

            .login-error-message.show {
                opacity: 1;
                display: block;
            }

            /* Style cho thông báo lỗi đăng nhập */
            .login-error {
                position: fixed;
                top: 20px;
                left: 50%;
                transform: translateX(-50%);
                background-color: #fee2e2;
                border: 1px solid #ef4444;
                color: #dc2626;
                padding: 12px 20px;
                border-radius: 8px;
                text-align: center;
                font-size: 0.9rem;
                z-index: 1000;
                display: none;
                opacity: 0;
                transition: opacity 0.3s ease;
                box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                max-width: 400px;
                width: 90%;
            }

            .login-error.show {
                display: block;
                opacity: 1;
            }

            /* Style cho nút home */
            .home-button {
                position: fixed;
                top: 20px;
                left: 20px;
                width: 50px;
                height: 50px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(5px);
                -webkit-backdrop-filter: blur(5px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
                transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                z-index: 1000;
                overflow: hidden;
            }

            .home-button:hover {
                transform: translateY(-2px) scale(1.05);
                background: rgba(255, 255, 255, 0.2);
                box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
                border-color: rgba(255, 255, 255, 0.3);
            }

            .home-button:active {
                transform: translateY(0) scale(0.95);
            }

            .home-logo {
                width: 35px;
                height: 35px;
                object-fit: contain;
                transition: transform 0.3s ease;
            }

            .home-button:hover .home-logo {
                transform: rotate(360deg) scale(1.1);
            }


            .home-button:hover {
                animation: pulse 1.5s infinite;
            }
        </style>
    </head>
    <body>


        <!-- Logo Title with link. Nhấn vào sẽ ra home -->
        <a href="${pageContext.request.contextPath}/home" class="logo-title">MTP-2K</a>

        <div class="music-banner">
            &#127911; Harmony for your heart, melody for your mind  &#127911;
        </div>

        <div class="container" id="container">
            <!-- Sign In Form -->
            <div class="form-container sign-in-container">
                <div class="form-box">
                    <i class="fas fa-music music-icon music-icon-1"></i>
                    <i class="fas fa-headphones music-icon music-icon-2"></i>
                    <i class="fas fa-compact-disc music-icon music-icon-3"></i>
                    <h1 class="mb-4">
                        <i class="fas fa-headphones-alt mr-2 text-purple-500"></i>
                        Sign In to MTP-2K with
                    </h1>

                    <%-- Sử dụng JSTL để tạo danh sách các nút mạng xã hội --%>
                    <%-- 
                    - <c:set>: Tạo biến JSTL để lưu trữ mảng các loại nút và biểu tượng.
                    - value="${['google', 'facebook']}": Tạo mảng chứa các class CSS cho nút.
                    - <c:forEach>: Vòng lặp qua mảng để tạo các nút mạng xã hội.
                Lợi ích: Nếu muốn thêm nút mạng xã hội mới (như Twitter), bạn chỉ cần thêm vào mảng mà không cần sửa HTML.
                    --%>

                    <div class="social-container">
                        <c:set var="socialButtons" value="${['google', 'facebook']}" />
                        <c:set var="socialIcons" value="${['fa-google', 'fa-facebook-f']}" />

                        <c:forEach var="i" begin="0" end="${socialButtons.size() - 1}">
                            <a href="#" class="social-btn ${socialButtons[i]}">
                                <i class="fab ${socialIcons[i]}"></i>
                            </a>
                        </c:forEach>
                    </div>




                    <span class="text-gray-500 text-sm">or use your account</span>

                    <form action="${pageContext.request.contextPath}/login?action=login" method="post" class="w-full mt-4">
                        <div class="input-group">
                            <i class="fas fa-user input-icon"></i>
                            <input type="text" name="username" placeholder="Username or Email" 
                                   class="form-input" value="<c:out value="${param.username}" />" required>
                        </div>

                        <div class="input-group">
                            <i class="fas fa-lock input-icon"></i>
                            <input type="password" name="password" id="password" placeholder="Password" 
                                   class="form-input" required>
                            <!-- Con mắt vĩnh viễn trong form đăng nhập -->
                            <i class="fas fa-eye toggle-password absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400" 
                               onclick="togglePasswordVisibility()"></i>
                        </div>


                        <div class="flex justify-between items-center w-full mb-4">
                            <label class="flex items-center text-gray-600 text-sm">
                                <input type="checkbox" name="remember" class="form-checkbox h-4 w-4 text-indigo-600 rounded focus:ring-indigo-500 mr-2">
                                <span>Remember me</span>
                            </label>
                            <a href="#" class="text-sm text-purple-500 hover:text-purple-600">Forgot password?</a>
                        </div>

                        <%-- Thêm div cho thông báo lỗi đăng nhập --%>
                        <c:if test="${param.action eq 'login' && not empty requestScope.error}">
                            <div class="error-message text-center mb-24 text-red-600 bg-red-100 border border-red-400 rounded p-2">
                                <c:out value="${requestScope.error}" />
                            </div>
                        </c:if>

                        <button type="submit" id="loginButton" class="login-btn">
                            <div class="btn-content">
                                <i class="fas fa-sign-in-alt mr-2"></i>
                                <span>Sign In</span>
                            </div>
                        </button>

                        <div class="mt-4 text-center text-gray-600 text-sm">
                            Don't have an account? <button type="button" id="signUpLink" class="text-purple-500 font-semibold hover:underline">Sign Up</button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Sign Up Form -->
            <div class="form-container sign-up-container">
                <div class="form-box">
                    <i class="fas fa-music music-icon music-icon-1"></i>
                    <i class="fas fa-headphones music-icon music-icon-2"></i>
                    <i class="fas fa-compact-disc music-icon music-icon-3"></i>
                    <h1 class="mb-4">
                        <i class="fas fa-user-plus mr-2 text-purple-500"></i>
                        Create Account
                    </h1>

                    <%-- Sử dụng JSTL để tạo danh sách các nút mạng xã hội (giống như trên) --%>
                    <div class="social-container">
                        <c:forEach var="i" begin="0" end="${socialButtons.size() - 1}">
                            <a href="#" class="social-btn ${socialButtons[i]}">
                                <i class="fab ${socialIcons[i]}"></i>
                            </a>
                        </c:forEach>
                    </div>

                    <span class="text-gray-500 text-sm">or sign up with your email or facebook</span>

                    <form action="${pageContext.request.contextPath}/login?action=register" method="post" class="w-full mt-4" id="registerForm">
                        <%--
                        - <c:set var="registerFields" value="${[...]}">: Tạo mảng các đối tượng chứa thông tin về các trường input.
                        - <c:forEach var="field" items="${registerFields}">: Vòng lặp qua mảng để tạo các trường input.
                        - <c:if test="${not empty field.id}">id="${field.id}"</c:if>: Thêm thuộc tính id nếu có.
                        - <c:if test="${field.name eq 'password'}">: Thêm icon hiển thị/ẩn mật khẩu chỉ cho trường password.
                Lợi ích: Dễ dàng thêm, xóa hoặc sửa đổi các trường input mà không cần sửa nhiều HTML.
                        --%>
                        <%-- Sử dụng JSTL để tạo các trường input --%>
                        <c:set var="registerFields" value="${[
                                                             {'name': 'fullName', 'type': 'text', 'placeholder': 'Full Name', 'icon': 'fa-id-card', 'id': 'fullName'},
                                                             {'name': 'userName', 'type': 'text', 'placeholder': 'Username', 'icon': 'fa-user', 'id': 'userName'},
                                                             {'name': 'email', 'type': 'email', 'placeholder': 'Email', 'icon': 'fa-envelope', 'id': 'email'},
                                                             {'name': 'password', 'type': 'password', 'placeholder': 'Password', 'icon': 'fa-lock', 'id': 'registerPassword', 'showToggle': true},
                                                             {'name': 'confirmPassword', 'type': 'password', 'placeholder': 'Confirm Password', 'icon': 'fa-lock', 'id': 'confirmPassword', 'showToggle': true},
                                                             {'name': 'phone', 'type': 'tel', 'placeholder': 'Phone', 'icon': 'fa-phone', 'id': 'phone'}
                                                             ]}" />

                        <c:forEach var="field" items="${registerFields}">
                            <div class="input-group">
                                <i class="fas ${field.icon} input-icon"></i>
                                <input type="${field.type}" name="${field.name}" 
                                       <c:if test="${not empty field.id}">id="${field.id}"</c:if>
                                       placeholder="${field.placeholder}" 
                                       class="form-input" required>
                                <%-- Hiển thị icon mắt khi click vào (Vĩnh viễn) --%>
                                <c:if test="${field.showToggle eq true}">
                                    <i class="fas fa-eye toggle-password absolute right-4 top-1/2 transform -translate-y-1/2 text-gray-400" 
                                       onclick="toggleRegisterPasswordVisibility('${field.id}')"></i>
                                </c:if>

                                <div class="error-message" id="${field.id}-error"></div>
                            </div>
                        </c:forEach>

                        <button type="submit" class="login-btn">
                            <div class="btn-content">
                                <i class="fas fa-user-plus mr-2"></i>
                                <span>Sign Up</span>
                            </div>
                        </button>

                        <div class="mt-4 mb-12 text-center text-gray-600 text-sm">
                            Already have an account? <button type="button" id="signInLink" class="text-purple-500 font-semibold hover:underline">Sign In</button>
                        </div>

                        <%-- Hiển thị thông báo lỗi đăng ký --%>
                        <c:if test="${not empty requestScope.error}">
                            <div class="mt-4 bg-red-500 bg-opacity-20 border border-red-500 text-red-700 px-4 py-2 rounded-lg text-sm">
                                <p><c:out value="${requestScope.error}" /></p>
                            </div>
                        </c:if>

                        <%-- Hiển thị thông báo đăng ký thành công --%>
                        <c:if test="${not empty requestScope.registerSuccess}">
                            <div class="mt-4 bg-green-500 bg-opacity-20 border border-green-500 text-green-700 px-4 py-2 rounded-lg text-sm">
                                <p><c:out value="${requestScope.registerSuccess}" /></p>
                            </div>
                        </c:if>
                    </form>
                </div>
            </div>

            <!-- Overlay Container -->
            <div class="overlay-container">
                <div class="overlay">
                    <!-- Left Overlay Panel (Sign Up) -->
                    <div class="overlay-panel overlay-left">
                        <div class="logo-container mb-4">
                            <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K Logo" class="logo-image">
                            <div class="logo-text">MTP-2K</div>
                        </div>

                        <%-- 
                        - <c:set var="leftPanelContent" value="${{...}}">: Tạo đối tượng chứa nội dung của panel.
                        - <c:out value="${leftPanelContent.title}">: Hiển thị tiêu đề từ đối tượng.
                    Lợi ích: Dễ dàng thay đổi nội dung panel mà không cần sửa nhiều HTML.
                        --%>
                        <%-- Sử dụng JSTL để hiển thị nội dung panel --%>
                        <c:set var="leftPanelContent" value="${{
                                                               'title': 'Welcome Back!',
                                                               'message': 'To keep connected with us please login with your personal info',
                                                               'buttonText': 'Sign In',
                                                               'buttonIcon': 'fa-sign-in-alt',
                                                               'buttonId': 'signIn'
                                                               }}" />

                        <h1 class="mb-2"><c:out value="${leftPanelContent.title}" /></h1>
                        <p><c:out value="${leftPanelContent.message}" /></p>

                        <!-- Equalizer animation -->
                        <div class="equalizer mt-4 mb-4">
                            <c:forEach begin="1" end="8" var="i">
                                <div class="bar bar${i}"></div>
                            </c:forEach>
                        </div>

                        <button class="ghost-btn" id="${leftPanelContent.buttonId}">
                            <i class="fas ${leftPanelContent.buttonIcon} mr-2"></i>
                            <c:out value="${leftPanelContent.buttonText}" />
                        </button>
                    </div>

                    <!-- Right Overlay Panel (Sign In) -->
                    <div class="overlay-panel overlay-right">
                        <div class="logo-container mb-4">
                            <img src="${pageContext.request.contextPath}/image/mtp2k-logo.png" alt="MTP-2K Logo" class="logo-image">
                            <div class="logo-text">MTP-2K</div>
                        </div>

                        <%-- Sử dụng JSTL để hiển thị nội dung panel --%>
                        <c:set var="rightPanelContent" value="${{
                                                                'title': 'Hello, Friend!',
                                                                'message': 'Enter your personal details and start your journey with us',
                                                                'buttonText': 'Sign Up',
                                                                'buttonIcon': 'fa-user-plus',
                                                                'buttonId': 'signUp'
                                                                }}" />

                        <h1 class="mb-2"><c:out value="${rightPanelContent.title}" /></h1>
                        <p><c:out value="${rightPanelContent.message}" /></p>

                        <!-- Equalizer animation -->

                        <%-- 
                        - <c:forEach begin="1" end="8" var="i">: Vòng lặp qua 8 thanh để tạo các thanh của equalizer.
                        - <div class="bar bar${i}"></div>: Tạo một thanh có class bar${i} để sử dụng trong CSS.
                        Lợi ích: Dễ dàng thay đổi số lượng thanh hoặc thay đổi CSS cho chúng.
                        --%>
                        <%-- Sử dụng JSTL để tạo các thanh của equalizer --%>
                        <div class="equalizer mt-4 mb-4">
                            <c:forEach begin="1" end="8" var="i">
                                <div class="bar bar${i}"></div>
                            </c:forEach>
                        </div>

                        <button class="ghost-btn" id="${rightPanelContent.buttonId}">
                            <i class="fas ${rightPanelContent.buttonIcon} mr-2"></i>
                            <c:out value="${rightPanelContent.buttonText}" />
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <script>
            // Thêm hàm kiểm tra khoảng trắng
            function isEmptyOrWhitespace(str) {
                return str === null || str === undefined || str.trim() === '';
            }

            // Định nghĩa các hàm validation ở phạm vi toàn cục
            // Hàm kiểm tra họ tên
            function validateFullName(fullName) {
                // Kiểm tra nếu chuỗi rỗng hoặc chỉ chứa khoảng trắng
                if (isEmptyOrWhitespace(fullName))
                    return false;

                // Kiểm tra độ dài sau khi đã loại bỏ khoảng trắng thừa ở đầu và cuối
                const trimmedName = fullName.trim();
                if (trimmedName.length < 2)
                    return false;

                // Kiểm tra nếu có nhiều khoảng trắng liên tiếp
                if (/\s{2,}/.test(trimmedName))
                    return false;

                // Kiểm tra họ tên chỉ chứa chữ cái và khoảng trắng, không chứa ký tự đặc biệt hoặc số
                const regex = /^[a-zA-ZÀ-ỹ\s]{2,50}$/;
                return regex.test(trimmedName);
            }

            // Hàm kiểm tra tên đăng nhập
            function validateUsername(username) {
                if (username === '')
                    return false;
                const regex = /^[a-zA-Z0-9_]{5,20}$/;
                return regex.test(username);
            }

            // Hàm kiểm tra email
            function validateEmail(email) {
                if (email === '')
                    return false;

                // Kiểm tra định dạng email cơ bản
                const basicEmailRegex = /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                if (!basicEmailRegex.test(email)) {
                    return false;
                }

                // Danh sách các domain phổ biến được chấp nhận
                const validDomains = [
                    '.com',
                    '.edu',
                    '.org',
                    '.net',
                    '.gov',
                    '.edu.vn',
                    '.com.vn',
                    '.org.vn',
                    '.net.vn',
                    '.gov.vn'
                ];

                // Kiểm tra xem email có kết thúc bằng một trong các domain hợp lệ không
                return validDomains.some(domain => email.toLowerCase().endsWith(domain));
            }

            // Hàm kiểm tra mật khẩu
            function validatePassword(password) {
                if (password === '')
                    return false;
                // Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt
                const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
                return regex.test(password);
            }

            // Hàm kiểm tra số điện thoại
            function validatePhone(phone) {
                if (phone === '')
                    return false;

                // Kiểm tra số điện thoại Việt Nam
                // Bắt đầu bằng 0 và có 10 số (VD: 0912345678)
                // Hoặc bắt đầu bằng +84 và có 9 số phía sau (VD: +84912345678)
                const phoneRegex = /^(0\d{9}|\+84\d{9})$/;
                return phoneRegex.test(phone);
            }

            // Hàm hiển thị lỗi
            function showError(inputId, message) {
                const errorElement = document.getElementById(inputId + '-error');
                const inputElement = document.getElementById(inputId);

                if (errorElement && inputElement) {
                    errorElement.textContent = message;
                    errorElement.style.display = 'block';

                    inputElement.classList.add('input-error');
                    inputElement.classList.remove('input-success');
                }
            }

            // Hàm xóa lỗi
            function clearError(inputId) {
                const errorElement = document.getElementById(inputId + '-error');
                const inputElement = document.getElementById(inputId);

                if (errorElement && inputElement) {
                    errorElement.textContent = '';
                    errorElement.style.display = 'none';

                    inputElement.classList.remove('input-error');
                    inputElement.classList.add('input-success');
                }
            }

            // Khởi tạo các sự kiện khi trang web đã tải xong
            document.addEventListener('DOMContentLoaded', function () {
                // Auto-hide login error messages after 5 seconds
                const loginErrors = document.querySelectorAll('.sign-in-container .error-message');
                loginErrors.forEach(error => {
                    if (error.style.display !== 'none') {
                        setTimeout(() => {
                            error.style.display = 'none';
                        }, 5000);
                    }
                });

                // Lấy các phần tử DOM cần thiết cho việc chuyển đổi panel
                const signUpButton = document.getElementById('signUp');
                const signInButton = document.getElementById('signIn');
                const signUpLink = document.getElementById('signUpLink');
                const signInLink = document.getElementById('signInLink');
                const container = document.getElementById('container');

                // Thêm sự kiện click cho nút "Sign Up" trong form đăng nhập
                // Khi người dùng click vào link "Sign Up" trong form đăng nhập, chuyển sang form đăng ký
                if (signUpLink) {
                    signUpLink.addEventListener('click', () => {
                        container.classList.add('right-panel-active');
                    });
                }

                // Thêm sự kiện click cho nút "Sign In" trong form đăng ký
                // Khi người dùng click vào link "Sign In" trong form đăng ký, chuyển sang form đăng nhập
                if (signInLink) {
                    signInLink.addEventListener('click', () => {
                        container.classList.remove('right-panel-active');
                    });
                }

                // Thêm sự kiện click cho nút "Sign Up" trong overlay bên phải
                // Khi người dùng click vào nút "Sign Up" trong panel bên phải, chuyển sang form đăng ký
                signUpButton.addEventListener('click', () => {
                    container.classList.add('right-panel-active');
                });

                // Thêm sự kiện click cho nút "Sign In" trong overlay bên trái
                // Khi người dùng click vào nút "Sign In" trong panel bên trái, chuyển sang form đăng nhập
                signInButton.addEventListener('click', () => {
                    container.classList.remove('right-panel-active');
                });

                // Thêm hiệu ứng animation cho các thanh equalizer
                // Tạo hiệu ứng chuyển động cho các thanh equalizer để mô phỏng hiệu ứng âm nhạc
                const bars = document.querySelectorAll('.bar');
                bars.forEach((bar, index) => {
                    // Mỗi thanh có một độ trễ khác nhau để tạo hiệu ứng sóng
                    bar.style.animation = `barAnimation 1.5s infinite ${index * 0.1}s`;
                });

                // Thêm hiệu ứng pulse cho logo
                // Tạo hiệu ứng nhấp nháy cho logo để thu hút sự chú ý
                const logoContainers = document.querySelectorAll('.logo-container');
                logoContainers.forEach(container => {
                    container.style.animation = 'pulse 2s infinite';
                });

                // Tạo các keyframes animation động bằng JavaScript
                // Định nghĩa các animation sử dụng trong trang
                const style = document.createElement('style');
                style.textContent = `
                    /* Hiệu ứng animation cho các thanh equalizer - tạo hiệu ứng nhảy lên xuống */
                    @keyframes barAnimation {
                        0% { transform: scaleY(1); }
                        50% { transform: scaleY(0.6); }
                        100% { transform: scaleY(1); }
                    }
                    
                    /* Hiệu ứng pulse cho logo - tạo hiệu ứng phát sáng xung quanh logo */
                    @keyframes pulse {
                        0% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0.4); }
                        70% { box-shadow: 0 0 0 15px rgba(255, 255, 255, 0); }
                        100% { box-shadow: 0 0 0 0 rgba(255, 255, 255, 0); }
                    }
                    
                    /* Hiệu ứng gradient animation cho nút - tạo hiệu ứng chuyển màu gradient */
                    @keyframes gradientAnimation {
                        0% { background-position: 0% 50%; }
                        50% { background-position: 100% 50%; }
                        100% { background-position: 0% 50%; }
                    }
                    
                    /* Hiệu ứng bounce cho nội dung nút - tạo hiệu ứng nảy lên xuống */
                    @keyframes bounce {
                        0%, 100% { transform: translateY(0); }
                        50% { transform: translateY(-5px); }
                    }
                `;
                document.head.appendChild(style);

                // Thêm hiệu ứng cho nút đăng nhập
                // Tạo các hiệu ứng tương tác khi người dùng di chuột vào nút đăng nhập
                const loginButton = document.getElementById('loginButton');

                // Sự kiện khi di chuột vào nút đăng nhập
                if (loginButton) {
                    loginButton.addEventListener('mouseenter', function () {
                        // Thêm hiệu ứng gradient animation khi di chuột vào nút
                        this.style.backgroundSize = '300% 300%';
                        this.style.animation = 'gradientAnimation 3s ease infinite';

                        // Thêm hiệu ứng nảy lên cho nội dung nút
                        const btnContent = this.querySelector('.btn-content');
                        btnContent.style.animation = 'bounce 0.5s ease';

                        // Tạo và hiển thị các nốt nhạc xung quanh nút
                        createMusicNotes(this);

                        // Phát âm thanh khi di chuột vào nút
                        playSound();
                    });

                    // Sự kiện khi di chuột ra khỏi nút đăng nhập
                    loginButton.addEventListener('mouseleave', function () {
                        // Xóa các hiệu ứng animation khi di chuột ra khỏi nút
                        this.style.animation = '';
                        const btnContent = this.querySelector('.btn-content');
                        btnContent.style.animation = '';

                        // Xóa tất cả các nốt nhạc
                        document.querySelectorAll('.music-note').forEach(note => {
                            note.remove();
                        });
                    });
                }

                // Hàm tạo các nốt nhạc xung quanh nút khi hover
                // Tạo hiệu ứng các nốt nhạc bay lên từ nút đăng nhập
                function createMusicNotes(button) {
                    // Tạo 5 nốt nhạc với vị trí và chuyển động ngẫu nhiên
                    for (let i = 0; i < 5; i++) {
                        const note = document.createElement('i');
                        note.className = 'fas fa-music music-note';
                        button.appendChild(note);

                        // Đặt vị trí ngẫu nhiên cho nốt nhạc
                        const x = Math.random() * button.offsetWidth;
                        const y = button.offsetHeight / 2;

                        note.style.left = `${x}px`;
                        note.style.top = `${y}px`;

                        // Tạo hiệu ứng animation cho nốt nhạc
                        setTimeout(() => {
                            note.style.opacity = '1';
                            note.style.transform = `translate(${Math.random() * 20 - 10}px, -${30 + Math.random() * 20}px) rotate(${Math.random() * 40 - 20}deg)`;
                            note.style.transition = 'all 1s ease';

                            // Làm mờ dần và xóa nốt nhạc sau một khoảng thời gian
                            setTimeout(() => {
                                note.style.opacity = '0';
                                setTimeout(() => {
                                    note.remove();
                                }, 500);
                            }, 1000);
                        }, i * 200);
                    }
                }

                // Hàm phát âm thanh khi hover nút đăng nhập
                // Tạo âm thanh nốt nhạc A4 khi di chuột vào nút đăng nhập
                function playSound() {
                    // Sử dụng Web Audio API để tạo âm thanh
                    if (window.AudioContext || window.webkitAudioContext) {
                        try {
                            const AudioContext = window.AudioContext || window.webkitAudioContext;
                            const audioCtx = new AudioContext();
                            const oscillator = audioCtx.createOscillator();
                            const gainNode = audioCtx.createGain();

                            // Thiết lập loại sóng âm, tần số và âm lượng
                            oscillator.type = 'sine';
                            oscillator.frequency.setValueAtTime(440, audioCtx.currentTime); // A4 note
                            gainNode.gain.setValueAtTime(0.1, audioCtx.currentTime);
                            gainNode.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + 0.5);

                            // Kết nối các node âm thanh
                            oscillator.connect(gainNode);
                            gainNode.connect(audioCtx.destination);

                            // Phát và dừng âm thanh
                            oscillator.start();
                            oscillator.stop(audioCtx.currentTime + 0.5);
                        } catch (e) {
                            console.log('Web Audio API not supported or user has not interacted with the document yet');
                        }
                    }
                }

                // Lấy các phần tử input
                const fullNameInput = document.getElementById('fullName');
                const usernameInput = document.getElementById('userName');
                const emailInput = document.getElementById('email');
                const passwordInput = document.getElementById('registerPassword');
                const confirmPasswordInput = document.getElementById('confirmPassword');
                const phoneInput = document.getElementById('phone');

                // Thêm sự kiện input cho các trường
                if (fullNameInput) {
                    // Kiểm tra khi người dùng bắt đầu nhập (sự kiện input)
                    fullNameInput.addEventListener('input', validateFullName);

                    // Kiểm tra khi người dùng nhấn phím (sự kiện keyup)
                    fullNameInput.addEventListener('keyup', validateFullName);

                    // Kiểm tra khi người dùng bấm vào trường (sự kiện focus)
                    fullNameInput.addEventListener('focus', function () {
                        // Nếu đã có giá trị, kiểm tra ngay
                        if (this.value) {
                            validateFullName.call(this);
                        }
                    });

                    // Kiểm tra khi người dùng rời khỏi trường (sự kiện blur)
                    fullNameInput.addEventListener('blur', validateFullName);

                    // Hàm kiểm tra họ tên
                    function validateFullName() {
                        const value = this.value;

                        // Kiểm tra nếu trường rỗng hoặc chỉ có khoảng trắng
                        if (value === '' || value.trim() === '') {
                            showError('fullName', 'Vui lòng nhập họ tên');
                            return false;
                        }

                        // Kiểm tra độ dài
                        if (value.trim().length < 2) {
                            showError('fullName', 'Họ tên phải có ít nhất 2 ký tự');
                            return false;
                        }

                        // Kiểm tra khoảng trắng liên tiếp
                        if (/\s{2,}/.test(value)) {
                            showError('fullName', 'Họ tên không được chứa nhiều khoảng trắng liên tiếp');
                            return false;
                        }

                        // Kiểm tra ký tự đặc biệt và số
                        if (!/^[a-zA-ZÀ-ỹ\s]{2,50}$/.test(value.trim())) {
                            showError('fullName', 'Họ tên chỉ được chứa chữ cái và khoảng trắng, không chứa số hoặc ký tự đặc biệt');
                            return false;
                        }

                        // Nếu hợp lệ
                        clearError('fullName');
                        return true;
                    }
                }

                if (usernameInput) {
                    usernameInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('userName', 'Vui lòng nhập tên đăng nhập');
                        } else if (!validateUsername(value)) {
                            showError('userName', 'Tên đăng nhập phải từ 5-20 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới');
                        } else {
                            clearError('userName');
                        }
                    });
                }

                if (emailInput) {
                    emailInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('email', 'Vui lòng nhập email');
                        } else if (!validateEmail(value)) {
                            showError('email', 'Email không đúng định dạng. Ví dụ hợp lệ: user@example.com, student@university.edu.vn');
                        } else {
                            clearError('email');
                        }
                    });
                }

                if (passwordInput) {
                    passwordInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('registerPassword', 'Vui lòng nhập mật khẩu');
                        } else if (!validatePassword(value)) {
                            showError('registerPassword', 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt');
                        } else {
                            clearError('registerPassword');
                        }

                        // Kiểm tra lại xác nhận mật khẩu nếu đã nhập
                        if (confirmPasswordInput && confirmPasswordInput.value.trim() !== '') {
                            if (confirmPasswordInput.value.trim() !== value) {
                                showError('confirmPassword', 'Xác nhận mật khẩu không khớp');
                            } else {
                                clearError('confirmPassword');
                            }
                        }
                    });
                }

                if (confirmPasswordInput) {
                    confirmPasswordInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        const password = passwordInput ? passwordInput.value.trim() : '';

                        if (value === '') {
                            showError('confirmPassword', 'Vui lòng xác nhận mật khẩu');
                        } else if (value !== password) {
                            showError('confirmPassword', 'Xác nhận mật khẩu không khớp');
                        } else {
                            clearError('confirmPassword');
                        }
                    });
                }

                if (phoneInput) {
                    phoneInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('phone', 'Vui lòng nhập số điện thoại');
                        } else if (!validatePhone(value)) {
                            showError('phone', 'Số điện thoại không hợp lệ. Định dạng: 0xxxxxxxxx hoặc +84xxxxxxxxx');
                        } else {
                            clearError('phone');
                        }
                    });
                }

                // Thêm validation cho form đăng nhập
                const loginUsernameInput = document.getElementById('loginUsername');
                const loginPasswordInput = document.getElementById('password');

                if (loginUsernameInput) {
                    loginUsernameInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('loginUsername', 'Vui lòng nhập tên đăng nhập hoặc email');
                        } else {
                            clearError('loginUsername');
                        }
                    });
                }

                if (loginPasswordInput) {
                    loginPasswordInput.addEventListener('input', function () {
                        const value = this.value.trim();
                        if (value === '') {
                            showError('password', 'Vui lòng nhập mật khẩu');
                        } else {
                            clearError('password');
                        }
                    });
                }
            });

            // Xử lý khi submit form
            document.getElementById('registerForm').addEventListener('submit', function (e) {
                let isValid = true;

                // Lấy giá trị các trường
                const fullName = document.getElementById('fullName').value.trim();
                const username = document.getElementById('userName').value.trim();
                const email = document.getElementById('email').value.trim();
                const password = document.getElementById('registerPassword').value.trim();
                const confirmPassword = document.getElementById('confirmPassword').value.trim();
                const phone = document.getElementById('phone').value.trim();

                // Kiểm tra họ tên
                if (isEmptyOrWhitespace(fullName)) {
                    showError('fullName', 'Vui lòng nhập họ tên');
                    isValid = false;
                } else if (fullName.trim().length < 2) {
                    showError('fullName', 'Họ tên phải có ít nhất 2 ký tự');
                    isValid = false;
                } else if (/\s{2,}/.test(fullName)) {
                    showError('fullName', 'Họ tên không được chứa nhiều khoảng trắng liên tiếp');
                    isValid = false;
                } else if (!/^[a-zA-ZÀ-ỹ\s]{2,50}$/.test(fullName.trim())) {
                    showError('fullName', 'Họ tên chỉ được chứa chữ cái và khoảng trắng, không chứa số hoặc ký tự đặc biệt');
                    isValid = false;
                }

                // Kiểm tra tên đăng nhập
                if (!validateUsername(username)) {
                    showError('userName', 'Tên đăng nhập phải từ 5-20 ký tự, chỉ chứa chữ cái, số và dấu gạch dưới');
                    isValid = false;
                }

                // Kiểm tra email
                if (!validateEmail(email)) {
                    showError('email', 'Email không đúng định dạng. Ví dụ hợp lệ: user@example.com, student@university.edu.vn');
                    isValid = false;
                }

                // Kiểm tra mật khẩu
                if (!validatePassword(password)) {
                    showError('registerPassword', 'Mật khẩu phải có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường, số và ký tự đặc biệt');
                    isValid = false;
                }

                // Kiểm tra xác nhận mật khẩu
                if (password !== confirmPassword) {
                    showError('confirmPassword', 'Xác nhận mật khẩu không khớp');
                    isValid = false;
                }

                // Kiểm tra số điện thoại
                if (!validatePhone(phone)) {
                    showError('phone', 'Số điện thoại không hợp lệ. Định dạng: 0xxxxxxxxx hoặc +84xxxxxxxxx');
                    isValid = false;
                }

                // Nếu có lỗi, ngăn form submit
                if (!isValid) {
                    e.preventDefault();
                }
            });

            // Thêm validation cho form đăng nhập
            document.getElementById('loginForm').addEventListener('submit', function (e) {
                let isValid = true;

                // Lấy giá trị các trường
                const username = document.getElementById('loginUsername').value.trim();
                const password = document.getElementById('password').value.trim();

                // Kiểm tra username/email
                if (username === '') {
                    showError('loginUsername', 'Vui lòng nhập tên đăng nhập hoặc email');
                    isValid = false;
                }

                // Kiểm tra mật khẩu
                if (password === '') {
                    showError('password', 'Vui lòng nhập mật khẩu');
                    isValid = false;
                }

                // Nếu có lỗi, ngăn form submit
                if (!isValid) {
                    e.preventDefault();
                }
            });

            // Hàm hiển thị/ẩn mật khẩu trong form đăng nhập
            // Chuyển đổi giữa hiển thị và ẩn mật khẩu khi người dùng click vào icon con mắt
            function togglePasswordVisibility() {
                // Lấy phần tử input mật khẩu và icon
                const passwordInput = document.getElementById('password');
                const toggleIcon = document.querySelector('.toggle-password');

                // Kiểm tra trạng thái hiện tại của input mật khẩu
                if (passwordInput.type === 'password') {
                    // Nếu đang ẩn, chuyển sang hiển thị và đổi icon
                    passwordInput.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    // Nếu đang hiển thị, chuyển sang ẩn và đổi icon
                    passwordInput.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }

            // Hàm hiển thị/ẩn mật khẩu trong form đăng ký
            // Tương tự như hàm togglePasswordVisibility nhưng áp dụng cho trường mật khẩu trong form đăng ký
            function toggleRegisterPasswordVisibility(inputId) {
                // Lấy phần tử input mật khẩu và icon tương ứng
                const passwordInput = document.getElementById(inputId);
                const toggleIcon = passwordInput.nextElementSibling;

                // Kiểm tra trạng thái hiện tại của input mật khẩu
                if (passwordInput.type === 'password') {
                    // Nếu đang ẩn, chuyển sang hiển thị và đổi icon
                    passwordInput.type = 'text';
                    toggleIcon.classList.remove('fa-eye');
                    toggleIcon.classList.add('fa-eye-slash');
                } else {
                    // Nếu đang hiển thị, chuyển sang ẩn và đổi icon
                    passwordInput.type = 'password';
                    toggleIcon.classList.remove('fa-eye-slash');
                    toggleIcon.classList.add('fa-eye');
                }
            }

            // Validate form khi submit
            registerForm.addEventListener('submit', function (e) {
                let isValid = true;

                // Kiểm tra từng trường input
                registerFields.forEach(field => {
                    const input = document.getElementById(field.id);
                    if (input) {
                        validateField(input);
                        if (input.classList.contains('invalid')) {
                            isValid = false;
                        }
                    }
                });

                // Nếu có lỗi, ngăn form submit
                if (!isValid) {
                    e.preventDefault();
                }
            });



            // Thêm sự kiện khi chuyển đổi form
            document.querySelector('.sign-up-button').addEventListener('click', function () {
                // Xóa lỗi đăng nhập khi chuyển sang form đăng ký
                const loginError = document.querySelector('.sign-in-container .error-message');
                if (loginError) {
                    loginError.style.display = 'none';
                    loginError.textContent = '';
                }
            });

            // Hiển thị và tự động ẩn thông báo lỗi
            document.addEventListener('DOMContentLoaded', function () {
                const loginError = document.getElementById('loginError');
                if (loginError && '${requestScope.error}' !== '') {
                    // Hiển thị thông báo
                    loginError.style.display = 'block';

                    // Tự động ẩn sau 5 giây
                    setTimeout(function () {
                        loginError.style.transition = 'opacity 0.5s ease';
                        loginError.style.opacity = '0';
                        setTimeout(() => {
                            loginError.style.display = 'none';
                        }, 500);
                    }, 5000);
                }
            });

            // Sửa lại phần xử lý hiển thị thông báo lỗi
            document.addEventListener('DOMContentLoaded', function () {
                const errorMessages = document.querySelectorAll('.error-message');
                errorMessages.forEach(error => {
                    if (error.textContent.trim() !== '') {
                        // Tự động ẩn sau 5 giây
                        setTimeout(() => {
                            error.style.opacity = '0';
                            setTimeout(() => {
                                error.style.display = 'none';
                            }, 300);
                        }, 5000);
                    } else {
                        error.style.display = 'none';
                    }
                });
            });

            // Xử lý hiển thị thông báo lỗi đăng nhập
            document.addEventListener('DOMContentLoaded', function () {
                const loginError = document.getElementById('loginError');

                if (loginError && '${not empty requestScope.error}' === 'true') {
                    // Hiển thị thông báo lỗi với độ trễ nhỏ
                    setTimeout(() => {
                        loginError.classList.add('show');

                        // Tự động ẩn sau 5 giây
                        setTimeout(() => {
                            loginError.style.opacity = '0';
                            setTimeout(() => {
                                loginError.classList.remove('show');
                            }, 300);
                        }, 5000);
                    }, 100);
                }
            });
        </script>
    </body>
</html>
