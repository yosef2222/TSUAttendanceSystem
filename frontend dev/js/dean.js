const tableBody = document.querySelector('#usersTable tbody');
const jwtToken = localStorage.getItem('token'); 
let users = [];
function fetchUsers(fullName = "") {
    let url = 'http://localhost:5163/User/users';
    if (fullName.trim() !== "") {
        url += `?fullName=${encodeURIComponent(fullName)}`;
    }

    fetch(url, {
        method: 'GET',
        headers: {
            'Accept': 'application/json',
            'Authorization': `Bearer ${jwtToken}`
        }
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Ошибка сети: ' + response.statusText);
        }
        return response.json();
    })
    .then(data => {
        users = data;
        displayUsers(users);
    })
    .catch(error => {
        console.error('Ошибка при загрузке пользователей:', error);
    });
}

function displayUsers(users) {
    tableBody.innerHTML = '';
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
            updateUserRole(user.id, { isTeacher: true, isDean: false });
        });
        actionsCell.appendChild(makeTeacherButton);
        row.appendChild(actionsCell);

        tableBody.appendChild(row);
    });
}

function getRoleName(role) {
    if (role.isAdmin) return 'Администратор';
    else if (role.isTeacher && role.isStudent) return 'Преподаватель-Студент'
    else if (role.isStudent) return 'Студент';
    else if (role.isDean && role.isTeacher) return 'Деканат-преподаватель';
    else if (role.isDean) return 'Деканат';
    else if (role.isTeacher) return 'Преподаватель';
    else return 'Неизвестно';
}

function updateUserRole(userId, newRole) {
    let endpoint = '';
    if (newRole.isTeacher) {
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
        console.log('Роль успешно обновлена:', data);
        fetchUsers();
    })
    .catch(error => {
        console.error('Ошибка при обновлении роли:', error);
    });
}

document.getElementById("searchButton").addEventListener("click", function () {
    const searchValue = document.getElementById("searchInput").value;
    fetchUsers(searchValue); 
});

fetchUsers(); 
