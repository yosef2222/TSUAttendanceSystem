console.log("скрипт выполняется");

(async () => {
    console.log("скрипт выполняется2");
    const token = localStorage.getItem('token');
    
    if (!token) {
        alert('Необходимо авторизоваться.');
        window.location.href = '/login';
        return;
    }

    try {
        console.log("Отправка запроса на сервер...");
        const response = await fetch('http://localhost:5163/api/Auth/profile', {
            method: 'GET',
            headers: {
                'Authorization': `Bearer ${token}` 
            }
        });

        if (!response.ok) {
            throw new Error('Не удалось получить данные о пользователе.');
        }

        const userData = await response.json();
        console.log("Полученные данные о пользователе:", userData);

        if (!userData) {
            throw new Error('Данные о пользователе не найдены.');
        }

        displayStudentInfo(userData);

    } catch (error) {
        console.error('Ошибка:', error);
        alert('Произошла ошибка при загрузке данных.');
    }
})();

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

async function displayStudentInfo(userData) {
    const userRoles = await fetchRoles(); 
    const NameElement = document.getElementById("name");
    const studentGroupElement = document.getElementById("studentGroup");
    const groupContainer = document.getElementById("groupContainer"); 
    const roleNameElement = document.getElementById("roleName");
    if (NameElement) {
        NameElement.textContent = userData.fullName;

        if ((userRoles.isStudent && userRoles.isTeacher)) {
            studentGroupElement.textContent = userData.groupNumber;
            roleNameElement.textContent = "Учитель-студент";
            groupContainer.style.display = "block"; 
        } else if (userRoles.isStudent){
            studentGroupElement.textContent = userData.groupNumber;
            roleNameElement.textContent = "Cтудент";
            groupContainer.style.display = "block";
        } else if(userRoles.isTeacher && userRoles.isDean){
            roleNameElement.textContent = "Учитель-деканат";
            groupContainer.style.display = "none";
        } else if(userRoles.isTeacher){
            roleNameElement.textContent = "Учитель";
            groupContainer.style.display = "none";
        }
         else {
            groupContainer.style.display = "none"; 
        }

        console.log("Информация о студенте обновлена!");
    } else {
        console.error("Ошибка: Элемент с id 'name' не найден в DOM");
    }
}
