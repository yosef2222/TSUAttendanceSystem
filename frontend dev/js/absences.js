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
        const dateStart = absence.absenceDateStart ? new Date(absence.absenceDateStart).toLocaleString() : "-";
        const dateEnd = absence.absenceDateEnd ? new Date(absence.absenceDateEnd).toLocaleString() : "-";

        let fileLinks = "Нет файлов";
        if (absence.fileIds && absence.fileIds.length > 0) {
            fileLinks = await fetchFileLinks(absence.id, absence.fileIds);
        }

        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${absence.reason}</td>
            <td>${absence.status}</td>
            <td>${dateStart}</td>  
            <td>${dateEnd}</td>  
            <td>${fileLinks}</td>
            <td>
                <button onclick="editAbsence(${index})">Редактировать</button>
            </td>
        `;

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


form.addEventListener("submit", async function (e) {
    e.preventDefault();

    const reason = document.getElementById("reason").value.trim();
    const dateStartInput = document.getElementById("dateStart").value;
    const dateEndInput = document.getElementById("dateEnd").value;
    const fileInput = document.getElementById("file");

    if (!reason) {
        console.error("Поле 'Reason' не может быть пустым");
        return;
    }
    if (!dateStartInput || !dateEndInput) {
        console.error("Поля даты должны быть заполнены");
        return;
    }

    const dateStart = new Date(dateStartInput).toISOString();
    const dateEnd = new Date(dateEndInput).toISOString();

    const formData = new FormData();
    formData.append("Reason", reason);
    formData.append("AbsenceDateStart", dateStart);
    formData.append("AbsenceDateEnd", dateEnd);

    if (fileInput.files.length > 0) {
        const file = fileInput.files[0];
        formData.append("files", file);
    } else {
        console.error("Файл не выбран");
        return;
    }

    try {
        const token = localStorage.getItem("token");
        if (!token) {
            console.error("Токен авторизации отсутствует");
            return;
        }

        const response = await fetch("http://localhost:5163/api/Requests", {
            method: "POST",
            headers: {
                "Authorization": `Bearer ${token}`
            },
            body: formData
        });

        if (!response.ok) {
            throw new Error(`Ошибка: ${response.statusText}`);
        }

        const result = await response.json();
        console.log("Успешно добавлено:", result);

        modal.style.display = "none";
        form.reset();
        editingIndex = null;

        fetchAbsences();
    } catch (error) {
        console.error("Ошибка при добавлении пропуска:", error);
    }
});

window.editAbsence = function (index) {
    editingIndex = index;
    const absence = absences[index];
    
    document.getElementById("reason").value = absence.reason;
    document.getElementById("dateStart").value = absence.dateStart;
    document.getElementById("dateEnd").value = absence.dateEnd;

    modal.style.display = "block";
};
