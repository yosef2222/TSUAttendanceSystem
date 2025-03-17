const urlPageTitle = "Система учета пропусков";

const urlRoutes = {
    404: { template: "/pages/404.html", title: "404 | " + urlPageTitle, script: null },
    "/": { template: "/pages/main.html", title: "Главная | " + urlPageTitle, script: null },
    "/login": { template: "/pages/login.html", title: "Вход | " + urlPageTitle, script: "js/login.js" },
    "/registration": { template: "/pages/registration.html", title: "Регистрация | " + urlPageTitle, script: "js/registration.js" },
};

const route = (event) => {
    event = event || window.event;
    event.preventDefault();
    window.history.pushState({}, "", event.target.href);
    locationHandler();
};

//работа с токеном
const checkTokenValidity = async () => {
    const token = localStorage.getItem('token');
    if (!token) return false;

    try {
        console.log("Проверка токена на сервере...");
        const response = await fetch('http://localhost:5163/api/Auth/profile', {
            method: 'GET',
            headers: { 'Authorization': `Bearer ${token}` }
        });

        if (!response.ok) {
            console.warn("Сервер отклонил токен. Удаляем его...");
            localStorage.removeItem('token');
            return false;
        }

        return true;
    } catch (error) {
        console.error("Ошибка при проверке токена:", error);
        localStorage.removeItem('token');
        return false;
    }
};

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


//загрузка скриптов
const loadScript = (scriptPath) => {
    return new Promise((resolve, reject) => {
        document.querySelectorAll("script[data-dynamic]").forEach(script => script.remove());

        if (scriptPath) {
            const script = document.createElement("script");
            script.src = scriptPath;
            script.setAttribute("data-dynamic", "true");

            script.onload = () => {
                console.log(`Скрипт ${scriptPath} загружен`);
                resolve();
            };
            script.onerror = () => {
                console.error(`Ошибка загрузки ${scriptPath}`);
                reject(new Error(`Ошибка загрузки ${scriptPath}`));
            };
            document.body.appendChild(script);
        }
    });
};

//обновление хедера
const updateHeader = async () => {
    const header = document.getElementById('header');
    const currentPath = window.location.pathname;
    const token = localStorage.getItem('token');
    const user = token ? parseJwt(token) : null;
    const absencesMatch = currentPath.match(/^\/absences\/(.+)$/);
    const studentMatch = currentPath.match(/^\/student\/(.+)$/);
    const adminMatch = currentPath.match(/^\/admin\/(.+)$/);
    const passesMatch = currentPath.match(/^\/passes\/(.+)$/);
    const isAuthtorized = await checkTokenValidity();
    
    if (!isAuthtorized) {
        localStorage.removeItem('token');
    }

    if (isAuthtorized && user !== null) {
        const userRole = user["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
        if(userRole === "Student"){
            if(absencesMatch){
                header.innerHTML = `
                <a href="/">Система учета пропусков</a>
                <nav>
                    <a href="/student/${encodeURIComponent(user.email)}">Личный кабинет</a>
                    <a href="/" id="logout">Выход</a>
                </nav>
                `;
            } else if(studentMatch){
                header.innerHTML = `
                <a href="/">Система учета пропусков</a>
                <nav>
                    <a href="/absences/${encodeURIComponent(user.email)}">Мои пропуски</a>
                    <a href="/" id="logout">Выход</a>
                </nav>
                `;
            } else {
                header.innerHTML = `
                <a href="/">Система учета пропусков</a>
                <nav>
                    <a href="/student/${encodeURIComponent(user.email)}">Личный кабинет</a>
                    <a href="/absences/${encodeURIComponent(user.email)}">Мои пропуски</a>
                    <a href="/" id="logout">Выход</a>
                </nav>
                `;
            };
            document.getElementById('logout').addEventListener('click', () => {
                localStorage.removeItem('token');
                window.location.href = "/";
            });
        } else if(userRole === "Admin"){
            if(passesMatch){
                header.innerHTML = `
                <a href="/">Система учета пропусков</a>
                <nav>
                    <a href="/admin/${encodeURIComponent(user.email)}">Пользователи</a>
                    <a href="/" id="logout">Выход</a>
                </nav>
                `;
            } else if(adminMatch){
                header.innerHTML = `
                <a href="/">Система учета пропусков</a>
                <nav>
                    <a href="/passes/${encodeURIComponent(user.email)}">Пропуски</a>
                    <a href="/" id="logout">Выход</a>
                </nav>
                `;
            } else {
                header.innerHTML = `
                <a href="/">Система учета пропусков</a>
                <nav>
                    <a href="/admin/${encodeURIComponent(user.email)}">Пользователи</a>
                    <a href="/passes/${encodeURIComponent(user.email)}">Пропуски</a>
                    <a href="/" id="logout">Выход</a>
                </nav>
                `;
            }
            ;
            document.getElementById('logout').addEventListener('click', () => {
                localStorage.removeItem('token');
                window.location.href = "/";
            });
        }
    } else {
        let navLinks = '';
        if (currentPath === "/login") {
            navLinks = '<a href="/registration">Регистрация</a>';
        } else if (currentPath === "/registration") {
            navLinks = '<a href="/login">Вход</a>';
        } else {
            navLinks = `
                <a href="/registration">Регистрация</a>
                <a href="/login">Вход</a>
            `;
        }
        header.innerHTML = `
            <a href="/">Система учета пропусков</a>
            <nav>${navLinks}</nav>
        `;
    }
};

//функция подгрузки страницы
const locationHandler = async () => {
    
    let location = window.location.pathname;
    if (location.length === 0) location = "/";

    const token = localStorage.getItem('token');
    const user = token ? parseJwt(token) : null;
    const isAuthtorized = await checkTokenValidity();

    if (!isAuthtorized && location !== "/login" && location !== "/registration" && location !== "/") {
        console.warn("Не авторизован. Перенаправление на /login...");
        localStorage.removeItem('token');
        window.location.href = "/login";
        return;
    }
    if (isAuthtorized && user !== null) {
        const userRole = user["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
        if(userRole === "Student"){
            const studentMatch = location.match(/^\/student\/(.+)$/);
            if (studentMatch) {
                const studentEmail = decodeURIComponent(studentMatch[1]);
                console.log("Email студента из URL:", studentEmail);
                const html = await fetch("/pages/student.html").then(res => res.text());
                document.getElementById("content").innerHTML = html;
                document.title = "Студент | " + urlPageTitle;
                try {
                    await loadScript("js/student.js");
                    console.log("Скрипт загружен.");
                } catch (error) {
                    console.error("Ошибка при загрузке скрипта", error);
                }
                await updateHeader();
                return;
            }
        
            const absencesMatch = location.match(/^\/absences\/(.+)$/);
            if (absencesMatch) {
                const html = await fetch("/pages/absences.html").then(res => res.text());
                document.getElementById("content").innerHTML = html;
                document.title = "Мои пропуски | " + urlPageTitle;

                try {
                    await loadScript("js/absences.js");
                    console.log("Скрипт загружен.");
                } catch (error) {
                    console.error("Ошибка загрузки скрипта", error);
                }

                await updateHeader();
                return;
            }
        }
        if(userRole === "Admin"){
            const adminMatch = location.match(/^\/admin\/(.+)$/);
            if (adminMatch) {
                const html = await fetch("/pages/admin.html").then(res => res.text());
                document.getElementById("content").innerHTML = html;
                document.title = "Пользователи | " + urlPageTitle;
                try {
                    await loadScript("js/admin.js");
                } catch (error) {
                    console.error("Ошибка при загрузке скрипта", error);
                }
                await updateHeader();
                return;
            }
            const passesMatch = location.match(/^\/passes\/(.+)$/);
            if (passesMatch) {
                const html = await fetch("/pages/passes.html").then(res => res.text());
                document.getElementById("content").innerHTML = html;
                document.title = "Пропуски студентов | " + urlPageTitle;
                try {
                    await loadScript("js/passes.js");
                } catch (error) {
                    console.error("Ошибка при загрузке скрипта", error);
                }
                await updateHeader();
                return;
            }
        }
    }
    
    const route = urlRoutes[location] || urlRoutes[404];
    const html = await fetch(route.template).then(response => response.text());
    document.getElementById("content").innerHTML = html;
    document.title = route.title;
    await updateHeader();
    loadScript(route.script);
};

window.onpopstate = locationHandler;
window.route = route;

locationHandler();
