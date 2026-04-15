import sys
import pyodbc
from PyQt6.QtCore    import Qt, QSortFilterProxyModel, QThread, pyqtSignal
from PyQt6.QtGui     import QColor, QFont, QStandardItem, QStandardItemModel
from PyQt6.QtWidgets import (
    QApplication, QDialog, QDialogButtonBox, QFormLayout,
    QFrame, QHBoxLayout, QHeaderView, QLabel, QLineEdit,
    QMainWindow, QMessageBox, QPushButton, QSizePolicy,
    QTabWidget, QTableView, QVBoxLayout, QWidget,
)

# ─────────────────────────────────────────────
#  DATABASE CONNECTION  (edit these values)
# ─────────────────────────────────────────────
DB_CONFIG = {
    "server":   "localhost",
    "database": "Food Delivery",
    "driver":   "ODBC Driver 17 for SQL Server",
    "trusted":  True,
    # "uid": "sa",
    # "pwd": "yourPassword",
}

def get_connection():
    if DB_CONFIG["trusted"]:
        cs = (
            f"DRIVER={{{DB_CONFIG['driver']}}};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            "Trusted_Connection=yes;"
        )
    else:
        cs = (
            f"DRIVER={{{DB_CONFIG['driver']}}};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"UID={DB_CONFIG['uid']};PWD={DB_CONFIG['pwd']};"
        )
    return pyodbc.connect(cs)


# ─────────────────────────────────────────────
#  COLOUR PALETTE  (teal / cyan theme)
# ─────────────────────────────────────────────
C = {
    "bg":         "#0f1923",   # very dark navy
    "surface":    "#162032",   # dark blue-grey panel
    "surface2":   "#1c2a3a",   # slightly lighter panel
    "accent":     "#06b6d4",   # cyan  (tab active / header)
    "accent2":    "#0891b2",   # darker cyan  (column headers)
    "success":    "#10b981",   # emerald green
    "danger":     "#f43f5e",   # rose red
    "warning":    "#f59e0b",   # amber (edit button)
    "text":       "#e2e8f0",   # light grey text
    "text_dim":   "#64748b",   # muted text
    "row_odd":    "#162032",
    "row_even":   "#1c2a3a",
    "row_sel":    "#0e7490",   # selected row highlight
    "border":     "#1e3448",
    "entry_bg":   "#1e3448",
}

# ─────────────────────────────────────────────
#  GLOBAL STYLESHEET
# ─────────────────────────────────────────────
QSS = f"""
/* ── Window / panels ── */
QMainWindow, QDialog {{
    background: {C['bg']};
}}
QWidget {{
    background: {C['bg']};
    color: {C['text']};
    font-family: "Segoe UI", sans-serif;
    font-size: 9pt;
}}

/* ── Tab bar ── */
QTabWidget::pane {{
    border: 1px solid {C['border']};
    background: {C['surface']};
    border-radius: 6px;
}}
QTabBar::tab {{
    background: {C['surface2']};
    color: {C['text_dim']};
    padding: 8px 18px;
    margin-right: 2px;
    border-top-left-radius: 6px;
    border-top-right-radius: 6px;
    font-weight: bold;
    font-size: 9pt;
}}
QTabBar::tab:selected {{
    background: {C['accent']};
    color: #ffffff;
}}
QTabBar::tab:hover:!selected {{
    background: {C['surface']};
    color: {C['text']};
}}

/* ── Table view ── */
QTableView {{
    background: {C['surface']};
    alternate-background-color: {C['surface2']};
    gridline-color: {C['border']};
    border: none;
    border-radius: 4px;
    selection-background-color: {C['row_sel']};
    selection-color: #ffffff;
}}
QTableView::item {{
    padding: 4px 8px;
}}
QHeaderView::section {{
    background: {C['accent2']};
    color: #ffffff;
    padding: 6px 10px;
    border: none;
    font-weight: bold;
    font-size: 9pt;
}}
QHeaderView::section:hover {{
    background: {C['accent']};
}}

/* ── Scrollbar ── */
QScrollBar:vertical, QScrollBar:horizontal {{
    background: {C['bg']};
    width: 10px; height: 10px;
    border-radius: 5px;
}}
QScrollBar::handle:vertical, QScrollBar::handle:horizontal {{
    background: {C['text_dim']};
    border-radius: 5px;
    min-height: 24px; min-width: 24px;
}}
QScrollBar::add-line, QScrollBar::sub-line {{
    width: 0; height: 0;
}}

/* ── Buttons ── */
QPushButton {{
    border: none;
    border-radius: 5px;
    padding: 6px 14px;
    font-weight: bold;
    color: #ffffff;
}}
QPushButton:hover   {{ opacity: 0.85; }}
QPushButton:pressed {{ opacity: 0.70; }}

QPushButton#btn_add     {{ background: {C['success']}; }}
QPushButton#btn_add:hover {{ background: #059669; }}

QPushButton#btn_edit    {{ background: {C['warning']}; color: #111; }}
QPushButton#btn_edit:hover {{ background: #d97706; }}

QPushButton#btn_delete  {{ background: {C['danger']}; }}
QPushButton#btn_delete:hover {{ background: #e11d48; }}

QPushButton#btn_refresh {{ background: {C['accent']}; }}
QPushButton#btn_refresh:hover {{ background: {C['accent2']}; }}

QPushButton#btn_save    {{ background: {C['success']}; }}
QPushButton#btn_cancel  {{ background: {C['danger']}; }}

/* ── Search box ── */
QLineEdit {{
    background: {C['entry_bg']};
    border: 1px solid {C['border']};
    border-radius: 4px;
    padding: 4px 8px;
    color: {C['text']};
}}
QLineEdit:focus {{
    border: 1px solid {C['accent']};
}}

/* ── Form dialog labels ── */
QLabel#hint {{
    color: {C['text_dim']};
    font-style: italic;
}}
QLabel#count_label {{
    color: {C['text_dim']};
}}

/* ── Header bar frame ── */
QFrame#header_frame {{
    background: {C['accent2']};
    border-radius: 0px;
}}
QLabel#header_title {{
    color: #ffffff;
    font-size: 14pt;
    font-weight: bold;
    background: transparent;
}}
QLabel#conn_ok {{
    color: {C['success']};
    font-weight: bold;
    background: transparent;
}}
QLabel#conn_fail {{
    color: {C['danger']};
    font-weight: bold;
    background: transparent;
}}
"""


# ─────────────────────────────────────────────
#  FORM DIALOG
# ─────────────────────────────────────────────
class FormDialog(QDialog):
    """Generic Add / Edit dialog."""

    def __init__(self, parent, title: str, editable_cols: list,
                 all_cols: list, current_values, on_save):
        super().__init__(parent)
        self.setWindowTitle(title)
        self.setModal(True)
        self.setMinimumWidth(420)

        self._editable    = editable_cols
        self._all_cols    = all_cols
        self._cur_vals    = current_values
        self._on_save     = on_save
        self._entries: dict[str, QLineEdit] = {}

        self._build()

    def _build(self):
        layout = QVBoxLayout(self)
        layout.setContentsMargins(20, 16, 20, 16)
        layout.setSpacing(10)

        hint = QLabel("Fill in the fields below")
        hint.setObjectName("hint")
        layout.addWidget(hint)

        form = QFormLayout()
        form.setLabelAlignment(Qt.AlignmentFlag.AlignRight)
        form.setSpacing(8)

        col_idx = {c["name"]: i for i, c in enumerate(self._all_cols)}

        for col in self._editable:
            lbl = QLabel(col["label"] + ":")
            lbl.setStyleSheet(f"color: {C['text']}; font-weight: bold;")
            entry = QLineEdit()
            entry.setMinimumWidth(260)

            if self._cur_vals is not None:
                idx = col_idx.get(col["name"])
                if idx is not None:
                    v = self._cur_vals[idx]
                    entry.setText("" if v is None else str(v))

            form.addRow(lbl, entry)
            self._entries[col["name"]] = entry

        layout.addLayout(form)

        # ── button row ──
        btn_row = QHBoxLayout()
        btn_row.setSpacing(10)

        btn_save   = QPushButton("💾  Save")
        btn_cancel = QPushButton("✕  Cancel")
        btn_save.setObjectName("btn_save")
        btn_cancel.setObjectName("btn_cancel")

        btn_save.clicked.connect(self._save)
        btn_cancel.clicked.connect(self.reject)

        btn_row.addStretch()
        btn_row.addWidget(btn_save)
        btn_row.addWidget(btn_cancel)
        layout.addLayout(btn_row)

    def _save(self):
        data = {}
        for col in self._editable:
            val = self._entries[col["name"]].text().strip()
            data[col["name"]] = val if val else None
        self._on_save(data, self._cur_vals is not None, self._cur_vals)
        self.accept()


# ─────────────────────────────────────────────
#  TABLE TAB
# ─────────────────────────────────────────────
class TableTab(QWidget):
    """
    One tab showing a SQL Server table with:
      Add / Edit / Delete / Refresh toolbar + live search.

    Column dict keys:
        name   – SQL column name
        label  – header text shown in GUI
        width  – pixel width (default 120)
        pk     – True → primary key
        auto   – True → IDENTITY / server default (hidden in forms)
    """

    def __init__(self, table_full_name: str, columns: list):
        super().__init__()
        self.table    = table_full_name
        self.columns  = columns
        self.pk_cols  = [c for c in columns if c.get("pk")]
        self.editable = [c for c in columns if not c.get("auto")]
        self._all_data: list[list] = []

        self._build_ui()
        self.refresh()

    # ── UI construction ──────────────────────
    def _build_ui(self):
        root = QVBoxLayout(self)
        root.setContentsMargins(10, 10, 10, 10)
        root.setSpacing(8)

        # ── toolbar ──
        toolbar = QHBoxLayout()
        toolbar.setSpacing(6)

        def make_btn(text, obj_name, slot):
            b = QPushButton(text)
            b.setObjectName(obj_name)
            b.setCursor(Qt.CursorShape.PointingHandCursor)
            b.clicked.connect(slot)
            return b

        toolbar.addWidget(make_btn("＋  Add",     "btn_add",     self._open_add))
        toolbar.addWidget(make_btn("✎  Edit",    "btn_edit",    self._open_edit))
        toolbar.addWidget(make_btn("✕  Delete",  "btn_delete",  self._delete_row))
        toolbar.addWidget(make_btn("↻  Refresh", "btn_refresh", self.refresh))

        toolbar.addSpacing(20)
        lbl_search = QLabel("Search:")
        lbl_search.setStyleSheet(f"color: {C['text_dim']};")
        toolbar.addWidget(lbl_search)

        self._search_box = QLineEdit()
        self._search_box.setPlaceholderText("Type to filter…")
        self._search_box.setFixedWidth(220)
        self._search_box.textChanged.connect(self._apply_filter)
        toolbar.addWidget(self._search_box)

        toolbar.addStretch()

        self._count_lbl = QLabel("")
        self._count_lbl.setObjectName("count_label")
        toolbar.addWidget(self._count_lbl)

        root.addLayout(toolbar)

        # ── table view ──
        self._model = QStandardItemModel()
        self._model.setHorizontalHeaderLabels(
            [c["label"] for c in self.columns]
        )

        self._proxy = QSortFilterProxyModel()
        self._proxy.setSourceModel(self._model)
        self._proxy.setFilterCaseSensitivity(
            Qt.CaseSensitivity.CaseInsensitive
        )
        self._proxy.setFilterKeyColumn(-1)   # search all columns

        self._view = QTableView()
        self._view.setModel(self._proxy)
        self._view.setAlternatingRowColors(True)
        self._view.setSelectionBehavior(
            QTableView.SelectionBehavior.SelectRows
        )
        self._view.setSelectionMode(
            QTableView.SelectionMode.SingleSelection
        )
        self._view.setEditTriggers(
            QTableView.EditTrigger.NoEditTriggers
        )
        self._view.setSortingEnabled(True)
        self._view.verticalHeader().setVisible(False)
        self._view.horizontalHeader().setHighlightSections(False)
        self._view.doubleClicked.connect(self._open_edit)

        hdr = self._view.horizontalHeader()
        for i, col in enumerate(self.columns):
            hdr.resizeSection(i, col.get("width", 120))
        hdr.setStretchLastSection(True)

        root.addWidget(self._view)

    # ── data helpers ─────────────────────────
    def refresh(self):
        try:
            with get_connection() as conn:
                cur = conn.cursor()
                names = ", ".join(c["name"] for c in self.columns)
                cur.execute(f"SELECT {names} FROM {self.table}")
                rows = cur.fetchall()
        except Exception as e:
            QMessageBox.critical(self, "DB Error", str(e))
            return

        self._all_data = [list(r) for r in rows]
        self._populate(self._all_data)

    def _populate(self, data: list[list]):
        self._model.setRowCount(0)
        for row_vals in data:
            items = []
            for v in row_vals:
                item = QStandardItem("" if v is None else str(v))
                item.setTextAlignment(Qt.AlignmentFlag.AlignCenter)
                item.setForeground(QColor(C["text"]))
                items.append(item)
            self._model.appendRow(items)
        self._count_lbl.setText(f"{len(data)} row(s)")

    def _apply_filter(self, text: str):
        self._proxy.setFilterFixedString(text)
        visible = self._proxy.rowCount()
        self._count_lbl.setText(f"{visible} row(s)")

    def _selected_source_row(self):
        """Return (source_row_index, values_list) or (None, None)."""
        idxs = self._view.selectionModel().selectedRows()
        if not idxs:
            return None, None
        proxy_row = idxs[0].row()
        src_row   = self._proxy.mapToSource(idxs[0]).row()
        vals = [
            self._model.item(src_row, col).text()
            for col in range(len(self.columns))
        ]
        return src_row, vals

    # ── CRUD ─────────────────────────────────
    def _open_add(self):
        FormDialog(self, "Add Row",
                   self.editable, self.columns,
                   None, self._save_form).exec()

    def _open_edit(self):
        _, vals = self._selected_source_row()
        if vals is None:
            QMessageBox.warning(self, "Select Row",
                                "Please select a row to edit.")
            return
        FormDialog(self, "Edit Row",
                   self.editable, self.columns,
                   vals, self._save_form).exec()

    def _save_form(self, data: dict, is_edit: bool, original_values):
        try:
            with get_connection() as conn:
                cur = conn.cursor()
                if not is_edit:
                    col_names    = ", ".join(data.keys())
                    placeholders = ", ".join("?" for _ in data)
                    cur.execute(
                        f"INSERT INTO {self.table} ({col_names}) "
                        f"VALUES ({placeholders})",
                        list(data.values())
                    )
                else:
                    set_clause = ", ".join(f"{k} = ?" for k in data)
                    pk_clause  = " AND ".join(
                        f"{c['name']} = ?" for c in self.pk_cols
                    )
                    col_idx = {c["name"]: i
                               for i, c in enumerate(self.columns)}
                    pk_vals = [original_values[col_idx[c["name"]]]
                               for c in self.pk_cols]
                    cur.execute(
                        f"UPDATE {self.table} SET {set_clause} "
                        f"WHERE {pk_clause}",
                        list(data.values()) + pk_vals
                    )
                conn.commit()
        except Exception as e:
            QMessageBox.critical(self, "DB Error", str(e))
            return
        self.refresh()

    def _delete_row(self):
        _, vals = self._selected_source_row()
        if vals is None:
            QMessageBox.warning(self, "Select Row",
                                "Please select a row to delete.")
            return
        reply = QMessageBox.question(
            self, "Confirm Delete",
            "Are you sure you want to delete this row?",
            QMessageBox.StandardButton.Yes | QMessageBox.StandardButton.No
        )
        if reply != QMessageBox.StandardButton.Yes:
            return
        try:
            col_idx   = {c["name"]: i for i, c in enumerate(self.columns)}
            pk_clause = " AND ".join(
                f"{c['name']} = ?" for c in self.pk_cols
            )
            pk_vals   = [vals[col_idx[c["name"]]] for c in self.pk_cols]
            with get_connection() as conn:
                cur = conn.cursor()
                cur.execute(
                    f"DELETE FROM {self.table} WHERE {pk_clause}", pk_vals
                )
                conn.commit()
        except Exception as e:
            QMessageBox.critical(self, "DB Error", str(e))
            return
        self.refresh()


# ─────────────────────────────────────────────
#  MAIN WINDOW
# ─────────────────────────────────────────────
class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Food Delivery — Database Manager")
        self.resize(1280, 760)
        self.setMinimumSize(900, 600)

        central = QWidget()
        self.setCentralWidget(central)
        vbox = QVBoxLayout(central)
        vbox.setContentsMargins(0, 0, 0, 0)
        vbox.setSpacing(0)

        vbox.addWidget(self._build_header())
        vbox.addWidget(self._build_tabs(), stretch=1)

    # ── header ───────────────────────────────
    def _build_header(self) -> QFrame:
        frame = QFrame()
        frame.setObjectName("header_frame")
        frame.setFixedHeight(58)

        hbox = QHBoxLayout(frame)
        hbox.setContentsMargins(20, 0, 20, 0)

        title = QLabel("🍔  Food Delivery  —  Database Manager")
        title.setObjectName("header_title")
        hbox.addWidget(title)
        hbox.addStretch()

        try:
            get_connection().close()
            dot = QLabel("●  Connected")
            dot.setObjectName("conn_ok")
        except Exception:
            dot = QLabel("●  Disconnected")
            dot.setObjectName("conn_fail")

        hbox.addWidget(dot)
        return frame

    # ── tabs ─────────────────────────────────
    def _build_tabs(self) -> QTabWidget:
        tabs = QTabWidget()
        tabs.setDocumentMode(True)

        tab_defs = [
            (
                "👤  Users",
                "user_schema.users",
                [
                    {"name": "user_id",    "label": "ID",         "width": 60,  "pk": True, "auto": True},
                    {"name": "user_name",  "label": "Name",       "width": 160},
                    {"name": "email",      "label": "Email",      "width": 220},
                    {"name": "phone",      "label": "Phone",      "width": 130},
                    {"name": "address",    "label": "Address",    "width": 220},
                    {"name": "created_at", "label": "Created At", "width": 160, "auto": True},
                ],
            ),
            (
                "🏪  Restaurants",
                "restaurant_schema.restaurants",
                [
                    {"name": "restaurant_id",   "label": "ID",         "width": 60,  "pk": True, "auto": True},
                    {"name": "restaurant_name", "label": "Name",       "width": 220},
                    {"name": "address",         "label": "Address",    "width": 240},
                    {"name": "phone",           "label": "Phone",      "width": 130},
                    {"name": "created_at",      "label": "Created At", "width": 160, "auto": True},
                ],
            ),
            (
                "🍽  Menu Items",
                "restaurant_schema.menuitems",
                [
                    {"name": "menuitem_id",   "label": "ID",            "width": 60,  "pk": True, "auto": True},
                    {"name": "restaurant_id", "label": "Restaurant ID", "width": 110},
                    {"name": "item_name",     "label": "Item Name",     "width": 180},
                    {"name": "description",   "label": "Description",   "width": 200},
                    {"name": "price",         "label": "Price ($)",     "width": 90},
                    {"name": "rating",        "label": "Rating",        "width": 80},
                    {"name": "created_at",    "label": "Created At",    "width": 160, "auto": True},
                ],
            ),
            (
                "📦  Orders",
                "order_schema.orders",
                [
                    {"name": "order_id",      "label": "ID",            "width": 60,  "pk": True, "auto": True},
                    {"name": "user_id",       "label": "User ID",       "width": 80},
                    {"name": "restaurant_id", "label": "Restaurant ID", "width": 110},
                    {"name": "order_date",    "label": "Order Date",    "width": 160, "auto": True},
                    {"name": "status",        "label": "Status",        "width": 110},
                    {"name": "created_at",    "label": "Created At",    "width": 160, "auto": True},
                ],
            ),
            (
                "🛒  Order Items",
                "order_schema.order_items",
                [
                    {"name": "order_item_id", "label": "ID",          "width": 60,  "pk": True, "auto": True},
                    {"name": "order_id",      "label": "Order ID",    "width": 90},
                    {"name": "menuitem_id",   "label": "MenuItem ID", "width": 100},
                    {"name": "quantity",      "label": "Qty",         "width": 70},
                    {"name": "price",         "label": "Price ($)",   "width": 90},
                ],
            ),
            (
                "🚴  Drivers",
                "delivery_schema.delivery_drivers",
                [
                    {"name": "driver_id",   "label": "ID",         "width": 60,  "pk": True, "auto": True},
                    {"name": "driver_name", "label": "Name",       "width": 180},
                    {"name": "phone",       "label": "Phone",      "width": 140},
                    {"name": "created_at",  "label": "Created At", "width": 160, "auto": True},
                ],
            ),
            (
                "🚚  Deliveries",
                "delivery_schema.deliveries",
                [
                    {"name": "delivery_id",   "label": "ID",            "width": 60,  "pk": True, "auto": True},
                    {"name": "order_id",      "label": "Order ID",      "width": 90},
                    {"name": "driver_id",     "label": "Driver ID",     "width": 90},
                    {"name": "delivery_time", "label": "Delivery Time", "width": 160},
                    {"name": "status",        "label": "Status",        "width": 110},
                    {"name": "created_at",    "label": "Created At",    "width": 160, "auto": True},
                ],
            ),
        ]

        for label, table, cols in tab_defs:
            tabs.addTab(TableTab(table, cols), label)

        return tabs


# ─────────────────────────────────────────────
#  ENTRY POINT
# ─────────────────────────────────────────────
if __name__ == "__main__":
    app = QApplication(sys.argv)
    app.setStyleSheet(QSS)
    win = MainWindow()
    win.show()
    sys.exit(app.exec())
