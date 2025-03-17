document.addEventListener('DOMContentLoaded', function() {
    const passes = [
        { time: '10:00 - 12:00', reason: 'Болезнь с подтверждающим документом' },
        { time: '14:00 - 16:00', reason: 'Семейные обстоятельства' },
        { time: '14:00 - 16:00', reason: 'Семейные обстоятельстваdfgdfshhfdhdhdhdfghdfghfdhdfghfghgdfhgjdfhdfghjkdfghjkdfghjh' }
    ];

    const tableBody = document.querySelector('#passesTable tbody');

    passes.forEach(pass => {
        const row = document.createElement('tr');

        const timeCell = document.createElement('td');
        timeCell.textContent = pass.time;
        row.appendChild(timeCell);

        const reasonCell = document.createElement('td');
        reasonCell.textContent = pass.reason;
        reasonCell.classList.add('reason'); 
        row.appendChild(reasonCell);

        const actionsCell = document.createElement('td');
        const acceptButton = document.createElement('button');
        acceptButton.textContent = 'Принять';
        acceptButton.addEventListener('click', () => {
            alert('Пропуск принят');
        });

        const rejectButton = document.createElement('button');
        rejectButton.textContent = 'Отказать';
        rejectButton.classList.add('delete');
        rejectButton.addEventListener('click', () => {
            alert('Пропуск отклонен');
        });

        const downloadButton = document.createElement('button');
        downloadButton.textContent = 'Скачать файл';
        downloadButton.addEventListener('click', () => {
            alert('Файл скачан');
        });

        actionsCell.appendChild(acceptButton);
        actionsCell.appendChild(rejectButton);
        actionsCell.appendChild(downloadButton);
        row.appendChild(actionsCell);

        tableBody.appendChild(row);
    });
});