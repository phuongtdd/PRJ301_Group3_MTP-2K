package service;

import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;

public class EmailService {

    // Giữ nguyên thông tin email và mật khẩu của bạn
    private static final String FROM_EMAIL = "mtp2kwithluv@gmail.com"; 
    private static final String PASSWORD = "fely cctu czrd nyjv"; 
    
    // Đặt thành true để sử dụng chế độ test, false để gửi email thực sự
    private static final boolean TEST_MODE = false;

    public static boolean sendVerificationCode(String toEmail, String code) {
        try {
            if (TEST_MODE) {
                // Chế độ test - chỉ in thông tin ra console
                System.out.println("========== TEST MODE ==========");
                System.out.println("Would send verification code to: " + toEmail);
                System.out.println("Verification code: " + code);
                System.out.println("===============================");
                return true;
            } else {
                // Cấu hình để gửi email thực sự
                Properties props = new Properties();
                props.put("mail.smtp.auth", "true");
                props.put("mail.smtp.starttls.enable", "true");
                props.put("mail.smtp.host", "smtp.gmail.com");
                props.put("mail.smtp.port", "587");
                
                // Thêm các thuộc tính để giảm khả năng bị đánh dấu là spam
                props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
                // props.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
                // props.put("mail.smtp.socketFactory.port", "587");
                
                Session session = Session.getInstance(props, new Authenticator() {
                    @Override
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(FROM_EMAIL, PASSWORD);
                    }
                });
                
                Message message = new MimeMessage(session);
                
                // Thêm tên người gửi để tăng độ tin cậy
message.setFrom(new InternetAddress("noreply@mtp2k.com", "MTP-2K Support"));
                message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
                message.setSubject("[MTP-2K] Your Secure Access Code");

                
                // Thêm Reply-To header để tăng độ tin cậy
message.setReplyTo(InternetAddress.parse("support@mtp2k.com"));
                
                // Thêm các header để giảm khả năng bị đánh dấu là spam
                message.addHeader("X-Priority", "1");
                message.addHeader("X-MSMail-Priority", "High");
                message.addHeader("Importance", "High");
                message.addHeader("X-Mailer", "Java Mail API"); // Email client identifier
message.addHeader("X-Source", "mtp2k.com"); // Source domain
                
                String emailContent = "<!DOCTYPE html>"
                        + "<html>"
                        + "<head>"
                        + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\">"
                        + "<style>"
                        + "body { font-family: Arial, sans-serif; line-height: 1.6; }"
                        + ".container { max-width: 600px; margin: 0 auto; padding: 20px; }"
                        + ".header { background-color: #6c5ce7; color: white; padding: 10px; text-align: center; }"
                        + ".content { padding: 20px; border: 1px solid #ddd; }"
                        + ".code { font-size: 24px; font-weight: bold; text-align: center; margin: 20px 0; letter-spacing: 5px; }"
                        + ".footer { text-align: center; margin-top: 20px; font-size: 12px; color: #666; }"
                        + "</style>"
                        + "</head>"
                        + "<body>"
                        + "<div class='container'>"
                        + "<div class='header'><h2>MTP-2K Password Reset</h2></div>"
                        + "<div class='content'>"
                        + "<p>Hello,</p>"
                        + "<p>We received a request to reset your password. Please use the following verification code to complete the process:</p>"
                        + "<div class='code'>" + code + "</div>"
                        + "<p>This code will expire in 15 minutes. If you did not request a password reset, please ignore this email.</p>"
                        + "<p>Thank you,<br>MTP-2K Team</p>"
                        + "</div>"
                        + "<div class='footer'>"
                        + "<p>This is an automated email. Please do not reply.</p>"
                        + "<p> " + java.time.Year.now().getValue() + " MTP-2K. All rights reserved.</p>"
                        + "</div>"
                        + "</div>"
                        + "</body>"
                        + "</html>";
                
                message.setContent(emailContent, "text/html; charset=utf-8");
                Transport.send(message);
                
                return true;
            }
        } catch (Exception e) {
            System.out.println("Error sending email: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
