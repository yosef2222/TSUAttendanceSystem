const modal = document.getElementById("createAbsenceModal");
const openModalBtn = document.getElementById("openCreateAbsenceModal");
const closeModalBtn = document.querySelector(".modal .close");
const form = document.getElementById("createAbsenceForm");
const tbody = document.querySelector("#absencesTable tbody");

let absences = [];
let editingIndex = null; 

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

function renderTable() {
    tbody.innerHTML = "";
    absences.forEach((absence, index) => {
        const row = document.createElement("tr");
        row.innerHTML = `
            <td>${absence.reason}</td>
            <td>${absence.dateStart}</td>
            <td>${absence.dateEnd}</td>
            <td>${absence.file ? `<a href="${absence.file}" download="справка.pdf">Скачать файл</a>` : "Нет файла"}</td>
            <td>
                <button onclick="editAbsence(${index})">Редактировать</button>
                <button class="delete" onclick="deleteAbsence(${index})">Удалить</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

form.addEventListener("submit", function (e) {
    e.preventDefault();
    const reason = document.getElementById("reason").value;
    const dateStart = document.getElementById("dateStart").value;
    const dateEnd = document.getElementById("dateEnd").value;
    const fileInput = document.getElementById("file");
    const file = fileInput.files[0];

    const reader = new FileReader();
    reader.onload = function (e) {
        const fileData = file ? e.target.result : null;
        const newAbsence = {reason, dateStart, dateEnd,  file: fileData};

        if (editingIndex !== null) {
            absences[editingIndex] = newAbsence;
        } else {
            absences.push(newAbsence);
        }

        renderTable();
        modal.style.display = "none";
        form.reset();
        editingIndex = null; 
    };

    if (file) {
        reader.readAsDataURL(file);
    } else {
        reader.onload();
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

window.deleteAbsence = function (index) {
    if (confirm("Вы уверены, что хотите удалить этот пропуск?")) {
        absences.splice(index, 1);
        renderTable();
    }
};
