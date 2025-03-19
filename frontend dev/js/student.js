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

function displayStudentInfo(userData) {
    const studentNameElement = document.getElementById("studentName");

    if (studentNameElement) {
        studentNameElement.textContent = userData.fullName;
        console.log("Информация о студенте обновлена!");
    } else {
        console.error("Ошибка: Элемент с id 'studentName' не найден в DOM");
    }
}