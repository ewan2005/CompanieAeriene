(function () {
    'use strict';

    /**
     * Normalize text for filtering: lowercase + remove accents.
     */
    function normalize(text) {
        var s = (text || '').toString().toLowerCase();
        if (s.normalize) {
            s = s.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
        }
        return s;
    }

    function init() {
        var table = document.getElementById('listTable');
        var select = document.getElementById('filterColumn');
        var input = document.getElementById('filterInput');

        if (!table || !select || !input) return;

        var thead = table.tHead;
        var tbody = table.tBodies && table.tBodies.length ? table.tBodies[0] : null;
        if (!tbody) return;

        // Populate column selector from table headers
        if (thead && thead.rows && thead.rows.length) {
            var headerCells = thead.rows[0].cells;
            for (var i = 0; i < headerCells.length; i++) {
                var label = (headerCells[i].textContent || '').trim();
                if (!label) continue;
                if (normalize(label) === 'actions') continue;
                var opt = document.createElement('option');
                opt.value = String(i);
                opt.textContent = label;
                select.appendChild(opt);
            }
        }

        function getRows() {
            return Array.prototype.slice.call(tbody.rows || []);
        }

        function applyFilter() {
            var colIndex = parseInt(select.value, 10);
            var query = normalize(input.value).trim();
            var rows = getRows();

            rows.forEach(function (row) {
                // Keep empty-state rows visible
                if (row.querySelector && row.querySelector('.empty-state')) {
                    row.style.display = '';
                    return;
                }

                // If query is empty, show all rows
                if (!query) {
                    row.style.display = '';
                    return;
                }

                var match = false;

                if (colIndex === -1) {
                    // Search across all columns (entire row text)
                    var rowText = normalize(row.textContent);
                    match = rowText.indexOf(query) !== -1;
                } else {
                    // Search in a specific column
                    var cell = row.cells && row.cells.length > colIndex ? row.cells[colIndex] : null;
                    var cellText = normalize(cell ? cell.textContent : '');
                    match = cellText.indexOf(query) !== -1;
                }

                row.style.display = match ? '' : 'none';
            });
        }

        // Live filtering
        input.addEventListener('input', applyFilter);
        select.addEventListener('change', function () {
            applyFilter();
            input.focus();
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
