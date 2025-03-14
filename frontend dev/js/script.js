if (document.getElementById('studentName')) {
    document.addEventListener('DOMContentLoaded', function () {
        const currentUser = JSON.parse(localStorage.getItem('currentUser'));

        if (currentUser) {
            document.getElementById('studentName').textContent = currentUser.fullName;
            document.getElementById('studentGroup').textContent = currentUser.group;

            const studentAbsences = absences.filter(absence => absence.studentId === currentUser.email);
            const tbody = document.querySelector('#absencesTable tbody');
            tbody.innerHTML = '';

            studentAbsences.forEach((absence, index) => {
                const row = document.createElement('tr');
                row.innerHTML = `
                    <td>${absence.subject}, ${absence.date}</td>
                    <td>${absence.status}</td>
                    <td>${absence.reason}</td>
                    <td>
                        ${absence.file ? `<a href="${absence.file}" download="справка.pdf">Скачать файл</a>` : 'Нет файла'}
                    </td>
                    <td>
                        <button onclick="editAbsence(${index})">Редактировать</button>
                        <button onclick="deleteAbsence(${index})">Удалить</button>
                    </td>
                `;
                tbody.appendChild(row);
            });
        } else {
            window.location.href = 'index.html';
        }
    });
}

if (document.getElementById('createAbsenceForm')) {
    document.getElementById('createAbsenceForm').addEventListener('submit', function (e) {
        e.preventDefault();

        const subject = document.getElementById('subject').value;
        const date = document.getElementById('date').value;
        const reason = document.getElementById('reason').value;
        const fileInput = document.getElementById('file');
        const file = fileInput.files[0];

        const currentUser = JSON.parse(localStorage.getItem('currentUser'));

        const reader = new FileReader();
        reader.onload = function (e) {
            const fileData = e.target.result; 

            const editIndex = localStorage.getItem('editAbsenceIndex');
            if (editIndex !== null) {
                absences[editIndex] = {
                    studentId: currentUser.email,
                    subject,
                    date,
                    reason,
                    file: fileData, 
                    status: absences[editIndex].status 
                };
                localStorage.removeItem('editAbsenceIndex'); 
            } else {
                const newAbsence = {
                    studentId: currentUser.email,
                    subject,
                    date,
                    reason,
                    file: fileData,
                    status: 'не принято'
                };
                absences.push(newAbsence);
            }

            localStorage.setItem('absences', JSON.stringify(absences));
            alert('Пропуск сохранен успешно!');
            window.location.href = 'student.html';
        };

        if (file) {
            reader.readAsDataURL(file);
        } else {
            alert('Пожалуйста, прикрепите файл (например, справку).');
        }
    });
}

function editAbsence(index) {
    localStorage.setItem('editAbsenceIndex', index);
    window.location.href = 'create-absence.html';
}

function deleteAbsence(index) {
    if (confirm('Вы уверены, что хотите удалить этот пропуск?')) {
        absences.splice(index, 1); 
        localStorage.setItem('absences', JSON.stringify(absences)); 
        window.location.reload();
    }
}

if (document.getElementById('createAbsenceForm')) {
    document.addEventListener('DOMContentLoaded', function () {
        const editIndex = localStorage.getItem('editAbsenceIndex');
        if (editIndex !== null) {
            const absence = absences[editIndex];
            document.getElementById('subject').value = absence.subject;
            document.getElementById('date').value = absence.date;
            document.getElementById('reason').value = absence.reason;
        }
    });
}
