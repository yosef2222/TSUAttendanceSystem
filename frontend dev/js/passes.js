const tableBody = document.querySelector('#passesTable tbody');
const jwtToken = localStorage.getItem('token'); 
let passes = [];
async function fetchPendingRequests() {
    try {
        const response = await fetch('http://localhost:5163/api/Requests/pending', {
            method: 'GET',
            headers: {
                'accept': '*/*',
                'Authorization':  `Bearer ${jwtToken}`
            }
        });

        if (!response.ok) {
            throw new Error(`Ошибка: ${response.status}`);
        }

        passes = await response.json(); 
        renderRequests(passes);
    } catch (error) {
        console.error('Ошибка при получении данных:', error);
        alert('Не удалось загрузить данные');
    }
}


function renderRequests(requests) {
    tableBody.innerHTML = '';

    requests.forEach(request => {
        const row = document.createElement('tr');

        // Студент
        const studentCell = document.createElement('td');
        studentCell.textContent = request.studentFullName;
        row.appendChild(studentCell);

        // Причина
        const reasonCell = document.createElement('td');
        reasonCell.textContent = request.reason || 'Причина не указана'; 
        reasonCell.classList.add('reason');
        row.appendChild(reasonCell);

        // Дата начала
        const startDateCell = document.createElement('td');
        startDateCell.textContent = formatDate(request.absenceDateStart);
        row.appendChild(startDateCell);

        // Дата окончания
        const endDateCell = document.createElement('td');
        endDateCell.textContent = formatDate(request.absenceDateEnd);
        row.appendChild(endDateCell);

        // Статус
        const statusCell = document.createElement('td');
        statusCell.textContent = request.status;
        row.appendChild(statusCell);

        const filesCell = document.createElement('td');
        filesCell.textContent = request.fileIds;
        row.appendChild(filesCell);

        const actionsCell = document.createElement('td');
        const acceptButton = document.createElement('button');
        acceptButton.textContent = 'Принять';
        acceptButton.addEventListener('click', () => {
            reviewRequest(request.id, true); 
        });

        const rejectButton = document.createElement('button');
        rejectButton.textContent = 'Отказать';
        rejectButton.classList.add('delete');
        rejectButton.addEventListener('click', () => {
            reviewRequest(request.id, false); 
        });

        const downloadButton = document.createElement('button');
        downloadButton.textContent = 'Скачать файл';
        downloadButton.disabled = request.fileIds.length === 0; 
        downloadButton.addEventListener('click', () => {
            downloadFiles(request.fileIds); 
        });

        actionsCell.appendChild(acceptButton);
        actionsCell.appendChild(rejectButton);
        actionsCell.appendChild(downloadButton);
        row.appendChild(actionsCell);

        tableBody.appendChild(row);
    });
}

// Функция для форматирования даты
function formatDate(dateString) {
    if (dateString === '0001-01-01T00:00:00') {
        return 'Дата не указана';
    }
    const date = new Date(dateString);
    return date.toLocaleString(); // Форматируем дату в локальный формат
}

// Функция для отправки запроса на принятие/отклонение
async function reviewRequest(requestId, approved) {
    try {
        const response = await fetch(`http://localhost:5163/api/Requests/${requestId}/review`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer ваш_токен'
            },
            body: JSON.stringify({ approved })
        });

        if (response.ok) {
            alert(`Запрос ${approved ? 'принят' : 'отклонен'}`);
            fetchPendingRequests(); // Обновляем список запросов
        } else {
            throw new Error(`Ошибка: ${response.status}`);
        }
    } catch (error) {
        console.error('Ошибка при отправке запроса:', error);
        alert('Не удалось отправить запрос');
    }
}

// Функция для скачивания файлов
async function downloadFiles(fileIds) {
    if (fileIds.length === 0) {
        alert('Нет файлов для скачивания');
        return;
    }

    try {
        for (const fileId of fileIds) {
            const response = await fetch(`http://localhost:5163/api/Files/${fileId}/download`, {
                method: 'GET',
                headers: {
                    'Authorization': 'Bearer ваш_токен'
                }
            });

            if (response.ok) {
                const blob = await response.blob();
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `file_${fileId}`;
                a.click();
                window.URL.revokeObjectURL(url);
            } else {
                throw new Error(`Ошибка при скачивании файла: ${response.status}`);
            }
        }
    } catch (error) {
        console.error('Ошибка при скачивании файлов:', error);
        alert('Не удалось скачать файлы');
    }
}

fetchPendingRequests();