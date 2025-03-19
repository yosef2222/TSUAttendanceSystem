function parseJwt(token) {
    try {
        if (!token) return null;

        const base64Url = token.split('.')[1];
        if (!base64Url) throw new Error("Некорректный формат токена");

        const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        const jsonPayload = decodeURIComponent(atob(base64).split('').map(c =>
            '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
        ).join(''));

        const payload = JSON.parse(jsonPayload);
        return payload;
    } catch (e) {
        console.error("Ошибка декодирования JWT:", e);
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

            const user = parseJwt(data.token);
            if (!user) throw new Error("Ошибка при разборе токена.");

            alert('Вход выполнен успешно!');
            const userRole = user["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
            if (userRole === "Student") {
                const studentUrl = `/student/${encodeURIComponent(user.email)}`;
                window.history.pushState({}, "", studentUrl);
                locationHandler();
            } else if (userRole === "Admin"){
                const adminUrl = `/admin/${encodeURIComponent(user.email)}`;
                window.history.pushState({}, "", adminUrl);
                locationHandler();
            } else if (userRole === "Dean"){
                const adminUrl = `/dean/${encodeURIComponent(user.email)}`;
                window.history.pushState({}, "", adminUrl);
                locationHandler();
            } else{
                const adminUrl = `/teacher/${encodeURIComponent(user.email)}`;
                window.history.pushState({}, "", adminUrl);
                locationHandler();
            } 
        } catch (error) {
            alert(error.message);
        }
    });
}