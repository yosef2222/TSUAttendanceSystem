
let absences = JSON.parse(localStorage.getItem('absences')) || [];

document.getElementById('loginForm')?.addEventListener('submit', function (e) {
    e.preventDefault();
    const username = document.getElementById('username').value;
    const password = document.getElementById('password').value;

    if (username === 'student' && password === 'student') {
        window.location.href = 'student.html';
    } else if (username === 'admin' && password === 'admin') {
        window.location.href = 'admin.html';
    } else {
        alert('Неверный логин или пароль');
    }
});

document.getElementById('absenceForm')?.addEventListener('submit', function (e) {
    e.preventDefault();
    const reason = document.getElementById('reason').value;
    const documentFile = document.getElementById('document').files[0];

    const newAbsence = {
        id: Date.now(),
        student: 'Иван Иванов', 
        reason: reason,
        document: documentFile ? documentFile.name : null,
        status: 'На проверке'
    };

    absences.push(newAbsence);
    localStorage.setItem('absences', JSON.stringify(absences));
    document.getElementById('statusMessage').innerText = 'Пропуск создан!';
});

function renderAbsences() {
    const tableBody = document.querySelector('#absencesTable tbody');
    tableBody.innerHTML = '';

    absences.forEach(absence => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${absence.student}</td>
            <td>${absence.reason}</td>
            <td>${absence.document || 'Нет документа'}</td>
            <td>${absence.status}</td>
            <td>
                <button onclick="approveAbsence(${absence.id})">Одобрить</button>
                <button onclick="rejectAbsence(${absence.id})">Отклонить</button>
            </td>
        `;
        tableBody.appendChild(row);
    });
}

function approveAbsence(id) {
    const absence = absences.find(a => a.id === id);
    if (absence) {
        absence.status = 'Одобрено';
        localStorage.setItem('absences', JSON.stringify(absences));
        renderAbsences();
    }
}

function rejectAbsence(id) {
    const absence = absences.find(a => a.id === id);
    if (absence) {
        absence.status = 'Отклонено';
        localStorage.setItem('absences', JSON.stringify(absences));
        renderAbsences();
    }
}

document.getElementById('exportButton')?.addEventListener('click', function () {
    const csvContent = "data:text/csv;charset=utf-8," 
        + absences.map(a => `${a.student},${a.reason},${a.document},${a.status}`).join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "absences.csv");
    document.body.appendChild(link);
    link.click();
});

if (window.location.pathname.endsWith('admin.html')) {
    renderAbsences();
}