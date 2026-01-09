(function () {
    'use strict';

    function normalize(text) {
        var s = (text || '').toString().toLowerCase();
        // Remove accents/diacritics for more "standard" search behavior.
        if (s.normalize) {
            s = s.normalize('NFD').replace(/[\u0300-\u036f]/g, '');
        }
        return s;
    }

    function extractNumber(text) {
        var s = (text || '').toString();
        // Accept both dot and comma decimals.
        var m = s.replace(',', '.').match(/-?\d+(?:\.\d+)?/);
        if (!m) return NaN;
        return parseFloat(m[0]);
    }

    function getColumns(table) {
        if (!table || !table.tHead || !table.tHead.rows || !table.tHead.rows.length) return [];
        var headerCells = table.tHead.rows[0].cells;
        var cols = [];
        for (var i = 0; i < headerCells.length; i++) {
            var label = (headerCells[i].textContent || '').trim();
            if (!label) continue;
            if (normalize(label) === 'actions') continue;
            cols.push({ index: i, label: label });
        }
        return cols;
    }

    function ensureModal() {
        var existing = document.getElementById('listFilterModalOverlay');
        if (existing) return existing;

        var overlay = document.createElement('div');
        overlay.id = 'listFilterModalOverlay';
        overlay.className = 'filter-modal-overlay';
        overlay.setAttribute('aria-hidden', 'true');

        overlay.innerHTML =
            '<div class="filter-modal" role="dialog" aria-modal="true" aria-labelledby="listFilterModalTitle">' +
            '  <div class="filter-modal-header">' +
            '    <h3 class="filter-modal-title" id="listFilterModalTitle">🔎 Filtrer la liste</h3>' +
            '    <button type="button" class="btn btn-sm btn-danger" data-list-filter-close>✕</button>' +
            '  </div>' +
            '  <div class="filter-modal-body">' +
            '    <div class="form-group">' +
            '      <label for="listFilterColumn">Colonne</label>' +
            '      <select id="listFilterColumn" class="form-control"></select>' +
            '    </div>' +
            '    <div class="form-group">' +
            '      <label for="listFilterOperator">Opérateur</label>' +
            '      <select id="listFilterOperator" class="form-control">' +
            '        <option value="contains">Contient</option>' +
            '        <option value="equals">Égale</option>' +
            '        <option value="starts">Commence par</option>' +
            '        <option value="ends">Termine par</option>' +
            '        <option value="gt">&gt;</option>' +
            '        <option value="gte">&gt;=</option>' +
            '        <option value="lt">&lt;</option>' +
            '        <option value="lte">&lt;=</option>' +
            '      </select>' +
            '    </div>' +
            '    <div class="form-group">' +
            '      <label for="listFilterQuery">Valeur</label>' +
            '      <input type="search" id="listFilterQuery" class="form-control" placeholder="Ex: AB123, Paris, 100" autocomplete="off">' +
            '    </div>' +
            '  </div>' +
            '  <div class="filter-modal-footer">' +
            '    <button type="button" class="btn btn-secondary" data-list-filter-reset>Réinitialiser</button>' +
            '    <button type="button" class="btn btn-primary" data-list-filter-apply>Appliquer</button>' +
            '  </div>' +
            '</div>';

        document.body.appendChild(overlay);
        return overlay;
    }

    function initForTable(table) {
        if (!table || table.getAttribute('data-list-filter-initialized') === '1') return;
        table.setAttribute('data-list-filter-initialized', '1');

        var overlay = ensureModal();
        var modal = overlay.querySelector('.filter-modal');
        var select = overlay.querySelector('#listFilterColumn');
        var operator = overlay.querySelector('#listFilterOperator');
        var input = overlay.querySelector('#listFilterQuery');
        var applyBtn = overlay.querySelector('[data-list-filter-apply]');
        var resetBtn = overlay.querySelector('[data-list-filter-reset]');
        var closeBtn = overlay.querySelector('[data-list-filter-close]');

        var tbody = table.tBodies && table.tBodies.length ? table.tBodies[0] : null;
        if (!tbody) return;

        function getRows() {
            return Array.prototype.slice.call(tbody.rows || []);
        }

        function populateColumns() {
            var cols = getColumns(table);
            select.innerHTML = '';
            for (var i = 0; i < cols.length; i++) {
                var opt = document.createElement('option');
                opt.value = String(cols[i].index);
                opt.textContent = cols[i].label;
                select.appendChild(opt);
            }
            if (select.options.length) select.selectedIndex = 0;
        }

        function applyFilter() {
            var colIndex = parseInt(select.value, 10);
            if (isNaN(colIndex)) colIndex = 0;

            var query = normalize(input.value).trim();
            var op = operator && operator.value ? operator.value : 'contains';
            var rows = getRows();

            var queryNumber = NaN;
            if (op === 'gt' || op === 'gte' || op === 'lt' || op === 'lte') {
                queryNumber = extractNumber(input.value);
            }

            rows.forEach(function (row) {
                if (row.querySelector && row.querySelector('.empty-state')) {
                    row.style.display = '';
                    return;
                }

                if (!query) {
                    row.style.display = '';
                    return;
                }

                var cell = row.cells && row.cells.length > colIndex ? row.cells[colIndex] : null;
                var raw = cell ? cell.textContent : '';
                var haystack = normalize(raw);

                var match = false;

                if (op === 'contains') {
                    match = haystack.indexOf(query) !== -1;
                } else if (op === 'equals') {
                    match = haystack.trim() === query;
                } else if (op === 'starts') {
                    match = haystack.indexOf(query) === 0;
                } else if (op === 'ends') {
                    match = query ? haystack.lastIndexOf(query) === (haystack.length - query.length) : true;
                } else if (op === 'gt' || op === 'gte' || op === 'lt' || op === 'lte') {
                    if (isNaN(queryNumber)) {
                        match = false;
                    } else {
                        var cellNumber = extractNumber(raw);
                        if (isNaN(cellNumber)) {
                            match = false;
                        } else if (op === 'gt') {
                            match = cellNumber > queryNumber;
                        } else if (op === 'gte') {
                            match = cellNumber >= queryNumber;
                        } else if (op === 'lt') {
                            match = cellNumber < queryNumber;
                        } else if (op === 'lte') {
                            match = cellNumber <= queryNumber;
                        }
                    }
                }

                row.style.display = match ? '' : 'none';
            });
        }

        function resetFilter() {
            input.value = '';
            if (operator) operator.value = 'contains';
            applyFilter();
        }

        function open() {
            populateColumns();
            overlay.setAttribute('aria-hidden', 'false');
            overlay.classList.add('is-open');
            setTimeout(function () {
                input.focus();
            }, 0);
        }

        function close() {
            overlay.setAttribute('aria-hidden', 'true');
            overlay.classList.remove('is-open');
        }

        // Open trigger
        var openBtn = document.querySelector('[data-list-filter-open]');
        if (openBtn) {
            openBtn.addEventListener('click', open);
        }

        // Modal actions
        applyBtn.addEventListener('click', function () {
            applyFilter();
            close();
        });

        // Live preview
        input.addEventListener('input', function () {
            applyFilter();
        });
        if (operator) {
            operator.addEventListener('change', function () {
                applyFilter();
                input.focus();
            });
        }
        select.addEventListener('change', function () {
            applyFilter();
            input.focus();
        });

        resetBtn.addEventListener('click', function () {
            resetFilter();
        });

        closeBtn.addEventListener('click', close);

        overlay.addEventListener('click', function (e) {
            if (e.target === overlay) close();
        });

        document.addEventListener('keydown', function (e) {
            if (!overlay.classList.contains('is-open')) return;
            if (e.key === 'Escape') close();
            if (e.key === 'Enter' && document.activeElement === input) {
                applyFilter();
                close();
            }
        });

        // If there was an old inline filter input, hide it to avoid confusion.
        var legacyInput = document.getElementById('listFilter');
        if (legacyInput) {
            legacyInput.style.display = 'none';
        }
    }

    function init() {
        var table = document.getElementById('listTable');
        if (!table) return;
        initForTable(table);
    }

    window.ListFilterPopup = {
        init: init,
        initForTable: initForTable
    };

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', init);
    } else {
        init();
    }
})();
