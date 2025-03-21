const modal = document.getElementById("createAbsenceModal");
const openModalBtn = document.getElementById("openCreateAbsenceModal");
const closeModalBtn = document.querySelector(".modal .close");
const form = document.getElementById("createAbsenceForm");
const tbody = document.querySelector("#absencesTable tbody");

let absences = [];
let editingIndex = null;

fetchAbsences();

openModalBtn.addEventListener("click", () => {
    editingIndex = null;
    form.reset();
    modal.style.display = "block";
    document.querySelector(".modal-content h2").textContent = "Создание пропуска"; 
    document.getElementById("reason").disabled = false; 
    document.getElementById("dateStart").disabled = false; 
    document.getElementById("dateEnd").disabled = false; 
});


closeModalBtn.addEventListener("click", () => {
    modal.style.display = "none";
});

window.addEventListener("click", (event) => {
    if (event.target === modal) {
        modal.style.display = "none";
    }
});

async function fetchAbsences() {
    try {
        const token = localStorage.getItem("token");
        if (!token) {
            console.error("Токен авторизации отсутствует");
            return;
        }

        const response = await fetch("http://localhost:5163/api/Requests/my", {
            method: "GET",
            headers: {
                "Authorization": `Bearer ${token}`
            }
        });

        if (!response.ok) {
            throw new Error(`Ошибка: ${response.statusText}`);
        }

        const data = await response.json();
        absences = data;
        renderTable();
    } catch (error) {
        console.error("Ошибка при получении пропусков:", error);
    }
}

async function renderTable() {
    tbody.innerHTML = "";

    for (const [index, absence] of absences.entries()) {
        const dateStart = absence.absenceDateStart ? formatDateTime(absence.absenceDateStart) : "-";
        const dateEnd = absence.absenceDateEnd ? formatDateTime(absence.absenceDateEnd) : "-";
        let status = "На проверке"
        if(absence.status === "Approved") status = "Принято";
        if(absence.status === "Rejected") status = "Отклонено";
        let fileLinks = "Нет файлов";
        if (absence.fileIds && absence.fileIds.length > 0) {
            fileLinks = await fetchFileLinks(absence.id, absence.fileIds);
        }

        const row = document.createElement("tr");
        if(absence.status === "Approved" || absence.status === "Rejected") {
            row.innerHTML = `
                <td>${absence.reason}</td>
                <td>${status}</td>
                <td>${dateStart}</td>  
                <td>${dateEnd}</td>  
                <td>${fileLinks}</td>
                <td>Нет действий</td>
            `;
        }else {
            row.innerHTML = `
                <td>${absence.reason}</td>
                <td>${status}</td>
                <td>${dateStart}</td>  
                <td>${dateEnd}</td>  
                <td>${fileLinks}</td>
                <td>
                    <button onclick="editAbsence(${index})">Редактировать</button>
                </td>
            `;
        }
        tbody.appendChild(row);
    }
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

function formatDateTime(dateStr) {
    const date = new Date(dateStr);
    const options = { 
        day: '2-digit', 
        month: '2-digit', 
        year: 'numeric', 
        hour: '2-digit', 
        minute: '2-digit', 
        hour12: false 
    };
    return date.toLocaleString("ru-RU", options); 
}



function toISOWithoutTimezone(dateStr) {
    const date = new Date(dateStr);
    const tzOffset = date.getTimezoneOffset() * 60000; 
    return new Date(date.getTime() - tzOffset).toISOString().slice(0, 16);
}

window.editAbsence = function (index) {
    editingIndex = index;
    const absence = absences[index];

    document.querySelector(".modal-content h2").textContent = "Редактирование пропуска"; 
    
    document.getElementById("reason").value = absence.reason;
    document.getElementById("reason").disabled = true; 
    
    document.getElementById("dateStart").value = absence.absenceDateStart ? toISOWithoutTimezone(absence.absenceDateStart) : "";
    document.getElementById("dateStart").disabled = true; 
    
    document.getElementById("dateEnd").value = absence.absenceDateEnd ? toISOWithoutTimezone(absence.absenceDateEnd) : "";
    document.getElementById("dateEnd").disabled = false; 

    document.getElementById("file").disabled = false; 
    modal.style.display = "block";
};

form.addEventListener("submit", async function (e) {
    e.preventDefault();
    const reasonInput = document.getElementById("reason").value;
    const dateStartInput = document.getElementById("dateStart").value;
    const dateEndInput = document.getElementById("dateEnd").value;
    const fileInput = document.getElementById("file");

    if (!reasonInput || !dateStartInput || !dateEndInput) {
        console.error("Поля 'Причина', 'Дата начала' и 'Дата окончания' должны быть заполнены");
        return;
    }
    
    const dateStart = toISOWithoutTimezone(dateStartInput);
    const dateEnd = toISOWithoutTimezone(dateEndInput);

    const formData = new FormData();
    formData.append("Reason", reasonInput);
    formData.append("AbsenceDateStart", dateStart);
    formData.append("AbsenceDateEnd", dateEnd);

    if (fileInput.files.length > 0) {
        const file = fileInput.files[0];
        formData.append("files", file);
    }

    try {
        const token = localStorage.getItem("token");
        if (!token) {
            console.error("Токен авторизации отсутствует");
            return;
        }

        let url = "http://localhost:5163/api/Requests/create";
        let method = "POST";

        if (editingIndex !== null) {
            const absenceId = absences[editingIndex].id;
            url = `http://localhost:5163/api/Requests/${absenceId}/edit-end-date`;
            method = "PUT";
        }

        const response = await fetch(url, {
            method: method,
            headers: {
                "Authorization": `Bearer ${token}`
            },
            body: formData
        });

        if (!response.ok) {
            throw new Error(`Ошибка: ${response.statusText}`);
        }

        console.log(`Успешно ${editingIndex !== null ? "обновлено" : "добавлено"}`);

        modal.style.display = "none";
        form.reset();
        editingIndex = null;

        fetchAbsences();
    } catch (error) {
        console.error(`Ошибка при ${editingIndex !== null ? "редактировании" : "добавлении"} пропуска:`, error);
    }
});
