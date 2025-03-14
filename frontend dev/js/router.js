const urlPageTitle = "Система учета пропусков";

const urlRoutes = {
    404: { template: "/pages/404.html", title: "404 | " + urlPageTitle, script: null },
    "/": { template: "/pages/main.html", title: "Главная | " + urlPageTitle, script: null },
    "/login": { template: "/pages/login.html", title: "Вход | " + urlPageTitle, script: "js/login.js" },
    "/registration": { template: "/pages/registration.html", title: "Регистрация | " + urlPageTitle, script: "js/registration.js" }
};

const route = (event) => {
    event = event || window.event;
    event.preventDefault();
    window.history.pushState({}, "", event.target.href);
    locationHandler();
};

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

function parseJwt(token) {
    try {
        if (!token) return null;

        const base64Url = token.split('.')[1];
        if (!base64Url) throw new Error("Некорректный формат токена");
        const base64 = base64Url.replace(/-/g, '+').replace(/_/g, '/');
        const jsonPayload = decodeURIComponent(atob(base64).split('').map(c =>
            '%' + ('00' + c.charCodeAt(0).toString(16)).slice(-2)
        ).join(''));

        return JSON.parse(jsonPayload);
    } catch (e) {
        console.error("Ошибка декодирования JWT:", e);
        return null;
    }
}

const isAuthenticated = () => {
    const token = localStorage.getItem('token');
    return token && parseJwt(token);
};

const updateHeader = () => {
    const header = document.getElementById('header');
    const currentPath = window.location.pathname;
    const token = localStorage.getItem('token');
    const user = token ? parseJwt(token) : null;

    if (token && !user) {
        localStorage.removeItem('token');
    }

    if (user) {
        header.innerHTML = `
            <a href="/">Система учета пропусков</a>
            <nav>
                <a href="/student/${encodeURIComponent(user.email)}">Личный кабинет</a>
                <a href="/" id="logout">Выход</a>
            </nav>
        `;
        document.getElementById('logout').addEventListener('click', () => {
            localStorage.removeItem('token');
            window.location.href = "/";
        });
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

const locationHandler = async () => {
    let location = window.location.pathname;
    if (location.length === 0) location = "/";

    const token = localStorage.getItem('token');
    const user = token ? parseJwt(token) : null;

    if (token && !user) {
        localStorage.removeItem('token');
    }

    if (isAuthenticated() && (location === "/login" || location === "/registration")) {
        window.location.href = "/";
        return;
    }
    
    const studentMatch = location.match(/^\/student\/(.+)$/);
    if (studentMatch) {
        const studentEmail = decodeURIComponent(studentMatch[1]);
        console.log("📧 Email студента из URL:", studentEmail);

        const html = await fetch("/pages/student.html").then(res => res.text());
        document.getElementById("content").innerHTML = html;
        document.title = "Студент | " + urlPageTitle;
        try {
            await loadScript("js/student.js");
            console.log("Скрипт student.js выполнен после загрузки.");
        } catch (error) {
            console.error("Ошибка при загрузке скрипта student.js:", error);
        }
        updateHeader();
        return;
    }
    const route = urlRoutes[location] || urlRoutes[404];
    const html = await fetch(route.template).then(response => response.text());
    document.getElementById("content").innerHTML = html;
    document.title = route.title;
    updateHeader();
    loadScript(route.script);
};

window.onpopstate = locationHandler;
window.route = route;

locationHandler();
