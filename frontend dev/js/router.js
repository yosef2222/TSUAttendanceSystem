const urlPageTitle = "Система учета пропусков";

document.addEventListener("click", (e) => {
    const {target} = e;
    if (!target.matches("header")) {
        return;
    }
    e.preventDefault();
    route();
})

const urlRoutes = {
    404: {
        template: "/pages/404.html",
        title: "404 | " + urlPageTitle,
    },
    "/": {
        template: "/pages/main.html",
        title: "Главная | " + urlPageTitle,
    },
    "/login": {
        template: "/pages/login.html",
        title: "Вход | " + urlPageTitle,
    },
    "/registration": {
        template: "/pages/registration.html",
        title: "Регистрация | " + urlPageTitle,
    }
}

const route = (event) => {
    event = event || window.event;
    event.preventDefault();
    window.history.pushState({}, "", event.target.href);
}

const locationHandler = async () => {
    const location = window.location.pathname;
    if(location.length == 0) {
        location = "/"
    }
    
    const route = urlRoutes[location] || urlRoutes[404];
    const html = await fetch(route.template).then((response) => response.text()); 
    document.getElementById("content").innerHTML = html;
    document.title = route.title;
}

window.onpopstate = locationHandler;
window.route = route;

locationHandler();

