document.addEventListener('DOMContentLoaded', function() {
    const users = [
        { name: 'Иван Иванов', role: 'Студент' },
        { name: 'Петр Петров', role: 'Преподаватель' },
        { name: 'Сидор Сидоров', role: 'Декан' },
        { name: 'аутист аутистов', role: 'Декан' }
    ];

    const tableBody = document.querySelector('#usersTable tbody');

    users.forEach(user => {
        const row = document.createElement('tr');

        const nameCell = document.createElement('td');
        nameCell.textContent = user.name;
        row.appendChild(nameCell);

        const roleCell = document.createElement('td');
        roleCell.textContent = user.role;
        row.appendChild(roleCell);

        const actionsCell = document.createElement('td');
        const makeTeacherButton = document.createElement('button');
        makeTeacherButton.textContent = 'Сделать учителем';
        makeTeacherButton.addEventListener('click', () => {
            roleCell.textContent = 'Преподаватель';
        });

        const makeDeanButton = document.createElement('button');
        makeDeanButton.textContent = 'Сделать деканом';
        makeDeanButton.addEventListener('click', () => {
            roleCell.textContent = 'Декан';
        });

        actionsCell.appendChild(makeTeacherButton);
        actionsCell.appendChild(makeDeanButton);
        row.appendChild(actionsCell);

        tableBody.appendChild(row);
    });
});