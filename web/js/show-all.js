// JavaScript for all-artists.jsp and all-albums.jsp
window.onload = function () {
    const message = sessionStorage.getItem("message");
    if (message && message.trim() !== "") {
        showToast(message);
        sessionStorage.removeItem("message");
    }
};

function showToast(message) {
    const toast = document.getElementById("toast");
    toast.textContent = message;
    toast.className = "toast show";
    setTimeout(() => {
        toast.className = toast.className.replace("show", "");
    }, 3000);
}
