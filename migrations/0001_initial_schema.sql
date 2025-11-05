-- Properties (物件) テーブル
CREATE TABLE IF NOT EXISTS properties (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  address TEXT NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Rooms (部屋) テーブル
CREATE TABLE IF NOT EXISTS rooms (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  property_id INTEGER NOT NULL,
  room_number TEXT NOT NULL,
  floor TEXT,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);

-- Contracts (契約) テーブル
CREATE TABLE IF NOT EXISTS contracts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  room_id INTEGER NOT NULL,
  contractor_name TEXT NOT NULL,
  tenant_name TEXT,
  rent INTEGER NOT NULL DEFAULT 0,
  management_fee INTEGER NOT NULL DEFAULT 0,
  parking_fee INTEGER NOT NULL DEFAULT 0,
  other_fee INTEGER NOT NULL DEFAULT 0,
  start_date TEXT NOT NULL,
  end_date TEXT,
  is_active INTEGER NOT NULL DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (room_id) REFERENCES rooms(id) ON DELETE CASCADE
);

-- Expenses (支出) テーブル
CREATE TABLE IF NOT EXISTS expenses (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  property_id INTEGER NOT NULL,
  year_month TEXT NOT NULL,
  item_name TEXT NOT NULL,
  description TEXT,
  amount INTEGER NOT NULL DEFAULT 0,
  tax INTEGER NOT NULL DEFAULT 0,
  total INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE
);

-- Reports (月次報告書) テーブル
CREATE TABLE IF NOT EXISTS reports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  property_id INTEGER NOT NULL,
  year_month TEXT NOT NULL,
  report_date TEXT NOT NULL,
  total_income INTEGER NOT NULL DEFAULT 0,
  total_expense INTEGER NOT NULL DEFAULT 0,
  net_income INTEGER NOT NULL DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (property_id) REFERENCES properties(id) ON DELETE CASCADE,
  UNIQUE(property_id, year_month)
);

-- インデックスの作成
CREATE INDEX IF NOT EXISTS idx_rooms_property_id ON rooms(property_id);
CREATE INDEX IF NOT EXISTS idx_contracts_room_id ON contracts(room_id);
CREATE INDEX IF NOT EXISTS idx_contracts_active ON contracts(is_active);
CREATE INDEX IF NOT EXISTS idx_expenses_property_id ON expenses(property_id);
CREATE INDEX IF NOT EXISTS idx_expenses_year_month ON expenses(year_month);
CREATE INDEX IF NOT EXISTS idx_reports_property_id ON reports(property_id);
CREATE INDEX IF NOT EXISTS idx_reports_year_month ON reports(year_month);

-- ==================== サンプルデータの投入 ====================

-- 物件データ
INSERT OR IGNORE INTO properties (id, name, address) VALUES 
  (1, 'シロハイヌ春日出', '〒659-0036 兵庫県芦屋市涼風町２５-１４');

-- 部屋データ
INSERT OR IGNORE INTO rooms (id, property_id, room_number, floor) VALUES 
  (1, 1, '201', '1階'),
  (2, 1, '202', '2階'),
  (3, 1, '203', '2階'),
  (4, 1, '301', '3階'),
  (5, 1, '302', '3階'),
  (6, 1, '303', '3階'),
  (7, 1, '401', '4階'),
  (8, 1, '402', '4階');

-- 契約データ（2025年9月分）
INSERT OR IGNORE INTO contracts (id, room_id, contractor_name, tenant_name, rent, management_fee, parking_fee, other_fee, start_date, is_active) VALUES 
  (1, 1, '株式会社八百鮮', NULL, 220000, 0, 0, 0, '2024-01-01', 1),
  (2, 2, '(空室)', NULL, 0, 0, 0, 0, '2024-01-01', 0),
  (3, 3, '阪神佐藤興産株式会社', NULL, 70400, 4400, 0, 0, '2024-01-01', 1),
  (4, 4, '三木健司', NULL, 56000, 3000, 0, 0, '2024-01-01', 1),
  (5, 5, '津和産業株式会社', NULL, 56000, 3000, 0, 0, '2024-01-01', 1),
  (6, 6, '山九近畿サービス株式会社', NULL, 57000, 3000, 0, 0, '2024-01-01', 1),
  (7, 7, 'TIMALSINA BISHNU PRASAD', NULL, 56000, 4000, 0, 0, '2024-01-01', 1),
  (8, 8, '津和産業株式会社', NULL, 55000, 3000, 0, 0, '2024-01-01', 1),
  (9, 7, '山九近畿サービス株式会社', NULL, 57000, 3000, 0, 0, '2024-01-01', 1);

-- 支出データ（2025年9月分）
INSERT OR IGNORE INTO expenses (property_id, year_month, item_name, description, amount, tax, total) VALUES 
  (1, '2025-09', '管理料', '', 19524, 1952, 21476),
  (1, '2025-09', '振込手数料', '', 600, 60, 660),
  (1, '2025-09', '日常清掃', '', 8000, 800, 8800),
  (1, '2025-09', '振込手数料', '', 600, 60, 660),
  (1, '2025-09', '電気料金', '7/24～8/26', 5859, 586, 6445);
