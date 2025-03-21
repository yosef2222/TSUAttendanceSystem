const tableBody = document.querySelector('#passesTable tbody');
const jwtToken = localStorage.getItem('token'); 
let passes = [];
let userRoles = {}; 

/*async function init() {
    userRoles = await fetchRoles();
    const takesElement = document.getElementById("takesTh");
    if (userRoles.isAdmin || userRoles.isDean) {
        takesElement.style.display = "block";
    } else {
        takesElement.style.display = "none";
    }
    fetchPendingRequests();
}*/

//init();
fetchPendingRequests();

async function fetchPendingRequests(groupNumber = "") {
    try {
        let url = 'http://localhost:5163/api/Requests/approved';
        if (groupNumber.trim() !== "") {
            url += `?groupNumber=${encodeURIComponent(groupNumber)}`;
        }

        const response = await fetch(url, {
            method: 'GET',
            headers: {
                'accept': '*/*',
                'Authorization': `Bearer ${jwtToken}`
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

document.getElementById("searchGroupButton").addEventListener("click", function () {
    const groupValue = document.getElementById("searchGroupInput").value;
    fetchPendingRequests(groupValue);
});

async function renderRequests(requests) {
    tableBody.innerHTML = '';
    for (const request of requests) {
        const row = document.createElement('tr');

        const studentCell = document.createElement('td');
        studentCell.textContent = request.studentFullName;
        row.appendChild(studentCell);
        
        const groupCell = document.createElement('td');
        groupCell.textContent = request.groupNumber;
        row.appendChild(groupCell);

        const reasonCell = document.createElement('td');
        reasonCell.textContent = request.reason || 'Причина не указана'; 
        reasonCell.classList.add('reason');
        row.appendChild(reasonCell);

        const startDateCell = document.createElement('td');
        startDateCell.textContent = formatDate(request.absenceDateStart);
        row.appendChild(startDateCell);

        const endDateCell = document.createElement('td');
        endDateCell.textContent = formatDate(request.absenceDateEnd);
        row.appendChild(endDateCell);

        const statusCell = document.createElement('td');
        statusCell.textContent = request.status === "Approved" ? "Принято" : request.status;
        row.appendChild(statusCell);

        const fileLinks = request.fileIds && request.fileIds.length > 0 ? await fetchFileLinks(request.id, request.fileIds) : "Нет файлов";

        const filesCell = document.createElement('td');
        filesCell.innerHTML = fileLinks; 
        row.appendChild(filesCell);
        
        
        /*if(userRoles.isDean || userRoles.isAdmin){
            const actionsCell = document.createElement('td');
            const rejectButton = document.createElement('button');
            rejectButton.textContent = 'Отказать';
            rejectButton.classList.add('delete');
            rejectButton.addEventListener('click', () => {
            reviewRequest(request.id, false); 
            });
            actionsCell.appendChild(rejectButton);
            row.appendChild(actionsCell);
        }*/
        tableBody.appendChild(row);
    }
}

async function reviewRequest(requestId, approved) {
    const jwtToken = localStorage.getItem('token')
    try {
        const response = await fetch(`http://localhost:5163/api/Requests/${requestId}/review`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${jwtToken}`
            },
            body: JSON.stringify({ "approve": approved })
        });

        if (response.ok) {
            alert(`Запрос ${approved ? 'принят' : 'отклонен'}`);
            fetchPendingRequests(); 
        } else {
            throw new Error(`Ошибка: ${response.status}`);
        }
    } catch (error) {
        console.error('Ошибка при отправке запроса:', error);
        alert('Не удалось отправить запрос');
    }
}

function formatDate(dateString) {
    if (dateString === '0001-01-01T00:00:00') {
        return 'Дата не указана';
    }
    const date = new Date(dateString);
    return date.toLocaleString(); 
}

async function fetchFileLinks(requestId, fileIds) {
    const token = localStorage.getItem("token");
    if (!token) {
        console.error("Токен авторизации отсутствует");
        return "Ошибка авторизации";
    }

    try {
        const fileLinks = await Promise.all(fileIds.map(async (fileId) => {
            const response = await fetch(`http://localhost:5163/api/Requests/${requestId}/files/${fileId}`, {
                method: "GET",
                headers: {
                    "Authorization": `Bearer ${token}`
                }
            });

            if (!response.ok) {
                console.error(`Ошибка загрузки файла ${fileId}:`, response.statusText);
                return "Ошибка загрузки";
            }

            const blob = await response.blob();
            const fileUrl = URL.createObjectURL(blob);
            return `<a href="${fileUrl}" target="_blank" download>Скачать файл</a>`;
        }));

        return fileLinks.join("<br>");
    } catch (error) {
        console.error("Ошибка при получении файлов:", error);
        return "Ошибка загрузки файлов";
    }
}