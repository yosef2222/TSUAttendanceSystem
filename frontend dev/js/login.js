async function fetchRoles() {
    try {
        const token = localStorage.getItem("token");
        if (!token) {
            console.error("Токен авторизации отсутствует");
            return null;
        }

        const response = await fetch("http://localhost:5163/User/roles", {
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}`
            }
        });

        if (!response.ok) {
            throw new Error(`Ошибка: ${response.statusText}`);
        }

        return await response.json();
    } catch (error) {
        console.error("Ошибка при получении ролей", error);
        return null;
    }
}

if (document.getElementById('loginForm')) {
    document.getElementById('loginForm').addEventListener('submit', async function (e) {
        e.preventDefault();

        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;

        try {
            const response = await fetch('http://localhost:5163/api/Auth/login', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ email, password })
            });

            if (!response.ok) {
                throw new Error('Ошибка входа! Неверный email или пароль.');
            }

            const data = await response.json();
            if (!data.token) {
                throw new Error('Ошибка авторизации! Сервер не вернул токен.');
            }

            localStorage.setItem('token', data.token);

            alert('Вход выполнен успешно!');

            const roles = await fetchRoles();
            if (!roles) {
                throw new Error("Не удалось получить роли пользователя.");
            }

            if (roles.isAdmin) {
                window.history.pushState({}, "", `/users/${encodeURIComponent(email)}`);
            } else if (roles.isStudent && roles.isTeacher) {
                window.history.pushState({}, "", `/teacher-student/${encodeURIComponent(email)}`);
            } else if (roles.isStudent) {
                window.history.pushState({}, "", `/student/${encodeURIComponent(email)}`);
            } else if (roles.isTeacher && roles.isDean) {
                window.history.pushState({}, "", `/dean-teacher/${encodeURIComponent(email)}`);
            } else if (roles.isDean) {
                window.history.pushState({}, "", `/users/${encodeURIComponent(email)}`);
            } else if (roles.isTeacher) {
                window.history.pushState({}, "", `/teacher/${encodeURIComponent(email)}`);
            }else {
                window.history.pushState({}, "", `/user/${encodeURIComponent(email)}`)
            }

            locationHandler();

        } catch (error) {
            alert(error.message);
        }
    });
}
