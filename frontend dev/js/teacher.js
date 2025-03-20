const passes = [
    {
        fullName: 'Маслаков Маслаков Маслакович',
        email: 'Maslo@example.com',
        group: '972301',
        reason: 'Уважительная причина: пыся балела.'
    },
    {
        fullName: 'Коротков Коротков Короткович',
        email: 'Korotenkiy@example.com',
        group: '972301',
        reason: 'Уважительная причина: проходил майнкрафт.'
    },
    {
        fullName: 'Фятхуллин Фятхуллин Фятхуллинович ',
        email: 'fyathullinka@mail.ru',
        group: '972303',
        reason: 'Уважительная причина: Качок.'
    }
];

const tableBody = document.querySelector('#usersTable tbody');

function displayPasses(passes) {
    tableBody.innerHTML = '';

    passes.forEach(pass => {
        const row = document.createElement('tr');

        const nameCell = document.createElement('td');
        nameCell.textContent = pass.fullName;
        row.appendChild(nameCell);

        const emailCell = document.createElement('td');
        emailCell.textContent = pass.email;
        row.appendChild(emailCell);

        const groupCell = document.createElement('td');
        groupCell.textContent = pass.group;
        row.appendChild(groupCell);

        const reasonCell = document.createElement('td');
        reasonCell.textContent = pass.reason;
        reasonCell.className = 'reason'; 
        row.appendChild(reasonCell);

        tableBody.appendChild(row);
    });
}

displayPasses(passes);