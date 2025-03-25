// Path: c:\Edu\Semester4\PRJ301\MTP-2K\PRJ301_Group3_MTP-2K\src\java\service\VerificationService.java
package service;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;
import java.time.LocalDateTime;

public class VerificationService {

    private static final Map<String, VerificationCode> verificationCodes = new HashMap<>();
    private static final int CODE_EXPIRY_MINUTES = 15;

    public static class VerificationCode {

        private String code;
        private LocalDateTime expiryTime;
        private int userID;

        public VerificationCode(String code, int userID) {
            this.code = code;
            this.userID = userID;
            this.expiryTime = LocalDateTime.now().plusMinutes(CODE_EXPIRY_MINUTES);
        }

        public String getCode() {
            return code;
        }

        public int getUserID() {
            return userID;
        }

        public boolean isExpired() {
            return LocalDateTime.now().isAfter(expiryTime);
        }
    }

    public static String generateCode(String email, int userID) {
        // Generate a 6-digit code
        Random random = new Random();
        String code = String.format("%06d", random.nextInt(1000000));

        // Store the code with the email
        verificationCodes.put(email, new VerificationCode(code, userID));

        return code;
    }

    public static VerificationCode getVerificationCode(String email) {
        return verificationCodes.get(email);
    }

    public static boolean verifyCode(String email, String code) {
        VerificationCode storedCode = verificationCodes.get(email);

        if (storedCode == null) {
            return false;
        }

        if (storedCode.isExpired()) {
            verificationCodes.remove(email);
            return false;
        }

        if (storedCode.getCode().equals(code)) {
            return true;
        }

        return false;
    }

    public static void removeCode(String email) {
        verificationCodes.remove(email);
    }
}
