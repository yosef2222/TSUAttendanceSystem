const tableBody = document.querySelector('#usersTable tbody');
const jwtToken = localStorage.getItem('token'); 
let users = [];
function fetchUsers() {
    fetch('http://localhost:5163/User/users', {
        method: 'GET',
        headers: {
            'Accept': 'application/json',
            'Authorization': `Bearer ${jwtToken}`
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok ' + response.statusText);
        }
        return response.json();
    })
    .then(data => {
        users = data;
        displayUsers(users);
    })
    .catch(error => {
        console.error('There has been a problem with your fetch operation:', error);
    });
}

// Функция для отображения пользователей в таблице
function displayUsers(users) {
    tableBody.innerHTML = ''; // Очистка таблицы перед добавлением новых данных
    users.forEach(user => {
        const row = document.createElement('tr');

        const nameCell = document.createElement('td');
        nameCell.textContent = user.fullName;
        row.appendChild(nameCell);

        const emailCell = document.createElement('td');
        emailCell.textContent = user.email;
        row.appendChild(emailCell);

        const roleCell = document.createElement('td');
        roleCell.textContent = getRoleName(user.role);
        row.appendChild(roleCell);

        const actionsCell = document.createElement('td');
        const makeTeacherButton = document.createElement('button');
        makeTeacherButton.textContent = 'Сделать учителем';
        makeTeacherButton.addEventListener('click', () => {
            updateUserRole(user.id, { isTeacher: true, isDean: false }, roleCell);
        });

        const makeDeanButton = document.createElement('button');
        makeDeanButton.textContent = 'Сделать деканом';
        makeDeanButton.addEventListener('click', () => {
            updateUserRole(user.id, { isTeacher: false, isDean: true }, roleCell);
        });

        actionsCell.appendChild(makeTeacherButton);
        actionsCell.appendChild(makeDeanButton);
        row.appendChild(actionsCell);

        tableBody.appendChild(row);
    });
}

// Функция для получения названия роли
function getRoleName(role) {
    if (role.isAdmin) return 'Администратор';
    if (role.isDean) return 'Декан';
    if (role.isTeacher) return 'Преподаватель';
    if (role.isStudent) return 'Студент';
    return 'Неизвестно';
}

// Функция для обновления роли пользователя
function updateUserRole(userId, newRole, roleCell) {
    let endpoint = '';
    if (newRole.isDean) {
        endpoint = `http://localhost:5163/api/Roles/grant-dean/${userId}`;
    } else if (newRole.isTeacher) {
        endpoint = `http://localhost:5163/api/Roles/grant-teacher/${userId}`;
    } else {
        console.error('Некорректная роль');
        return;
    }

    fetch(endpoint, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${jwtToken}`
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Ошибка: ' + response.statusText);
        }
        return response.json();
    })
    .then(data => {
        // Обновляем роль в таблице
        roleCell.textContent = getRoleName(newRole);
        console.log('Роль успешно обновлена:', data);
    })
    .catch(error => {
        console.error('Ошибка при обновлении роли:', error);
    });
}

fetchUsers(); // Вызов функции для получения и отображения пользователей при загрузке страницы
