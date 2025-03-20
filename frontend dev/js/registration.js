if (document.getElementById('registerForm')) {
    document.getElementById('registerForm').addEventListener('submit', async function (e) {
        e.preventDefault();

        const fullName = document.getElementById('fullName').value;
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        const birthday = new Date().toISOString();
        const groupNumber = document.getElementById('group').value;
        const role = document.getElementById('role').value;
        let isStudent = false;
        if(role === "student"){
            isStudent = true;
        }

        const newUser = {
            fullName,
            email,
            password,
            birthday,
            groupNumber,
            isStudent
        };

        try {
            const response = await fetch("http://localhost:5163/api/Auth/register", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"
                },
                body: JSON.stringify(newUser),
                mode: "cors"
            });

            if (response.ok) {
                alert("Регистрация прошла успешно!");
                window.location.href = "/login";
            } else {
                const errorData = await response.json();
                alert(errorData.message || "Ошибка при регистрации!");
            }
        } catch (error) {
            console.error("Ошибка запроса:", error);
            alert("Ошибка соединения с сервером!");
        }
    });
}
document.getElementById("role").addEventListener("change", function() {
    const groupContainer = document.getElementById("groupContainer");
    if (this.value === "student") {
        groupContainer.style.display = "block";
    } else {
        groupContainer.style.display = "none";
        document.getElementById("group").value = "other";
    }
});